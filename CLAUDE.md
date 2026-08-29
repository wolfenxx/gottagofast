# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Wolfen's personal NixOS + home-manager configuration, driven by a single flake at `nixos/flake.nix`. It defines one machine (`nixosConfigurations.system`, hostname `nixos`) and one user (`homeConfigurations.user`, username `wolfen`), plus the raw dotfiles those configs wire up. There is no app/service to build here — "correctness" means the flake evaluates and the generated configs/dotfiles behave as intended on the live machine.

## Commands

All commands assume the repo lives at `~/repos/gottagofast` (hardcoded in scripts and in the `hms` shell alias).

**Apply system-level changes** (`nixos/configuration.nix`, `nixos/hardware-configuration.nix`, `nixos/system_modules/*`) — requires sudo, reboots not usually needed:
```sh
sudo nixos-rebuild switch --flake ~/repos/gottagofast/nixos#system
```

**Apply user-level changes** (`nixos/home_modules/*`, most of `dotfiles/*`) — no sudo, aliased as `hms` in the shell:
```sh
home-manager switch --flake ~/repos/gottagofast/nixos#user
```

**Verify a change builds before switching** (no sudo, no effect on the live system — the closest thing this repo has to a test suite; use this after any edit under `nixos/`):
```sh
nix build ./nixos#nixosConfigurations.system.config.system.build.toplevel --dry-run
nix build ./nixos#homeConfigurations.user.activationPackage --dry-run
```
Drop `--dry-run` and add `--no-link` to actually realize the build and inspect the output store path without switching the live system to it.

