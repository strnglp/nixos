# Baseline configuration for a gnome based system.
{ pkgs, inputs, ...}:
let
home-manager = inputs.home-manager;
in
{
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It's perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
# Allow Discord, Steam, etc.
    nixpkgs.config.allowUnfree = true;

    imports = [
      home-manager.nixosModules.home-manager 
      {
# Enable installation of user packages through the users.users.<name>.packages.
        home-manager.useUserPackages = true;
# Enable using the system configuration’s pkgs argument in Home Manager.
        home-manager.useGlobalPkgs = true;
# Used to pass additional arguments to all modules.
        home-manager.extraSpecialArgs = { inherit inputs; };
      }
    ];

# Select internationalisation properties
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

# Service configuration
    services = { 
# Note: this is a misnomer, the system uses Wayland
      xserver = {
        enable = true;
        xkbOptions = "ctrl:swapcaps";
        libinput.enable = true;
        layout = "us";
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
# Allow passworded ssh login, todo: ssh-key only
      openssh.enable = true;
    };

# Configure environment
    environment = {

# Ommit a bunch of gnome cruft
      gnome.excludePackages = (with pkgs; [
          gnome-photos
          gnome-tour
      ]) ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        gedit # text editor
        epiphany # web browser
        geary # email reader
        evince # document viewer
        gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
#noXlibs = true;

# Faster shell for non-interaciveprogram execution
      binsh = "${pkgs.dash}/bin/dash";

# System wide packages
      systemPackages = (with pkgs; [
          wl-clipboard
          unzip
          dash
          tmux
          exa
          wget 
          git
          firefox
          pop-launcher
      ]) ++ (with pkgs.gnome; [
# Gnome packages
        adwaita-icon-theme
        gnome-tweaks
      ]) ++ (with pkgs.gnomeExtensions; [
# Gnome Extensions
        pop-shell
        switch-focus-type
        night-theme-switcher
      ]);
    };

# Configure fonts but don't download every single Nerdfont
    fonts = {
      fontconfig.enable = true;
      packages = with pkgs; [
        (nerdfonts.override { 
         fonts = [ "Hack" "FiraCode" "JetBrainsMono" ]; 
         })
      liberation_ttf
      ];
    };


# Program configuration
    programs = {
# The default shell is bash - make it useable
      bash.interactiveShellInit = ''
        set -o vi
        '';
# Neovim instead of vim
      neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };

    firefox = {
      enable = true;
      policies = {
        DisablePocket = true;
	DontCheckDefaultBrowser = true;
	EnableTrackingProtection = true;
	Homepage = "https://www.google.com";
	NoDefaultBookmarks = true;
	OfferToSaveLogins = false;
	OfferToSaveLoginsDefault = false;
	PasswordManagerEnabled = false;
	SearchEngine = { Default = "Google"; };
	SearchSuggestEnabled = false;
	UserMessaging =  {
	  WhatsNew = false;
          ExtensionRecommendations = false;
	  FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
	};
      };
    };
  };
}
