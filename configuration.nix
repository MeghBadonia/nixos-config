{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  # ── Boot ──────────────────────────────────────────────────────────────────
  boot = {
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvidia-drm.fbdev=1"
      "nvidia-drm.modeset=1"
      "quiet"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
      };
      timeout = 0;
    };
    plymouth = {
      enable = true;
    };
  };

  # ── System Packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    chromium
    easyeffects
    hyprpaper
    hyprpolkitagent
    kdePackages.breeze
    kdePackages.breeze-icons
    kitty
    matugen
    micro
    nautilus
    nwg-look
    pavucontrol
    polychromatic
    rofi
    vscode
    wget
    zed-editor
    # qt6ct patched with KDE color scheme support
    (kdePackages.qt6ct.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs or []) ++ [
        pkgs.kdePackages.kcolorscheme
        pkgs.kdePackages.kconfig
      ];
      patches = (oldAttrs.patches or []) ++ [
        (pkgs.fetchurl {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/qt6ct-shenanigans.patch?h=qt6ct-kde";
          hash = "sha256-gXtwFPLT4e6Y3Y3NdEltOkSFj6cUOAZMqrqLxatR5Pk=";
        })
      ];
    }))
  ];

  # ── Fonts ─────────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    adwaita-fonts
    inter
    liberation_ttf
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  # ── Hardware ──────────────────────────────────────────────────────────────
  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = true;
    };
    openrazer.enable = true;
  };

  # ── Home Manager ──────────────────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.megh = import ./home.nix;
  };

  # ── Locale & Time ─────────────────────────────────────────────────────────
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Asia/Kolkata";

  # ── Networking ────────────────────────────────────────────────────────────
  networking = {
    hostName = "nixy";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  # ── Nix ───────────────────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── Programs ──────────────────────────────────────────────────────────────
  programs = {
    dms-shell = {
      enable = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
      enableDynamicTheming = true;
      enableSystemMonitoring = true;
      enableVPN = true;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };
    };
    git.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
  };

  # ── Security ──────────────────────────────────────────────────────────────
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # ── Services ──────────────────────────────────────────────────────────────
  services = {
    gvfs.enable = true;
    openssh.enable = true;
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    printing.enable = true;
    udisks2.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  # ── System ────────────────────────────────────────────────────────────────
  system = {
    copySystemConfiguration = true;
    stateVersion = "26.11"; # Do not change after initial install
  };

  # ── Users ─────────────────────────────────────────────────────────────────
  users.users.megh = {
    extraGroups = [ "networkmanager" "openrazer" "wheel" ];
    isNormalUser = true;
    packages = with pkgs; [
      tree
    ];
  };
}
