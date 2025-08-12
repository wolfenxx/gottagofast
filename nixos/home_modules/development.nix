{ pkgs, pkgs-stable, ... }:
let
  stable-packages = with pkgs-stable; [
    openlens
  ];

  python-wpkgs = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      numpy
      python-dotenv
    ]
  );
in
{
  home.packages =
    with pkgs;
    [
      neovim
      silicon
      git
      python-wpkgs
      nodejs_20
      bun
      lazygit
      lazydocker
      docker
      docker-compose
      clang
      clang-tools
      lldb
      mono
      gnumake
      netcoredbg
      dotnet-sdk_8
      nuget-to-nix
      csharp-ls
      omnisharp-roslyn
      lua
      lua-language-server
      stylua
      cypress
      #postman #intermittenly unavailable due to postman deleting old versions
      bruno
      docker-ls
      sqls
      nil
      hyprls
      lemminx
      yaml-language-server
      biome
      sqlite
      teleport
      vscode
      postgresql
      ruff
      csharpier
    ]
    ++ stable-packages;

  home.file = {
    ".config/nvim" = {
      source = ../../dotfiles/nvim;
      recursive = true;
    };
    "omnisharp".source = "${pkgs.omnisharp-roslyn}";
    "csharp-ls".source = "${pkgs.csharp-ls}";
    "stylua".source = "${pkgs.stylua}";
    "clang-tools".source = "${pkgs.clang-tools}";
    "lldb".source = "${pkgs.lldb}";
    "lua-language-server".source = "${pkgs.lua-language-server}";
    "docker-ls".source = "${pkgs.docker-ls}";
    "sqls".source = "${pkgs.sqls}";
    "nil".source = "${pkgs.nil}";
    "hyprls".source = "${pkgs.hyprls}";
    "lemminx".source = "${pkgs.lemminx}";
    "yaml-language-server".source = "${pkgs.yaml-language-server}";
    "biome".source = "${pkgs.biome}";
    "ruff".source = "${pkgs.ruff}";
    "csharpier".source = "${pkgs.csharpier}";
  };
}
