{ config, pkgs, ... }:

{
  home.username = "megh";
  home.homeDirectory = "/home/megh";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.file.".local/share/color-schemes/BreezeDark.colors".source =
    "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeDark.colors";

  home.file.".local/share/color-schemes/BreezeLight.colors".source =
    "${pkgs.kdePackages.breeze}/share/color-schemes/BreezeLight.colors";
}
