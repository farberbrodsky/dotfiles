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
export PATH="/usr/lib64/qt5/bin/:$PATH"

# User specific aliases and functions
source "$HOME/.cargo/env"
set -o vi
export EDITOR=nvim

GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
CYAN=$(tput setaf 6)
GRAY=$(tput setaf 245)
NORMAL=$(tput sgr0)

PS1="\[${GRAY}\]"        # gray
PS1="$PS1\A "            # time
PS1="$PS1\[${GREEN}\]"   # green
PS1="$PS1\u"             # username
PS1="$PS1\[${YELLOW}\]@" # yellow @
PS1="$PS1\[${CYAN}\]"    # cyan
PS1="$PS1\h"             # hostname
PS1="$PS1\[${BLUE}\]"    # blue
PS1="$PS1 \w"            # working directory
PS1="$PS1 ● "            # dot
PS1="$PS1\[${NORMAL}\]"  # reset color

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

runvm()     { cd $HOME/disposable-vm/ && TERM=xterm ./run_clone.sh;    }
runmainvm() { cd $HOME/disposable-vm/ && TERM=xterm ./run_main_ssh.sh; }

if test -f "/usr/bin/lsd"; then
    alias ls="lsd"
fi

eval "$(starship init bash)"
