# pure prompt appearance.
#
# These are globals, not universals, and they live in conf.d rather than
# config.fish on purpose. conf.d snippets are sourced before config.fish, and
# "00-" sorts ahead of vendor_conf.d/pure.fish, so these are already set when
# pure runs _pure_set_default -- which only writes a universal when the var is
# unset in BOTH the universal and global scopes. Result: pure never persists
# these keys, and fish_variables stays purely generated state (it is
# gitignored, and was wiped once already, taking these settings with it).
set -g pure_enable_single_line_prompt true
set -g pure_begin_prompt_with_current_directory false
set -g pure_symbol_prompt \uf0a9\x20
