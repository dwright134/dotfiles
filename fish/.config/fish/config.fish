source /usr/share/cachyos-fish-config/cachyos-config.fish
source ~/.local_variables.fish
zoxide init --cmd cd fish | source

set -g pure_begin_prompt_with_current_directory false

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Added by `rbenv init` on Tue Mar 24 12:44:51 AM CDT 2026
status --is-interactive; and rbenv init - --no-rehash fish | source

# mise — pins per-project toolchains from .tool-versions. The shims branch
# covers non-interactive shells (git hooks, editor-spawned pre-commit), which
# otherwise fall through to whatever system binary is on PATH.
if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end
