# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./git.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable copy and paste from host machine
  services.spice-vdagentd.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tom = {
    isNormalUser = true;
    description = "Tom Britton";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "tom";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow Chromium ffmpeg codecs
  nixpkgs.config.allowUnsupportedSystem = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    spice-vdagent
    alacritty
    vivaldi
    vivaldi-ffmpeg-codecs
    xclip
    neovim
    gcc
    gnumake
    cmake
    pkg-config
    nodejs_22
    unzip
    python3
    lua
    luarocks
    ripgrep
    typescript
    typescript-language-server
    go
    gopls
    tree-sitter
    python312Packages.pip
  ];

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host github.com
        User git
        IdentityFile ~/.ssh/id_ed25519 
    '';
  };

  networking = {
    nameservers = [ 
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  # Aliases
  environment.shellAliases = {
    clip = "xclip -selection clipboard <";
    rebuild = "sudo nixos-rebuild switch";
    config = "nvim ~/configuration.nix";
    rg = "ripgrep";  
};

  system.activationScripts.cloneNvimConfig = {
    text = ''
      echo "=== STARTING NVIM CONFIG SETUP ==="
      USER_HOME=/home/tom
      echo "Current user: $USER"
      echo "Home directory: $USER_HOME"
      if [ ! -d "$USER_HOME/.config" ]; then
        echo "Creating .config directory..."
        mkdir -p "$USER_HOME/.config"
      fi
      if [ ! -d "$USER_HOME/.config/nvim" ]; then
        echo "Creating nvim directory..."
        mkdir -p "$USER_HOME/.config/nvim"
        echo "Attempting to clone repository..."
        ${pkgs.git}/bin/git clone https://github.com/tmbritton/kickstart.nvim.git $USER_HOME/.config/nvim
        echo "Clone command completed with status: $?"
      fi
      chown -R tom:users $USER_HOME/.config/nvim
      echo "=== NVIM CONFIG SETUP COMPLETE ==="
    '';
    deps = [];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
