{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.incus = {
    virtualisation.incus.enable = true;
    networking.nftables.enable = true;
    users.groups.incus-admin.members = config.flake.users.admins
    # virtualisation.incus.preseed = {
    #   networks = [
    #     {
    #       config = {
    #         "ipv4.address" = "10.0.0.1/24";
    #         "ipv4.nat" = "true";
    #       };
    #       name = "docker0";
    #       type = "bridge";
    #     }
    #   ];
    #   profiles = [
    #     {
    #       devices = {
    #         eth0 = {
    #           name = "eth0";
    #           network = "docker0";
    #           type = "nic";
    #         };
    #         root = {
    #           path = "/";
    #           pool = "default";
    #           size = "20GiB";
    #           type = "disk";
    #         };
    #       };
    #     }
    #   ];
    # };
  };


}
