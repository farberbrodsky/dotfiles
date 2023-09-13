_RESET_COLOR='\[\e[m\]'
_RED_COLOR='\[\e[31m\]'
_GREEN_COLOR='\[\e[32m\]'
_BLUE_COLOR='\[\e[34m\]'
_PURPLE_COLOR='\[\e[35m\]'
_CYAN_COLOR='\[\e[36m\]'
_GRAY_COLOR='\[\e[37m\]'

# general
_PROMPT_COLOR="$_CYAN_COLOR"
_IMPORTANT_COLOR="$_PURPLE_COLOR"
# exit status
_SUCCESS_COLOR="$_GREEN_COLOR"
_FAIL_COLOR="$_RED_COLOR"
# path
_PATH_COLOR="$_BLUE_COLOR"
_GIT_PATH_COLOR="$_GREEN_COLOR"
# git
_GIT_COLOR="$_RED_COLOR"
_REMOVE_COLOR="$_RED_COLOR"
_CLEAN_COLOR="$_GREEN_COLOR"
_ADD_COLOR="$_GREEN_COLOR"
_UNTRACKED_COLOR="$_GREEN_COLOR"
_CHANGE_COLOR="$_BLUE_COLOR"

PROMPT_COMMAND=""

# Exit status module
# if success - nothing, if failed - set color red and show number
_exit_status_color_and_number_show=""
_exit_status_prompt() {
    local exit_status="$?"
    if [ "$exit_status" = "0" ]; then
        _exit_status_color_and_number_show=""
    else
        _exit_status_color_and_number_show="${_FAIL_COLOR}(${exit_status})"
    fi
}

PROMPT_COMMAND="$PROMPT_COMMAND _exit_status_prompt;"

