{
  # Home LAN addressing, shared by the hosts that live on it
  meta.network.lan = rec {
    prefix = "10.12.23";
    prefixLength = 24;
    gateway = "${prefix}.1";
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
    hosts = {
      homelab = "${prefix}.2";
      desktop = "${prefix}.3";
    };
  };
}
