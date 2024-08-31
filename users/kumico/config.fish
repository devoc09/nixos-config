# disable welcome message
set -g -x fish_greeting

# Automatically load ssh-agent environment variables.
if test -z "$SSH_AUTH_SOCK"
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
end

if command -v keychain > /dev/null
    eval (keychain --eval --quiet ~/.ssh/id_rsa)
end

function fish_prompt --description 'define iteractive shell prompt'
    # insert new line befor prompt
    echo

    # username & hostname
    set -l short_hostname (hostname | cut -d . -f 1)
    set_color normal
    echo -n (whoami); echo -n '@'; echo -n $short_hostname; echo -n ':'

    # current directory
    set_color blue
    echo -n (prompt_pwd)

    # prompt synbol
    set_color normal
    set -l git_branch (__fish_git_prompt | string trim -c ' ')
    echo -n $git_branch; echo -n '$ '
end

function fish_right_prompt --description 'define interactive shell prompt right'
    # exit code
    set -l last_status $status
    if test $last_status -ne 0
        set_color red
        echo -n ' '$last_status
    end
end

# repository selector using fzf
function fzf_select_ghq_list --description 'Select a directory from the ghq list'
  ghq list --full-path | fzf --no-sort --reverse --ansi | read selected
  [ -n "$selected" ]; and cd "$selected"
  commandline -f repaint
end

function fish_user_key_bindings
    bind \x1d fzf_select_ghq_list
end

alias ls='ls --color=always'
funcsave ls
