//@ pragma UseQApplication
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Handy wave overlay: a white spectrum wave hugging the bottom edge of the
// bottom-most display. Layer-shell surface, click-through, never takes focus.
ShellRoot {
    id: root

    // ---- tunables -------------------------------------------------------
    readonly property real uiScale: 0.8      // scales width, height and glow together
    readonly property int waveWidth: Math.round(300 * uiScale)
    readonly property int waveHeight: Math.round(100 * uiScale)
    readonly property color waveColor: Qt.rgba(1, 1, 1, 0.6)   // slightly transparent white
    readonly property real glowRadius: 40 * uiScale     // soft frosted halo around the wave (0 = off)
    readonly property color glowColor: Qt.rgba(1, 1, 1, 0.85)
    // Rainbow: pastel gradient rolling slowly across the wave (rainbow=false -> white).
    readonly property bool rainbow: Quickshell.env("HANDY_WAVE_RAINBOW") !== "0"
    readonly property real rainbowPeriod: 14      // seconds for one full roll
    readonly property real rainbowSpan: 2.5       // palette cycle length, in wave widths
    readonly property real whiteMix: 0.5          // 0 = full colour, 1 = white
    readonly property var basePalette: ["#ff9fb8", "#ffb39a", "#ff9fd0", "#e0a6ff", "#b9a6ff", "#9db4ff", "#8fd5ff", "#b9a6ff"]
    readonly property var palette: rainbow
        ? basePalette.map(c => Qt.tint(c, Qt.rgba(1, 1, 1, whiteMix)))
        : ["white", "white"]
    readonly property real gain: 4.5        // pre-compression gain; lower = calmer peaks
    readonly property real compression: 0.65 // output exponent: 1 = off, lower = less dynamic range
    readonly property real blurSigma: 2.0   // spatial smoothing across bands (0 = off)
    readonly property real attack: 0.42     // per-frame lerp toward louder
    readonly property real release: 0.13    // per-frame lerp toward quieter
    readonly property int samples: 160      // points along the drawn curve
    // Envelope: sum of 7 raised-cosine bumps, each 10-40% of the full width.
    // c = centre (0..1), w = width (fraction of full width), a = relative weight.
    // Every bump lies inside [0, 1], so the sum is exactly 0 at both edges.
    readonly property var bumps: [
        { c: 0.40, w: 0.40, a: 1.00 },
        { c: 0.22, w: 0.30, a: 0.70 },
        { c: 0.62, w: 0.30, a: 0.65 },
        { c: 0.50, w: 0.35, a: 0.50 },
        { c: 0.80, w: 0.30, a: 0.45 },
        { c: 0.48, w: 0.10, a: 0.35 },
        { c: 0.72, w: 0.14, a: 0.40 }
    ]
    // Envelope sampled at samples+1 points, normalised so its peak is 1.
    readonly property var envelope: {
        const N = samples;
        const e = new Array(N + 1).fill(0);
        for (const b of bumps) {
            const lo = b.c - b.w / 2, hi = b.c + b.w / 2;
            for (let i = 0; i <= N; i++) {
                const x = i / N;
                if (x <= lo || x >= hi) continue;
                e[i] += b.a * 0.5 * (1 - Math.cos(2 * Math.PI * (x - lo) / b.w));
            }
        }
        const peak = Math.max(...e);
        return e.map(v => v / peak);
    }

    // Slow drift, off by default (opt in with HANDY_WAVE_DRIFT=1).
    readonly property bool drift: Quickshell.env("HANDY_WAVE_DRIFT") === "1"
    readonly property real driftRipple: 0.18  // amplitude modulation depth
    readonly property real driftSpeed: 0.35   // rad/s, lower = slower
    property real time: 0
    property bool awake: false   // frame loop only runs while there is sound

    // ---- spectrum state -------------------------------------------------
    property var target: new Array(48).fill(0)   // latest frame from cava, 0..1
    property var shown: []     // smoothed, what gets drawn

    function pickScreen() {
        const want = Quickshell.env("HANDY_WAVE_SCREEN");
        const all = Quickshell.screens;
        if (want) {
            for (const s of all) if (s.name === want) return s;
        }
        // default: the bottom-most display
        let best = all[0];
        for (const s of all) if (s.y > best.y) best = s;
        return best;
    }

    // ---- activity: only show while Handy is recording --------------------
    // HANDY_WAVE_ALWAYS=1 keeps the old always-on behaviour (rollback / debug).
    readonly property bool always: Quickshell.env("HANDY_WAVE_ALWAYS") === "1"
    property bool recording: false
    readonly property bool active: always || recording
    // Exit: no fade. The wave's amplitude decays to zero (ease-in cubic: starts
    // gently, accelerates toward zero), then the overlay turns off.
    readonly property int outroMs: 700
    property real fade: 0       // 1 while shown (visibility flag), 0 once fully decayed
    property real outro: 1      // amplitude multiplier, 1 -> 0 on exit
    NumberAnimation {
        id: outroAnim
        target: root; property: "outro"; to: 0
        duration: root.outroMs; easing.type: Easing.InCubic
        onFinished: root.fade = 0
    }

    // Activation: pop in instantly (no fade-in) and play a synthetic bounce on top
    // of the live mic level. kickT runs 0 -> kickDuration seconds.
    // Shape: the mic level is multiplied by a gain that rises from 0, overshoots
    // to ~kickOvershoot, then eases down onto exactly 1.0 (never below it).
    readonly property real kickOvershoot: 1.53 // gain at the peak (~1.5x natural level)
    readonly property real kickRise: 0.12      // seconds; time constant of the rise from 0
    readonly property real kickPeak: 0.45      // seconds; roughly when the overshoot peaks
    // So the bounce is visible even when the mic is quiet, a lumpy artificial
    // hump (never added on top of a loud signal) sets a floor while it lasts.
    readonly property real kickFloor: 0.5      // floor height, in units of the wave height
    readonly property real kickDuration: 6.0   // seconds before the bounce is ignored
    property real kickT: kickDuration
    NumberAnimation {
        id: kickAnim
        target: root; property: "kickT"; from: 0; to: root.kickDuration
        duration: root.kickDuration * 1000
    }
    // Pulse: 0 at t=0, 1 at t=kickPeak, then decays smoothly toward 0 (never negative).
    function kickPulse() {
        const t = kickT;
        if (t >= kickDuration) return 0;
        return (t / kickPeak) * Math.exp(1 - t / kickPeak);
    }
    // Gain applied to the live mic level: 0 -> ~kickOvershoot -> 1.0, no undershoot.
    function kickGain() {
        const t = kickT;
        if (t >= kickDuration) return 1;
        return (1 - Math.exp(-t / kickRise)) * (1 + (kickOvershoot - 1) * kickPulse());
    }
    // Artificial floor height at position x (0..1): positive, lumpy in x and time,
    // 0 at t=0 and fading to 0. `pulse` is kickPulse() computed once per frame.
    function kickFloorAt(x, pulse) {
        if (pulse <= 0) return 0;
        const t = kickT;
        const TAU = 2 * Math.PI;
        const x2 = 0.5 + 0.5 * Math.sin(TAU * 1.3 * x + 0.8);
        const x3 = 0.5 + 0.5 * Math.sin(TAU * 2.1 * x + 2.4);
        const lump = 0.6 + 0.4 * (0.5 * x2 * (0.5 + 0.5 * Math.sin(TAU * t / 1.55))
                                + 0.5 * x3 * (0.5 + 0.5 * Math.sin(TAU * t / 1.0 + 1.3)));
        return kickFloor * pulse * lump;
    }
    onActiveChanged: {
        if (active) {
            outroAnim.stop();
            outro = 1;
            fade = 1;
            kickAnim.restart();
            awake = true;
        } else {
            outroAnim.restart();
        }
    }

    // Emits "active" / "idle" as Handy opens / closes its mic stream.
    Process {
        id: watcher
        running: !root.always
        command: [Quickshell.env("HANDY_WAVE_WATCH") || "handy-watch"]
        stdout: SplitParser {
            onRead: line => {
                if (line === "active") root.recording = true;
                else if (line === "idle") root.recording = false;
            }
        }
        // PipeWire restarted or the watcher died: don't get stuck "recording".
        onExited: {
            root.recording = false;
            restartWatcher.start();
        }
    }
    Timer {
        id: restartWatcher
        interval: 2000
        onTriggered: watcher.running = !root.always
    }

    // Spectrum feed (cava on the mic). Runs only while visible: no mic stream
    // and no CPU when Handy is idle.
    Process {
        id: feed
        running: root.active || root.fade > 0
        // Wave relaxes to flat when the feed stops.
        onRunningChanged: if (!running) {
            root.target = root.target.map(() => 0);
            root.awake = true;
        }
        command: [Quickshell.env("HANDY_WAVE_FEED") || "wave-feed"]
        stdout: SplitParser {
            onRead: line => {
                const parts = line.split(";");
                const out = [];
                for (const p of parts) {
                    if (p === "") continue;
                    out.push(Math.min(1, Number(p) / 1000));
                }
                if (out.length) {
                    root.target = out;
                    if (out.some(x => x > 0)) root.awake = true;
                }
            }
        }
    }

    // ---- wave geometry (pure functions) ---------------------------------

    // Catmull-Rom interpolation through the band values; x in [0, 1].
    function sample(v, x) {
        const n = v.length;
        const f = x * (n - 1);
        const i = Math.floor(f);
        const t = f - i;
        const p0 = v[Math.max(i - 1, 0)];
        const p1 = v[i];
        const p2 = v[Math.min(i + 1, n - 1)];
        const p3 = v[Math.min(i + 2, n - 1)];
        return 0.5 * ((2 * p1) + (-p0 + p2) * t
            + (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t
            + (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t);
    }

    // Gaussian smoothing across neighbouring bands.
    function blur(v, sigma) {
        if (sigma <= 0 || v.length < 2) return v;
        const r = Math.ceil(sigma * 3);
        const k = [];
        let sum = 0;
        for (let j = -r; j <= r; j++) {
            const w = Math.exp(-(j * j) / (2 * sigma * sigma));
            k.push(w);
            sum += w;
        }
        const out = new Array(v.length);
        for (let i = 0; i < v.length; i++) {
            let acc = 0;
            for (let j = -r; j <= r; j++) {
                const idx = Math.min(v.length - 1, Math.max(0, i + j));
                acc += v[idx] * k[j + r];
            }
            out[i] = acc / sum;
        }
        return out;
    }

    // Polygon (bottom-left -> curve -> bottom-right) for the current frame.
    function buildPoints(v, w, h) {
        const b = blur(v, blurSigma);
        const N = samples;
        const ph = time * driftSpeed;
        const kg = kickGain();
        const kp = kickPulse();
        // Heights in px above the baseline, one per sample.
        const hs = new Array(N + 1);
        for (let i = 0; i <= N; i++) {
            const x = i / N;
            const win = envelope[i];
            // Drift: slow, out-of-phase ripple so the wave never repeats exactly.
            const m = drift
                ? 1 + driftRipple * Math.sin(2 * Math.PI * x * 1.3 + ph + 1.7)
                        * Math.sin(ph * 0.63 + x * 3.1)
                : 1;
            // tanh soft-limit: peaks approach 1 gradually instead of clipping.
            // Then a power curve: exponent < 1 lifts the quiet end toward the loud end
            // (less dynamic range) while the ceiling stays put (1^p = 1).
            const a = Math.pow(Math.tanh(Math.max(0, sample(b, x)) * m * gain), compression);
            // Bounce is applied after the soft limit so it can overshoot: the mic
            // level is scaled by kickGain (0 -> ~1.5 -> 1.0), and the artificial
            // floor only shows when it is higher than that (i.e. quiet mic).
            const total = Math.max(0, Math.min(1.6, Math.max(a * kg, kickFloorAt(x, kp))));
            const px = total * outro * win * waveHeight;
            hs[i] = px < 0.05 ? 0 : px;   // snap slivers to the baseline exactly
        }

        // Build the polygon without degenerate geometry: the envelope is exactly
        // zero over wide stretches, which would otherwise give dozens of collinear
        // points along the baseline (and duplicate corners). Curve-based renderers
        // handle that badly. Keep only the ends of each baseline run; the closing
        // edge back to the first point runs along the baseline.
        const pts = [];
        for (let i = 0; i <= N; i++) {
            const interiorOfRun = i > 0 && i < N && hs[i] === 0 && hs[i - 1] === 0 && hs[i + 1] === 0;
            if (interiorOfRun) continue;
            pts.push(Qt.point(i / N * w, h - hs[i]));
        }
        return pts;
    }

    PanelWindow {
        id: win
        screen: root.pickScreen()
        // Always mapped: Quickshell exits when its last window closes. When idle the
        // content is at opacity 0 (nothing rendered) and the surface is click-through.

        anchors.bottom: true
        implicitWidth: root.waveWidth
        implicitHeight: root.waveHeight + Math.ceil(root.glowRadius * 1.5)   // headroom so the glow is not clipped
        exclusionMode: ExclusionMode.Ignore
        color: "transparent"
        mask: Region {}   // empty input region: clicks pass through

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "handy-wave"
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        property var points: []
        property bool wasMoving: false

        // Smooth toward target every frame; rebuild geometry only while moving.
        FrameAnimation {
            running: root.awake
            onTriggered: {
                root.time = elapsedTime;
                const t = root.target;
                if (!t.length) return;
                let s = root.shown;
                if (s.length !== t.length) s = new Array(t.length).fill(0);
                let moving = false;
                for (let i = 0; i < t.length; i++) {
                    const k = t[i] > s[i] ? root.attack : root.release;
                    const v = s[i] + (t[i] - s[i]) * k;
                    s[i] = v < 0.0005 ? 0 : v;
                    if (s[i] > 0 || t[i] > 0) moving = true;
                }
                root.shown = s;
                // One extra update after motion stops so the last frame is flat.
                if (kickAnim.running || outroAnim.running) moving = true;   // keep drawing during the bounce
                if (moving || win.wasMoving)
                    win.points = root.buildPoints(s, win.width, win.height);
                win.wasMoving = moving;
                if (!moving) root.awake = false;
            }
        }

        // GPU glow: a separate, blurred copy of the wave behind the crisp one.
        // (Its own Shape: sharing the crisp wave's texture via MultiEffect
        // made the crisp wave stop short of the screen edge.)
        Shape {
            anchors.fill: parent
            visible: root.glowRadius > 0
            opacity: root.glowColor.a * root.fade
            layer.enabled: visible
            layer.effect: MultiEffect {
                blurEnabled: true
                blur: 1.0
                blurMax: root.glowRadius
            }
            ShapePath {
                fillGradient: RainbowGradient {
                    palette: root.palette
                    alpha: 1
                    span: root.waveWidth * root.rainbowSpan
                    offset: (root.time / root.rainbowPeriod * span) % span
                }
                strokeColor: "transparent"
                strokeWidth: 0
                PathPolyline { path: win.points }
            }
        }

        Shape {
            id: shape
            anchors.fill: parent
            opacity: root.fade
            layer.enabled: true
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                fillGradient: RainbowGradient {
                    palette: root.palette
                    alpha: root.waveColor.a
                    span: root.waveWidth * root.rainbowSpan
                    offset: (root.time / root.rainbowPeriod * span) % span
                }
                strokeColor: "transparent"
                strokeWidth: 0
                PathPolyline { path: win.points }
            }
        }
    }
}
