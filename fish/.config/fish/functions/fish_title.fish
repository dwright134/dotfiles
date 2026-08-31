# Override pure's fish_title to drop the shell name from the title.
#
# pure builds the title as "<folder>: <last command> <separator> <current
# command>", and at the prompt both command halves are the shell itself, so
# every idle zellij pane frame reads "~/somewhere - fish". functions/ shadows
# vendor_functions.d, so defining fish_title here replaces pure's copy.
#
# The folder stays; the "<separator> <current command>" tail goes, since it
# only ever repeats $last_command or names the shell. While a command runs the
# frame still shows it, as "<folder>: <command>".
function fish_title \
    --description "Set title to current folder, plus the running command if any" \
    --argument-names last_command

    set --local current_folder (fish_prompt_pwd_dir_length=$pure_shorten_window_title_current_directory_length prompt_pwd)

    if test -z "$last_command"
        echo $current_folder
    else
        echo "$current_folder: $last_command"
    end
end
