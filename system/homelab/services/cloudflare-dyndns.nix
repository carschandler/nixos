{ ... }:
{
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = "/keep/cloudflare-keys/api-key";
    ipv6 = true;
    ipv4 = false;
    domains = [ "srv.carschandler.com" ];
  };
}
