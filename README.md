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
home-manager --extra-experimental-features "nix-command flakes" switch --flake ~/nixos#chan@<hostname>
```
### NixOS

```
nixos-rebuild --extra-experimental-features "nix-command flakes" switch --flake ~/nixos#chan@<hostname>
```

## Adding a new configuration

- Make new entries in `flake.nix` for `nixosConfigurations` and `homeConfigurations`
- Add configuration to `system` directory as appropriate (`named_subdirectory/default.nix`)
  - Don't forget `networking.hostName` so that the system will be renamed properly
  - If using WSL, use [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) and its options
  - Ensure that new files have been added in git or the flake will not pick them up

## Troubleshooting

- If no dotfiles are being loaded (i.e. neovim), `~/.config` may need to be created manually
