import QtQuick
import QtQuick.Shapes

// Horizontal, repeating, scrolling gradient through a palette (first colour
// repeated at the end so the loop is seamless).
LinearGradient {
    id: g

    property var palette: ["white", "white"]   // >= 2 colours
    property real alpha: 1
    property real span: 300      // px for one full palette cycle
    property real offset: 0      // px; increasing rolls the pattern rightwards

    x1: offset
    y1: 0
    x2: offset + span
    y2: 0
    spread: ShapeGradient.RepeatSpread

    // Stops are built from the palette once, and rebuilt if it changes.
    property var _stops: []
    function rebuild() {
        for (const s of _stops) s.destroy();
        const out = [];
        const n = palette.length;
        for (let i = 0; i <= n; i++) {
            const s = Qt.createQmlObject(
                'import QtQuick; import QtQuick.Shapes; GradientStop {}', g);
            s.position = i / n;
            s.color = Qt.alpha(palette[i % n], alpha);
            out.push(s);
        }
        _stops = out;
        stops = out;
    }
    Component.onCompleted: rebuild()
    onPaletteChanged: rebuild()
    onAlphaChanged: rebuild()
}