# Path module
_chpwd() {
    # For git: try to base on the worktree directory and show the whole path after it
    local use_git=0
    if command -v git >/dev/null 2>&1; then
        local worktree_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
        if [ "$?" = "0" ] && [ ! -z "$worktree_dir" ]; then
            local path_absdir="$(realpath $PWD)"
            case "$path_absdir/" in
                "$worktree_dir"/*/*/*/*/*)
                    use_git=1
                    HPWD="${_GIT_PATH_COLOR}$(basename "${worktree_dir}")${_GRAY_COLOR}/...${_PATH_COLOR}${path_absdir#"${path_absdir%/*/*/*}"}"
                    ;;
                "$worktree_dir"/*) use_git=1;
                    HPWD="${_GIT_PATH_COLOR}$(basename "${worktree_dir}")${_PATH_COLOR}${path_absdir#"$worktree_dir"}"
                    ;;
                *);;
            esac
        fi
    fi
    if [ "$use_git" = "0" ]; then
        case $PWD in
            $HOME/*/*/*/*)
                HPWD="${_GRAY_COLOR}~/...${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}"
                ;;
            $HOME/*/*/*)
                HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}"
                ;;
            $HOME/*/*)
                HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD#"${PWD%/*/*}/"}"
                ;;
            $HOME/*)
                HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD##*/}"
                ;;
            $HOME)
                HPWD="${_GRAY_COLOR}~${_PATH_COLOR}"
                ;;
            /*/*/*/*)
                HPWD="${_GRAY_COLOR}/...${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}"
                ;;
            *)
                HPWD="${_PATH_COLOR}$PWD"
                ;;
        esac
    fi
    HPWD="$HPWD${_PROMPT_COLOR}"
}
cd() { builtin cd "$@" && _chpwd; }
pushd() { builtin pushd "$@" && _chpwd; }
popd() { builtin popd "$@" && _chpwd; }
_chpwd

# Git module
_git_show=""
if command -v git >/dev/null 2>&1; then
    _git_prompt() {
        local git_dir="$(git rev-parse --git-dir 2>/dev/null)"
        if [ -z "$git_dir" ]; then
            _git_show=""
        else
            _replaceSymbols() {
                # replace _AHEAD_, _BEHIND_, _NO_REMOTE_TRACKING_ and _PRETAG_
                local value="$1"
                local value="${value//_AHEAD_/↑}"
                local value="${value//_BEHIND_/↓}"
                local value="${value//_NO_REMOTE_TRACKING_/L}"
                local value="${value//_PRETAG_/}"
                local value="${value//_PREHASH_/:}"
                echo "$value"
            }

            local -a git_status_fields
            while IFS= read -r line; do
                git_status_fields+=("${line}");
            done < <(bash "$HOME/.bashrc.d/bash-git-prompt/gitstatus.sh" 2>/dev/null);

            local git_branch_state="$(_replaceSymbols ${git_status_fields[0]})"
            local git_remote="$(_replaceSymbols ${git_status_fields[1]})"
            local git_remote_url="$(_replaceSymbols ${git_status_fields[2]})"
            local git_upstream_trimmed="${git_status_fields[3]}"
            local git_staged="${git_status_fields[4]}"
            local git_conflicts="${git_status_fields[5]}"
            local git_changed="${git_status_fields[6]}"
            local git_untracked="${git_status_fields[7]}"
            local git_stashed="${git_status_fields[8]}"
            local git_clean="${git_status_fields[9]}"
            local git_detached_head="${git_status_fields[10]}"

            # list of symbols
            local git_symbols=""
            if [ "$git_staged" != "0" ]; then
                # staged files
                git_symbols="$git_symbols${_ADD_COLOR}●$git_staged${_GIT_COLOR}"
            fi
            if [ "$git_conflicts" != "0" ]; then
                # merge conflicts
                git_symbols="$git_symbols${_REMOVE_COLOR}✖$git_conflicts${_GIT_COLOR}"
            fi
            if [ "$git_changed" != "0" ]; then
                # changed unstaged files
                git_symbols="$git_symbols${_ADD_COLOR}✚$git_changed${_GIT_COLOR}"
            fi
            if [ "$git_untracked" != "0" ]; then
                # untracked files
                git_symbols="$git_symbols${_UNTRACKED_COLOR}…$git_untracked${_GIT_COLOR}"
            fi
            if [ "$git_stashed" != "0" ]; then
                # stash entries
                git_symbols="$git_symbols⚑$git_stashed"
            fi
            if [ "$git_clean" != "0" ]; then
                git_symbols="$git_symbols${_CLEAN_COLOR}✔${_GIT_COLOR}"
            fi

            # put in parentheses
            if ! [ -z "$git_symbols" ]; then
                local git_symbols=" ($git_symbols)"
            fi

            _git_show=" ${_GIT_COLOR}${git_branch_state}"
            if [ "$git_remote" != "." ]; then
                 _git_show="$_git_show remote ${git_remote}"
            fi
            _git_show="${_git_show}${git_symbols}${_PROMPT_COLOR}"
        fi
    }
    PROMPT_COMMAND="$PROMPT_COMMAND _git_prompt;"
fi

# Jobs module
_jobs_show=""
_jobs_prompt() {
    local num_jobs=0
    for job in $(jobs -p); do [[ $job ]] && ((num_jobs++)); done
    if [ "$num_jobs" != "0" ]; then
        # call it job or jobs?
        if [ "$num_jobs" = "1" ]; then
            local num_jobs="$num_jobs job"
        else
            local num_jobs="$num_jobs jobs"
        fi

        _jobs_show=" ${_IMPORTANT_COLOR}${num_jobs}${_PROMPT_COLOR}"
    else
        _jobs_show=""
    fi
}
PROMPT_COMMAND="$PROMPT_COMMAND _jobs_prompt;"

# Timer module
_timer=""
_timer_ready="0"
set +T
_timer_start() {
    # only set when told to set, and it's not a prompt command
    if [ "$_timer_ready" = "1" ]; then
        for cmd in "${PROMPT_COMMAND[@]}"; do
            if [ "$BASH_COMMAND" = "$cmd" ]; then
                # it's a prompt command
                return
            fi
            # echo "$BASH_COMMAND $cmd"
        done
        _timer="$(date +%s%N 2>/dev/null)"
        _timer_ready="0"
    fi
}
trap "_timer_start" DEBUG

_timer_stop() {
    if [ -z "$_timer" ]; then
        return
    fi
    local now="$(date +%s%N)"
    local time_ns="$(($now - $_timer))"
    if [ "$time_ns" -gt 1000000000 ]; then
        _timer_show=" ${_IMPORTANT_COLOR}took $(( ($time_ns + 500000000) / 1000000000 ))s${_PROMPT_COLOR}"
    else
        _timer_show=""
    fi
    # must run last - happens at the end of this file
    # _timer_ready="1"
}

PROMPT_COMMAND="$PROMPT_COMMAND _timer_stop;"

# and finally
PS0=""
PS2="> "
# select command prompt: PS3
# execution trace: PS4

# update ps1 each time
# this is hack because of: https://stackoverflow.com/questions/6592077/bash-prompt-and-echoing-colors-inside-a-function
_update_ps1() {
    PS1="\[\e[m\]${_PROMPT_COLOR}${_exit_status_color_and_number_show}[\t]${_PROMPT_COLOR} \h:$HPWD${_git_show}${_timer_show}${_jobs_show} \$\[\e[m\] "
}
PROMPT_COMMAND="$PROMPT_COMMAND _update_ps1"

# hack to set _timer_ready after EVERYTHING including kitty shell integration
_add_update_ps1() {
    PROMPT_COMMAND="${PROMPT_COMMAND/;_add_update_ps1/}"
    PROMPT_COMMAND+=("_timer_ready=1")
}
PROMPT_COMMAND="$PROMPT_COMMAND;_add_update_ps1"
