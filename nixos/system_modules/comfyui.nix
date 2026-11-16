{ inputs, systemSettings, userSettings, ... }:
{
  imports = [ inputs.comfyui-nix.nixosModules.default ];

  # Build cost, measured against the pinned rev: torch/torchvision/torchaudio
  # are prebuilt wheels, but xformers compiles CUDA kernels from source for 7
  # GPU archs (hardcoded upstream, not narrowable from here), plus triton,
  # tokenizers, onnx, scikit-*. Upstream's cachix never holds the CUDA
  # closure, so the first switch is a one-time local build (~1.5-3h), repeated
  # only when the flake input is bumped. Bound nvcc's parallelism to keep RAM
  # in check:  sudo nixos-rebuild switch --flake ~/repos/gottagofast/nixos#system --cores 8
  #
  # Caches the flake publishes to (from its nixConfig, which nix only honors
  # for trusted users -- so declare them system-wide). They cover the CUDA
  # toolkit pieces, little else; still worth having.
  nix.settings = {
    substituters = [
      "https://comfyui.cachix.org"
      "https://cache.nixos-cuda.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "comfyui.cachix.org-1:33mf9VzoIjzVbp0zwj+fT51HG0y31ZTK3nzYZAX0rec="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Why this flake and not nixpkgs' comfyui: nixpkgs' CUDA variant is not
  # binary-cached and compiles PyTorch from source (~2h, 30-60GB RAM). This
  # flake uses prebuilt pytorch.org CUDA 13 wheels and disables nixpkgs'
  # clashing services.comfyui module itself.
  services.comfyui = {
    # CUDA-only as configured: the prebuilt wheels and the whole build-cost
    # story above are NVIDIA-specific, so a machine without one (flake.nix
    # systemSettings.gpu) must not pay for a multi-hour build it cannot run.
    # The module also supports "rocm" / "xpu" / "none" but none are tested here.
    enable = systemSettings.gpu == "nvidia";
    gpuSupport = "cuda"; # prebuilt CUDA 13 wheels; needs driver >= 580
    enableManager = true; # runtime custom-node installs -> <dataDir>/.pip-packages (impure, by choice)

    # Run as the desktop user so models/outputs under ~/comfyui are user-owned
    # (manual model drops, MCP server reading output/ -- no group juggling).
    user = userSettings.username;
    group = "users";
    createUser = false;
    dataDir = "/home/${userSettings.username}/comfyui";

    listenAddress = "127.0.0.1"; # local only; the MCP server and browser talk to it on localhost
    port = 8188;
  };
}
