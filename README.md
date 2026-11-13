# NixOS/Home Manager Configuration

## Initialize `nix`

On a NixOS system, this is already done. Otherwise, install `nix` by itelf using the
multi-user installation.  

## Initialize user space for configuration

- `ssh-keygen` and add key to GitHub profile
- `nix-shell -p git home-manager neovim`
- `git clone git@github.com:carschandler/nixos.git`

## *Creating a user*

*This step shouldn't be necessary on a NixOS system, but can be done if desired. It might
be required on other distributions if they don't take care of this step during
setup/install.*
- Create a new user and add to the appropriate groups using whatever process the
  distribution recommends

## Applying configuration

### Home Manager

```
home-manager --extra-experimental-features "nix-command flakes" switch --flake ~/nixos#<hostname>
```
### NixOS

```
nixos-rebuild --extra-experimental-features "nix-command flakes" switch --flake ~/nixos#<hostname>
```

## Layout

This flake uses the [dendritic pattern](https://github.com/mightyiam/dendritic):
every `.nix` file under `modules/` is a [flake-parts](https://flake.parts) module,
loaded automatically by [import-tree](https://github.com/vic/import-tree). Files
are organized by *feature*, not by NixOS/darwin/home-manager, and a single file
can configure a feature for every class at once:

```nix
# modules/network/tailscale.nix
{
  flake.modules.nixos.tailscale = { services.tailscale.enable = true; };
  flake.modules.darwin.tailscale = { homebrew.casks = [ "tailscale-app" ]; };
}
```

Hosts then opt into the features they want:

```nix
# modules/hosts/<host>/default.nix
{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  configurations.nixos.<host>.module = {
    imports = with nixos; [ ./_hardware-configuration.nix workstation tailscale ];
    system.stateVersion = "25.05";
  };

  configurations.home."chan@<host>" = {
    system = "x86_64-linux";
    module = {
      imports = with homeManager; [ base linux-desktop ];
      home.stateVersion = "25.05";
    };
  };
}
```

- `modules/flake/` – the plumbing: `configurations.{nixos,darwin,home}` →
  flake outputs, and `meta` for shared data (`config.meta.users`, `.fonts`, `.network.lan`, `.fileshare`)
- `modules/profiles/` – bundles: `homeManager.base` (every home) and
  `nixos.workstation` (every non-server NixOS machine), `nixos.server` (headless machines)
- `modules/hosts/<host>/` – one directory per machine. Several files may
  contribute to the same `configurations.<class>.<host>.module`.
- Paths with a `_`-prefixed segment (`_hardware-configuration.nix`,
  `_disko.nix`, ...) are plain NixOS modules that import-tree skips; import
  them explicitly.
- `networking.hostName` defaults to the configuration's name.

## Adding a new configuration

- Create `modules/hosts/<host>/default.nix` as above
  - If using WSL, use [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) and its options
  - Ensure that new files have been added in git or the flake will not pick them up

## Darwin

`homebrew.enable` needs to be set to false on the first initialization so that
`nix-homebrew` can first install brew.

## Troubleshooting

- If no dotfiles are being loaded (i.e. neovim), `~/.config` may need to be created manually

## Homelab

Check details in `./system/homelab/README.md`
