eval "$(starship init bash)"

source <(carapace _carapace)

alias lo='loginctl terminate-user $USER'
alias ls='eza'
alias ll='eza -alh'

fastfetch
