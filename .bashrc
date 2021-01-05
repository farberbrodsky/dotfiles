# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# User specific aliases and functions
source "$HOME/.cargo/env"
set -o vi
export EDITOR=nvim

export PS1="\e[0;37m"     # color gray
export PS1=$PS1"\A "      # time
export PS1=$PS1"\e[0;32m" # color green
export PS1=$PS1"\u"       # username
export PS1=$PS1"@\h"      # @hostname
export PS1=$PS1"\e[0;34m" # color blue
export PS1=$PS1" \w"      # working directory
export PS1=$PS1" ● "      #
export PS1=$PS1"\e[0m"    # reset color

run() {
    lang=$(echo $1 | cut -f 2 -d ".");
    if [ $lang = "c" ]; then
        x=$(mktemp);
        gcc $1 -o $x && $x ${@:2};
        rm $x;
    elif [ $lang = "cpp" ]; then
        x=$(mktemp);
        g++ $1 -o $x && $x ${@:2};
        rm $x;
    elif [ $lang = "py" ]; then
        python3 $@
    else
        echo "Unknown language."
    fi
}

inpep() { autopep8 --in-place --aggressive --aggressive $1; }
if test -f "/usr/bin/lsd"; then
    alias ls="lsd"
fi
