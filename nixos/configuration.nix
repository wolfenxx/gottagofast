{ pkgs, inputs, systemSettings, userSettings, ... }:

{
  networking.hostName = systemSettings.hostname; # Define your hostname.

  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
	boot.loader.timeout = 60;
  boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios
  boot.loader.grub.useOSProber = if (systemSettings.bootMode == "uefi") then false else true;
	boot.loader.grub.gfxmodeEfi = "1920x1080";
	boot.loader.grub.gfxmodeBios = "1920x1080";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Hyprland
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages."${pkgs.system}".hyprland;
 
  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Set your time zone.
  time.timeZone = systemSettings.timezone;

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
	hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
    wireplumber.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.username;
    extraGroups = [ "networkmanager" "audio" "wheel" "docker" ];
    uid = 1000;
    packages = [];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "wolfen";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = [];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  fonts.packages = with pkgs; [
    iosevka
    roboto
    fantasque-sans-mono
    nerd-fonts.mononoki
	];

  system.stateVersion = "24.05";
}
