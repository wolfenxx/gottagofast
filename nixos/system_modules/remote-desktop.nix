{ pkgs, ... }:
let
  # nixpkgs' rustdesk only puts gstreamer + gst-plugins-base on its GStreamer
  # plugin path. Its Wayland capture (ScreenCast portal) pulls frames through the
  # `pipewiresrc` element, which lives in the pipewire package's gst plugin dir --
  # without it the handshake fails with
  # `wl-stage:gst-plugin:unavailable:pipewiresrc` (client: "Failed to get
  # capturer display info"). The upstream wrapper uses --prefix, so prepending
  # the pipewire dir here is picked up as-is. Done as a re-wrap rather than an
  # overrideAttrs so rustdesk itself is not rebuilt from source.
  rustdesk = pkgs.symlinkJoin {
    name = "rustdesk-with-pipewiresrc";
    paths = [ pkgs.rustdesk ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rustdesk \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${pkgs.pipewire}/lib/gstreamer-1.0
    '';
  };
in
{
  environment.systemPackages = [ rustdesk ];

  # RustDesk's root-side service. Upstream's .deb installs this as rustdesk.service;
  # nixpkgs ships only the package (its `services.rustdesk-server` option is the
  # relay server, unrelated). Without it, incoming sessions on this Wayland/Hyprland
  # host fail with "the desktop portal on the remote device is missing a capability":
  # RustDesk decides how to capture by checking `ps aux` for a `rustdesk --server`
  # process. If one exists (spawned by this service for the logged-in session) it
  # uses the ScreenCast portal for video + uinput (through this root process) for
  # input -- both of which xdg-desktop-portal-hyprland supports. If none exists it
  # falls back to the RemoteDesktop portal, which the Hyprland portal does not
  # implement (hyprwm/xdg-desktop-portal-hyprland#252, still open).
  systemd.services.rustdesk = {
    description = "RustDesk remote desktop service (spawns the per-session server, owns /dev/uinput)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    # The service shells out to `loginctl` to find the graphical session, then
    # spawns `sudo -E -u <user> rustdesk --server` for it (that is the process the
    # detection above looks for, and it in turn runs `ps aux | grep`). On NixOS
    # sudo is the setuid wrapper under /run/wrappers/bin, which is NOT on a
    # systemd service's default PATH -- without it the spawn fails silently
    # (only visible in /root/.local/share/logs/RustDesk/) and the GUI keeps
    # running its own in-process server, taking the RemoteDesktop-portal path.
    # `sudo -E` also means the --server child inherits this unit's environment,
    # including the GStreamer plugin path set by the wrapper above.
    path = with pkgs; [ "/run/wrappers" procps bash gawk gnugrep coreutils systemd util-linux ];
    serviceConfig = {
      ExecStart = "${rustdesk}/bin/rustdesk --service";
      PIDFile = "/run/rustdesk.pid";
      KillMode = "mixed";
      TimeoutStopSec = 30;
      LimitNOFILE = 100000;
      Restart = "always";
      RestartSec = 5;
    };
  };
}
