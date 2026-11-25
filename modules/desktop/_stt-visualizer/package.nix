{
  lib,
  stdenvNoCC,
  makeWrapper,
  quickshell,
  cava,
  pipewire,
  wireplumber,
  jq,
  gawk,
  gnused,
  coreutils,
  procps,
}:
let
  # Everything the helper scripts shell out to.
  scriptPath = lib.makeBinPath [
    cava # spectrum analysis of the mic
    pipewire # pw-dump: watch for Handy's capture stream
    wireplumber # wpctl: find the default mic
    jq
    gawk
    gnused # parses wpctl's output for the mic's node name
    coreutils
    procps # pkill: clean up children on exit
  ];
in
stdenvNoCC.mkDerivation {
  pname = "stt-visualizer";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 shell.qml RainbowGradient.qml -t $out/share/stt-visualizer

    install -Dm755 bin/wave-feed $out/libexec/stt-visualizer/wave-feed
    install -Dm755 bin/handy-watch $out/libexec/stt-visualizer/handy-watch
    patchShebangs $out/libexec/stt-visualizer

    makeWrapper $out/libexec/stt-visualizer/wave-feed $out/bin/stt-wave-feed \
      --prefix PATH : ${scriptPath}
    makeWrapper $out/libexec/stt-visualizer/handy-watch $out/bin/stt-watch \
      --prefix PATH : ${scriptPath}

    install -Dm755 bin/stt-visualizer $out/bin/stt-visualizer
    patchShebangs $out/bin/stt-visualizer
    substituteInPlace $out/bin/stt-visualizer \
      --subst-var-by share $out/share/stt-visualizer \
      --subst-var-by feed $out/bin/stt-wave-feed \
      --subst-var-by watch $out/bin/stt-watch \
      --subst-var-by quickshell ${lib.getExe quickshell}

    runHook postInstall
  '';

  meta = {
    description = "Quickshell layer-shell overlay that animates a spectrum wave while Handy records";
    mainProgram = "stt-visualizer";
    platforms = lib.platforms.linux;
  };
}
