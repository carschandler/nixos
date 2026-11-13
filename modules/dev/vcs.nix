{
  flake.modules.homeManager.vcs = {
    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = "carschandler";
            email = "92899389+carschandler@users.noreply.github.com";
          };
          alias = {
            lg = "log --all --oneline --graph --color=always --decorate";
            lgg = "log --oneline --graph --color=always --decorate";
          };
          pull.rebase = true;
          push.autoSetupRemote = true;
        };
        ignores = [
          "*.DS_Store"
        ];

        signing.format = null;
      };

      jujutsu = {
        enable = true;
        settings = {
          user = {
            name = "carschandler";
            email = "92899389+carschandler@users.noreply.github.com";
          };
          ui.default-command = "log";
          template-aliases = {
            "format_short_signature(signature)" = "signature.name()";
          };
          aliases = {
            la = [
              "log"
              "-r"
              "all()"
            ];
            lb = [
              "log"
              "-r"
              "(main..@)::"
            ];
            db = [
              "diff"
              "-r"
              "(main..@)::"
            ];
            newleaf = [
              "new"
              "heads(@::)"
            ];
          };
        };
      };
    };
  };
}
