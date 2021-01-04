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

export PS1="\e[0;37m"     # color gray
export PS1=$PS1"\A "      # time
export PS1=$PS1"\e[0;32m" # color green
export PS1=$PS1"\u"       # username
export PS1=$PS1"@\H"      # @hostname
export PS1=$PS1"\e[0;34m" # color blue
export PS1=$PS1" \w"      # working directory
export PS1=$PS1" ● "      #
export PS1=$PS1"\e[0m"    # reset color
