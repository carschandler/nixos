# Homelab Setup

## ZFS

I mostly messed with `disko` examples until I got something that worked. One
quirk was that I had issues making the root partition encrypted so I ended up
just making the flash storage encrypted. I also thought I needed to change my
`networking.hostId` to match `/etc/machine-id`, but I think this is arbitrary
and I had already set up the ZFS pools with an old ID from a previous build, so
changing it prevented me from importing the pools. So, I just left it and they
don't match but this shouldn't matter.

## Decrypting LUKS Partition via TPM

I used [this guide](https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/) to set
up secure boot/TPM and decrypt my LUKS partition (created in `./disko.nix`)
automatically. The main steps are:

```bash
sudo nix run nixpkgs#sbctl create-keys
# Ensure configuration is set up between these steps
sudo nix run nixpkgs#sbctl verify
sudo nix run nixpkgs#sbctl enroll-keys -- --microsoft
bootctl status
```

And the following configuration options are required:

```nix
# flake.nix
{
  lanzaboote = {
    url = "github:nix-community/lanzaboote";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  homelab = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
    };
    modules = [
      ./system/homelab
      disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
    ];
  };
}

# System configuration
{
  # Enabled by default, shouldn't be required
  # boot.bootspec.enabled = true;

  boot = {
    # Required to decrypt automatically during boot
    initrd.systemd.enable = true;

    # lanzaboote replaces systemd-boot
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  environment.systemPackages = [
    pkgs.sbctl
  ];
}
```
