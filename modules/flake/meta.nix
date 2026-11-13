{ lib, ... }:
{
  # Plain data shared across modules (users, fonts, ...) that isn't itself a
  # NixOS/darwin/home-manager module. Read it as `config.meta.<name>` from the
  # flake-parts level, e.g. `config.meta.users.main.username`.
  options.meta = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
  };
}
