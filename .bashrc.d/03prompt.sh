_RED_COLOR="$(echo -e "\033[0;31m")"
_GREEN_COLOR="$(echo -e "\033[0;32m")"
_BLUE_COLOR="$(echo -e "\033[0;34m")"
_MAGENTA_COLOR="$(echo -e "\033[0;35m")"
_GRAY_COLOR="$(echo -e "\033[0;37m")"

# general
_PROMPT_COLOR="$_GREEN_COLOR"
_IMPORTANT_COLOR="$_MAGENTA_COLOR"
# path
_PATH_COLOR="$_BLUE_COLOR"
# git
_GIT_COLOR="$_RED_COLOR"
_REMOVE_COLOR="$_RED_COLOR"
_CLEAN_COLOR="$_GREEN_COLOR"
_ADD_COLOR="$_GREEN_COLOR"
_UNTRACKED_COLOR="$_GREEN_COLOR"
_CHANGE_COLOR="$_BLUE_COLOR"

PROMPT_COMMAND=""

# Exit status module
_exit_status_show=""
_exit_status_prompt() {
    local exit_status="$?"
}
PROMPT_COMMAND="$PROMPT_COMMAND _git_prompt;"

# Path module
cd() { builtin cd "$@" && _chpwd; }
pushd() { builtin pushd "$@" && _chpwd; }
popd() { builtin popd "$@" && _chpwd; }
_chpwd() {
  case $PWD in
    $HOME/*/*/*/*) HPWD="${_GRAY_COLOR}~/...${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}";;
    $HOME/*/*/*) HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}";;
    $HOME/*/*) HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD#"${PWD%/*/*}/"}";;
    $HOME/*) HPWD="${_GRAY_COLOR}~${_PATH_COLOR}/${PWD##*/}";;
    $HOME) HPWD="${_GRAY_COLOR}~${_PATH_COLOR}";;
    /*/*/*/*) HPWD="${_GRAY_COLOR}/...${_PATH_COLOR}/${PWD#"${PWD%/*/*/*}/"}";;
    *) HPWD="${_PATH_COLOR}$PWD";;
  esac
  HPWD="$HPWD${_PROMPT_COLOR}"
}
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
            while IFS=$'\n' read -r line; do git_status_fields+=("${line}"); done < <(bash "$HOME/.bashrc.d/bash-git-prompt/gitstatus.sh" 2>/dev/null)
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
            _git_show="$_git_show${git_symbols}${_PROMPT_COLOR}"
        fi
    }
    PROMPT_COMMAND="$PROMPT_COMMAND _git_prompt;"
fi

# Timer module
_timer_start() {
    # is unset on _timer_stop
    _timer=${_timer:-$(date +%s%N 2>/dev/null)}
}

_timer_stop() {
    local now="$(date +%s%N)"
    local time_ns="$(($now - $_timer))"
    if [ "$time_ns" -gt 1000000000 ]; then
        _timer_show=" ${_IMPORTANT_COLOR}took $(( ($time_ns + 500000000) / 1000000000 ))s${_PROMPT_COLOR}"
    else
        _timer_show=""
    fi
    unset _timer
}

trap '_timer_start' DEBUG
PROMPT_COMMAND="$PROMPT_COMMAND _timer_stop;"

PS1='${_PROMPT_COLOR}[\t] \h:$HPWD${_git_show}${_timer_show} \$\e[m '
