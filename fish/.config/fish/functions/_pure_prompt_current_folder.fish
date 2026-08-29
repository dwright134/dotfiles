# Override pure's cwd component to print nothing, keeping the prompt to just
# git state and the prompt symbol.
#
# pure has no variable for this -- the folder is unconditional in
# _pure_prompt_first_line -- but functions/ shadows vendor_functions.d, and
# _pure_print_prompt drops any zero-width component, so returning nothing
# removes the folder cleanly and leaves git, ssh, container, k8s and command
# duration untouched. This is the function's only caller.
#
# The cwd is still in the terminal/window title via pure's fish_title, which is
# what zellij shows in the pane frame.
function _pure_prompt_current_folder --argument-names current_prompt_width
    return 0
end
