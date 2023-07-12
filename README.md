To start up a new system:
- Make new entries in `flake.nix` for `nixosConfigurations` and
  `homeConfigurations`
- Add configuration to `system` directory as appropriate
- `nix-shell -p git home-manager`
  - Ensure that files have been added to git
  - `sudo nixos-rebuild switch --flake .#<hostname>`
  - May need to restart at this point?
  - `home-manager switch --flake .#<username>@<hostname>`

