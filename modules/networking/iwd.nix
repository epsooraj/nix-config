{
  networking.wireless.iwd = {
    enable = true;
    settings = {
      General.EnableNetworkConfiguration = true;
      Network.NameResolvingService = "systemd";
      Settings.AutoConnect = true;
    };
  };

  services.resolved.enable = true;
  networking.dhcpcd.denyInterfaces = [ "wlan*" "wlp" ];
}