**Full rebuild helpers** (also regenerate `hardware-configuration.nix` and re-detect UEFI/BIOS + grub device via `sed` into `flake.nix`):
- `scripts/nix_install_system.sh` — first-time bootstrap on a fresh machine (clones this repo + tmux's TPM, detects boot mode, runs both switches above).
- `scripts/nix_rebuild_system.sh` — same regeneration/detection, then re-runs both switches; also prunes all docker containers/volumes first to avoid stale-container build issues.
- `scripts/nix_clean_system.sh` / commands in `notes.txt` — nix store/generation garbage collection.

There is no formatter or lint step wired into the flake; nothing under `nix fmt` or CI to run.

## Architecture

### The flake is the single source of config knobs
`nixos/flake.nix` defines `systemSettings` (hostname, timezone, boot mode, grub device) and `userSettings` (username) as plain attrsets near the top, then threads them into every module via `specialArgs`/`extraSpecialArgs`. Module files pull these in via `{ systemSettings, userSettings, ... }:` rather than hardcoding values — follow that pattern for anything machine- or user-specific instead of hardcoding into a leaf module.

`nixos/hardware-configuration.nix` is machine-generated (`nixos-generate-config`) and is overwritten by the rebuild/install scripts — don't hand-edit it beyond what those scripts produce.

### Two independent flake outputs, two blast radii
- `nixosConfigurations.system`: `configuration.nix` + `hardware-configuration.nix` + `system_modules/{virtualization,containerization,gaming,network-shares}.nix`. System services, boot, display manager, hardware (NVIDIA, virtualization, gaming/Steam), and declared network mounts (`fileSystems.*`).
- `homeConfigurations.user`: `home_modules/{home,audio,browsers,chat,development,hyprland,terminals,video,image}.nix`. Per-app packages and dotfile wiring, split roughly by application domain (one file per category, not per app).

Editing something under `home_modules/` only needs `home-manager switch` — never assume a system rebuild is required unless the change is actually in `configuration.nix`/`system_modules/`.

### Secrets live outside the repo, referenced by absolute path
This repo is pushed to a public GitHub remote, so nothing under it may contain real credentials. Where a module needs a secret (e.g. `system_modules/network-shares.nix`'s SMB mount), it references an absolute path like `/etc/nixos/secrets/smb-credentials` that's created by hand on the machine (`chmod 600`, outside `~/repos/gottagofast`) rather than committed. Follow this pattern for any future module that needs credentials — never add a secrets file under this repo, even gitignored.

### `dotfiles/` is the editable source of truth; `home_modules/*.nix` decides how it reaches `~/.config`
Every app config lives under `dotfiles/<app>/` and is wired into the home directory by the matching `home_modules/*.nix` file, using one of two very different mechanisms — knowing which one applies to a given file determines whether an edit needs a rebuild:

- **Live symlink** (`config.lib.file.mkOutOfStoreSymlink ../../dotfiles/<app>`) — the deployed file is a symlink straight back into this repo. Editing it takes effect immediately (just reload/restart the app); no rebuild needed. Used for: `hyprlock.conf`, `hyprpaper.conf`, `waybar`, `rofi`, `wlogout`, `dunst`, `yazi`, `kitty/current-theme.conf`, `starship.toml`, `fastfetch`.
- **Baked into the store at build time** (`builtins.readFile` into a `programs.*.extraConfig`/similar, or a plain `home.file.*.source`/`configFile.source` without the out-of-store wrapper) — the deployed file is generated by home-manager and only picks up edits after `home-manager switch`. Used for: `hypr/hyprland.lua` (via `wayland.windowManager.hyprland.extraConfig`), `bash/.bashrc`, `nushell/config.nu` + `env.nu`, `kitty/kitty.conf`, `tmux/tmux.conf`, and all of `nvim/` (copied recursively, not symlinked).

When asked to change a dotfile, check which category it's in before claiming "just edit and it'll work" — for the baked ones, tell the user (or run) `home-manager switch` afterward, and prefer testing by directly invoking the tool against the repo-relative source path (as done for the nushell keybinding fixes) when a full switch isn't warranted yet.

### Hyprland config is Lua, not hyprlang
`dotfiles/hypr/hyprland.lua` is the live config (`configType = "lua"` in `home_modules/hyprland.nix`); `dotfiles/hypr/hyprland.conf` is kept only as an unreferenced fallback/reference from before the Lua migration. Hyprland's Lua config uses the `hl.*` API (`hl.config`, `hl.bind`, `hl.dsp.*` dispatchers, `hl.window_rule`, etc.) — check `share/hypr/stubs/hl.meta.lua` inside the built `programs.hyprland.package` for the authoritative API surface before guessing syntax, and cross-check against Hyprland's own vendored example config rather than inventing dispatcher shapes.

Session/display setup: GDM is the display manager with autologin enabled for `wolfen`; GNOME (`services.desktopManager.gnome.enable`) is also installed as an available session alongside Hyprland, but Hyprland is the one actually in daily use — don't assume GNOME being enabled means it's primary.

### Nushell keybindings must have unique `name` fields
`dotfiles/nushell/config.nu`'s `keybindings:` list intentionally reimplements most of nushell's default emacs+vi bindings (many key combos per logical action). Nushell requires each entry's `name` to be globally unique within the list — when adding or editing a binding, grep for the name first (`rg -U 'name: (\S+)\s*\n\s*modifier:'` finds real keybinding entries, as opposed to menu-name references elsewhere in the same file) and suffix with the modifier/key (e.g. `move_left_ctrl_b`) rather than reusing a name. Also watch for silent shadowing: two entries can share the exact same modifier+keycode+overlapping mode while bound to different actions — the entry later in the list wins and the earlier one goes dead. `nu -c "source dotfiles/nushell/config.nu"` will surface the uniqueness warning if one exists (it does not catch shadowing, which has to be checked by hand).

### LSP binaries are nix-pinned to fixed home-directory paths, not `$PATH`/mason
`home_modules/development.nix` installs each language server as a package and then re-exposes it at a fixed path via `home.file."<pkgname>".source = "${pkgs.<pkgname>}"` (e.g. `~/lua-language-server`, `~/csharp-ls`, `~/clang-tools`). `dotfiles/nvim/lua/plugins/masonlsp.lua` (despite its name, mason.nvim is not what installs these) hardcodes `cmd = { vim.fn.expand("~") .. "/<pkgname>/bin/<binary>" }` to invoke them directly. Adding or updating a language server means touching **both** files — the nix package/`home.file` entry and the matching `cmd` path in `masonlsp.lua` — and requires `home-manager switch` before nvim can see it.

### `samples/` and `assets/`
`samples/<lang>/` are throwaway per-language scratch projects (`factorial.*` + a `notes.txt` with the run/compile command) used to smoke-test the nvim LSP/formatter/treesitter setup for that language — not part of the OS config, safe to ignore unless specifically debugging editor tooling for a language. `assets/images/` holds the icon set referenced by `dotfiles/wlogout`.

## Keeping this file current

This file is a snapshot of the repo's structure and the non-obvious cross-file relationships in it (dotfile delivery mechanism, the nvim/nix LSP path pairing, the keybinding uniqueness rule, etc.). Whenever a change touches any of those relationships — a new home_module, a dotfile moved between the live-symlink and baked-at-build categories, a renamed/added LSP, the Hyprland config format, or the rebuild/verify commands themselves — update the relevant section here in the same change, rather than letting it drift.
