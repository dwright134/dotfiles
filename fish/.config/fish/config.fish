source /usr/share/cachyos-fish-config/cachyos-config.fish
source ~/.local_variables.fish
zoxide init --cmd cd fish | source

set -g pure_begin_prompt_with_current_directory false

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
