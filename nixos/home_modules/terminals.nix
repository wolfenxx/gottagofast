{ config, pkgs, ... }:
let
  shellAliases = {
    sd = "shutdown 0";
    rs = "reboot";
    bk = "cd ..";
    hd = "cd ~";
    gg = "cd ~/repos/gottagofast";
    pr = "cd ~/projects";
    cl = "clear";
    bat = "bat";
    cat = "bat";
    tree = "eza --tree";
    fe = "yazi";
    nv = "nvim .";
    lg = "lazygit";
    ldr = "lazydocker";
    hms = "home-manager switch --flake ~/repos/gottagofast/nixos#user";
    gparted = "sudo -E gparted";
    gp = "sudo -E gparted";
    ff = "fzf --bind 'enter:become(nvim {})'";
    bluetooth = "blueman-manager";
    blueman = "blueman-manager";
    pm = "pulsemixer";
    cy = "cd ~/repos/cypress/";
    ast = "cd ~/repos/astralnotes/";
  };
in
{
  home.packages = with pkgs; [
     tmux
     waveterm
     bat
     eza
     curl
     ripgrep
     fzf
     fd
     jq
     difftastic
     jless
     yazi
     zoxide
     btop
     unzip
     kitty
     fastfetch
     powershell
     nushell
     carapace
     starship
     glow
     gparted
     parted
     file
  ]; 

  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = shellAliases;
    bashrcExtra = ''
      export DOTNET_ROOT="${pkgs.dotnet-sdk_8}"

      export CYPRESS_INSTALL_BINARY=0
      export CYPRESS_RUN_BINARY=${pkgs.cypress}/bin/Cypress
    '' + builtins.readFile ../../dotfiles/bash/.bashrc;
  };

  programs.nushell = {
    enable = true;
    shellAliases = shellAliases;
    configFile.source = ../../dotfiles/nushell/config.nu;
		envFile.source = ../../dotfiles/nushell/env.nu;
		extraConfig = ''
      alias lo = loginctl terminate-user $env.USER
		'';
		extraEnv = ''
			$env.DOTNET_ROOT = "${pkgs.dotnet-sdk_8}"

      $env.CYPRESS_INSTALL_BINARY = 0
      $env.CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress"
		'';
	};

  programs.kitty = {
    enable = true;
		extraConfig = ''
      shell ${pkgs.nushell}/bin/nu
    '' + builtins.readFile ../../dotfiles/kitty/kitty.conf;
	};

  programs.tmux = {
    enable = true;
		extraConfig = ''
      set-option -g default-shell ${pkgs.nushell}/bin/nu
    '' + builtins.readFile ../../dotfiles/tmux/tmux.conf;
	};

	home.file = {
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/yazi;
    ".config/kitty/current-theme.conf".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/kitty/current-theme.conf;
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/starship/starship.toml;
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink ../../dotfiles/fastfetch;
  };

}
