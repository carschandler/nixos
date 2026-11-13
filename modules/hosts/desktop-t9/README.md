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

```
# If using an impermanence setup, ensure the keys are placed in a persistent
# location and read from there using /etc/sbctl/sbctl.conf.
# The `boot.lanzaboote.pkiBundle` should be the parent dir of `keys/`
sudo sbctl create-keys
sudo nixos-rebuild switch
sudo sbctl verify
sudo reboot
# Enable secureboot, ensure "external" keys are loaded and not factory ones,
# enable UEFI password
sudo sbctl enroll-keys --microsoft
sudo bootctl status
# The correct partition should tab-complete below
sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+2+7+12 --wipe-slot=tpm2 /dev/<luks-partition>
# Should prompt for encryption password here
```
