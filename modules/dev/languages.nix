{
  # Language tooling: LSPs, formatters, debuggers, package managers
  flake.modules.homeManager.languages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # language tools
        pnpm

        # language servers
        basedpyright
        bash-language-server
        efm-langserver
        lua-language-server
        nil
        pyright
        typescript-language-server
        yaml-language-server

        # debuggers (prefer to install as a language dev dependency)
        vscode-js-debug

        # formatters/linters
        black
        isort
        nixfmt
        prettier
        stylua
      ];

      programs = {
        helix = {
          enable = true;
        };

        uv.enable = true;
        bun.enable = true;
      };
    };
}
