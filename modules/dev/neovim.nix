{
  flake.modules.nixos.neovim = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };

  flake.modules.homeManager.neovim =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/nixos/dotfiles";
    in
    {
      programs.neovim = {
        enable = true;

        # Ensure that neovim has access to gcc from nix, not whatever the system's
        # gcc is. This is so treesitter doesn't freak out.
        extraWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ pkgs.gcc ]}"
        ];

        extraPackages = [
          pkgs.luajitPackages.tree-sitter-cli
        ];

        # Trying out this version now that we don't have gcc installed by default
        # so that we don't have to rebuild neovim every time. NOTE: works on some
        # systems but on others there is a different gcc that is further up in the
        # path and overrides.
        # extraPackages = [ pkgs.gcc ];

        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withRuby = false;
        withPython3 = true;

        # Prevent home-manager from writing .config/nvim/init.lua, which
        # collides with the mkOutOfStoreSymlink of .config/nvim below.
        sideloadInitLua = true;
      };

      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim/dot-config/nvim";

      home.sessionVariables = {
        EDITOR = "nvim";
        NVIMCFG = "${dotfiles}/nvim/dot-config/nvim";
        PLUGDIR = "${dotfiles}/nvim/dot-config/nvim/lua/user/plugins";
      };
    };
}
