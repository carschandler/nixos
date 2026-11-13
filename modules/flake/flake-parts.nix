{ inputs, ... }:
{
  # Provides the `flake.modules.<class>.<name>` option that every feature
  # module in this tree writes to.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [
    "x86_64-linux"
    "aarch64-darwin"
  ];

  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt;
    };
}
