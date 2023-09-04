# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# vi mode
set -o vi

# Source from a directory
for f in ~/.bashrc.d/*; do [ -f "$f" ] && source "$f"; done
