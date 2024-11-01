{ pkgs ? import <nixpkgs> {} }:
pkgs.buildDotnetModule {
  pname = "servicetitan";
  version = "1";
  src = ./.;
  projectFile = "./Apps/App.Startup/App.Startup.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = pkgs.dotnet-sdk_8;
  dotnet-runtime = pkgs.dotnet-sdk_8;
  buildType = "Debug";
  executables = [ "servicetitan" ];
}
