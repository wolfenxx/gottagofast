{ pkgs, ... }:
let
  # Export templates are what `Project > Export` needs to actually produce a
  # build; Godot looks for them in ~/.local/share/godot/export_templates/<ver>
  # and the nix packages ship exactly that layout under share/godot/.
  # The GDScript editor and the C# (.NET) editor each need their own set.
  exportTemplates = pkgs.godot-export-templates-bin;
  exportTemplatesMono = pkgs.godot-export-templates-bin.override {
    withMono = true;
    # nixpkgs (e7439b6) carries a stale hash for the mono .tpz and the build
    # fails with a hash mismatch. This is the current file's hash, verified
    # against the SHA512-SUMS.txt published with the 4.7.2-stable release.
    # Drop this line once a nixpkgs bump makes the build pass without it.
    hash = "sha256-kvhoHjSe8fkIkbeS2pXjsrC9HtYQt4AYxY/rLYfhWp0=";
  };
  # goxel's SConstruct hardcodes -Werror and the pinned GCC now warns about
  # discarded const qualifiers in its vendored quickjs, so the stock package
  # fails to compile. Strip the flag; drop this once nixpkgs' goxel builds again.
  goxel = pkgs.goxel.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace SConstruct --replace-fail "-Werror" ""
    '';
  });
in
{
  home.packages = with pkgs; [
    # Engine. `godot` is the GDScript editor, `godot-mono` the .NET one (uses
    # dotnet-sdk from development.nix). Binaries don't collide: godot vs godot-mono.
    godot
    godot-mono
    gdtoolkit_4 # gdformat / gdlint for GDScript (the LSP is the running editor itself)

    # Level and asset editors
    ldtk # 2D level editor (has a Godot importer)
    tiled # 2D tilemap editor
    pixelorama # pixel art, written in Godot
    aseprite # pixel art / animation (unfree, builds from source)
    material-maker # procedural PBR textures, exports Godot materials
    blockbench # low-poly modelling
    goxel # voxel editor (patched, see above)
    sfxr # retro sound effects

    # Asset pipeline and publishing
    git-lfs # run `git lfs install` once to register the git hooks
    imagemagick
    oxipng
    pngquant
    butler # itch.io uploads
    steamcmd # Steam depot uploads (unfree)

    # Debugging and performance
    renderdoc # frame capture for Godot 4's Vulkan renderer
    mangohud # FPS/frametime overlay: `mangohud godot ...`
    vulkan-tools # vulkaninfo
  ];

  # Writable real directory with the store templates linked in, so manually
  # downloaded templates for other versions can sit next to them.
  home.file.".local/share/godot/export_templates" = {
    source = pkgs.symlinkJoin {
      name = "godot-export-templates-all";
      paths = [ exportTemplates exportTemplatesMono ];
    } + "/share/godot/export_templates";
    recursive = true;
  };
}
