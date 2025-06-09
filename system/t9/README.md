Before installing NixOS, I needed to:

- Copy the encryption secret to `/tmp/secret.txt` on the target system
- Add the following config to get it to boot (before configuring lanzaboote)
  ```
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  ```

The final `nixos-anywhere` command I ended up running from my mac:

```
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./system/t9/hardware-configuration.nix --flake ./#desktop-t9 --target-host nixos@192.168.13.52
```

Next, need to set up TPM and lanzaboote.
