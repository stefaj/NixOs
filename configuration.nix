# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "stefanix"; # Define your hostname.

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };
  fonts = {
    fonts = with pkgs; [
	dejavu_fonts
 	source-serif-pro
        terminus_font
    ];
  };

  # Set your time zone.
  time.timeZone = "Africa/Johannesburg";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pkgs.dmenu2 
    vim 
    wget 
    git 
    rxvt_unicode 
    chromium 
    cabal-install
    ghc
    vimPlugins.pathogen
    ranger
    vlc
    mplayer
    nodejs
    gimp
    gcc
    cabal2nix
    # haskell.compiler.ghcjs
    stack
    openjdk
    idea.android-studio
    automake
    autoconf
    pkgs.zlib 
    libzip
  ];

  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Graphics Drivers
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  security.sudo.enable = true;
  security.sudo.extraConfig = ''stefan ALL=(ALL) SETENV: ALL'';

  services.xserver.windowManager = {
    i3-gaps.enable = true;
   default = "i3-gaps";
  };

  services.xserver.synaptics.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.stefan = {
     shell = "/run/current-system/sw/bin/zsh";
     isNormalUser = true;
     extraGroups = ["networkmanager" "wheel"];
     uid = 1000;
  };
  users.extraUsers.codeworld = {
     shell = "/run/current-system/sw/bin/zsh";
     isNormalUser = true;
     extraGroups = ["networkmanager" "wheel"];
     uid = 1001;
  };




nixpkgs.config = {

    allowUnfree = true;

    firefox = {
     enableGoogleTalkPlugin = true;
     enableAdobeFlash = true;
    };

    chromium = {
     enablePepperFlash = true; 
     enablePepperPDF = true;
    };
 };



  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
