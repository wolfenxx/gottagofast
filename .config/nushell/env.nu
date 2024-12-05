$env.EDITOR = "nvim"
$env.PROMPT_INDICATOR = {|| " " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| " " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

$env.CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense" # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
