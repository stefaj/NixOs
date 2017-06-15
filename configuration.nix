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
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.extraEntries = ''
    menuentry 'Windows 7' {
        set root='(hd0,1)'
      chainloader +1   
    }
  '';



  networking.hostName = "stefanix"; # Define your hostname.
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

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

  # Docker
  # virtualisation.docker.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pkgs.dmenu2 
    vim 
    aws
    wget 
    firefox
    samba
    git 
    rxvt_unicode 
    chromium 
    google-chrome
    cabal-install
    ghc
    vimPlugins.pathogen
    ranger
    irssi
    scrot
    vlc
    mplayer
    gimp
    tor
    torbrowser
    electrum
    monero
    cabal2nix
    # haskell.compiler.ghcjs
    stack
    automake
# android stuff
    androidsdk
    android-studio
    libmtp 
    jmtpfs
# end android stuff
    autoconf
    gnum4
    zlib 
    z3
    unzip
    libtool
    libffi
    xsel
    cmake
    xclip
    emacs
    gephi
    ib-tws
    oraclejdk8
    oraclejre8
    patchelf
    gradle
    evince
    neovim
    cudatoolkit
    gnumake
    file
    pciutils
    maven
    inkscape
    texlive.combined.scheme-full
    python27Packages.pip
    python2
    ruby
    jekyll
    jabref
    boost
    boost-build
    boost_process
    imagemagick
    i3lock-color
    calibre
    python3
    python35Packages.pip
    python35Packages.jupyter
    python35Packages.matplotlib
    python35Packages.pandas
    python35Packages.numpy
    python35Packages.scikitlearn
    python35Packages.numpy
    freetype
    libpng
    ntfs3g
    gcc6
    blas
    liblapack
    wpa_supplicant
    wpa_supplicant_gui
    R
    monodevelop
    mono46
    mono-addins
    python27Packages.ply
    python35Packages.ply
    ctags
    cpuminer-multi
    dotnetPackages.Nuget
#.Net
    vscode
    coreclr
    fsharp
    boost
    rustBeta.cargo
    rustBeta.rustc
    go
  ];

  virtualisation.virtualbox.host.enable = true;

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

  services.xserver.displayManager.slim.enable = true;
  services.xserver.displayManager.slim.theme = pkgs.fetchurl {
      url = "https://github.com/edwtjo/nixos-black-theme/archive/v1.0.tar.gz";
      sha256 = "13bm7k3p6k7yq47nba08bn48cfv536k4ipnwwp1q1l2ydlp85r9d";
    };

  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.package = pkgs.i3-gaps;

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


services.samba = {
    enable = true;
    shares = {
      movies =
        { path = "/mnt/media/Movies";
          "read only" = "yes";
          browseable = "yes";
          "guest ok" = "yes";
        };
      music =
        { path = "/mnt/media/Music";
          "read only" = "yes";
          browseable = "yes";
          "guest ok" = "yes";
        };
      installations =
        { path = "/mnt/media/Installations";
          "read only" = "yes";
          browseable = "yes";
          "guest ok" = "yes";
        };
    };
    extraConfig = ''
    	guest account = smbguest
    	map to guest = bad user
    '';
  };


users.extraUsers.smbguest = 
    { name = "smbguest";
      uid  = config.ids.uids.smbguest;
      description = "smb guest user";
    };

  networking.firewall.allowedTCPPorts = [ 445 139 80 8080 8000 10000 10001 10002 5555 5556 1111 1112];
  networking.firewall.allowedUDPPorts = [ 137 138 10000 10001 10002];
  networking.firewall.enable = false;




nixpkgs.config = {

    allowUnfree = true;

    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    chromium = {
#     enablePepperFlash = true; 
#     enablePepperPDF = true;
    };
 };

  environment.variables."SSL_CERT_FILE" = "/etc/ssl/certs/ca-bundle.crt";

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  # Development stuff
  # reflex platform
  nix.trustedBinaryCaches = [ "https://nixcache.reflex-frp.org" ];
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];

}
