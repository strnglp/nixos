# A combination of configuration.nix and hardware-configuration.nix for my thinkpad
{ inputs, modulesPath, pkgs, lib, config,... }:

{
  imports = [ 
# No wifi driver without this, TODO: look into what exactly this does
    (modulesPath + "/installer/scan/not-detected.nix")
# Hardware quirks
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-yoga
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/06971657-f739-47e1-9f2c-3ae872e9f5cc";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/06971657-f739-47e1-9f2c-3ae872e9f5cc";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/06971657-f739-47e1-9f2c-3ae872e9f5cc";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" "nodiratime" "discard" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/94B4-0714";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/71a135e5-792d-4f8d-9243-4b6abe9f3698"; 
        options = [ "noatime" "nodiratime" "discard" ];
      }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

# Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  #networking.wireless.networks.JeevesNet.pskRaw = "494f779802ef5a1607cc09ece6a2c648d503d2305fc8ff4c8816f42409cffba7";
# networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/New_York";

# Enable sound.
  hardware.pulseaudio.enable = false;
# rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
# networking.firewall.allowedUDPPorts = [ ... ];
}
