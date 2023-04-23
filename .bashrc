# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH="$PATH:/home/misha/scripts/"

# User specific aliases and functions
if test -f "$HOME/.cargo/env"; then
    source "$HOME/.cargo/env"
fi
set -o vi
export EDITOR=nvim
export MANPAGER="nvim +Man!"

run() {
    local lang="$(echo $1 | cut -f 2 -d ".")";
    if [ $lang = "c" ]; then
        local x=$(mktemp);
        gcc $1 -o $x && $x ${@:2};
        rm $x;
    elif [ $lang = "cpp" ]; then
        local x=$(mktemp);
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

viddl() { cvlc "$1" -vvv --sout "#transcode{venc=mp4v}:file{dst=$2.mp4}" vlc://quit; }
fencrypt() { mypass=$(openssl rand -base64 12 | head -c 10); zipname="$(basename $1).zip";echo PASSWORD: $mypass; zip -P "$mypass" -q -r "$zipname" $1; echo "Saved to $zipname"; }
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}
pastebin(){ if [ $# -eq 0 ];then nc termbin.com 9999;else nc termbin.com 9999 < $1;fi }

up(){
    if command -v apt >/dev/null; then
        sudo apt update && sudo apt upgrade
    fi
    if command -v dnf >/dev/null; then
        sudo dnf update
    fi
    if command -v flatpak >/dev/null; then
        sudo flatpak update
    fi
}
upy(){
    if command -v apt >/dev/null; then
        sudo apt update && sudo apt upgrade -y
    fi
    if command -v dnf >/dev/null; then
        sudo dnf update -y
    fi
    if command -v flatpak >/dev/null; then
        sudo flatpak update -y
    fi
}

bgrun() { (nohup $@ >/dev/null 2>&1 & disown) }
open() { bgrun xdg-open $1; }
dlph() { bgrun dolphin "$(pwd)"; }

search() { rg -H . | fzf --layout=reverse; }

if test -f "/usr/bin/lsd"; then
    alias ls="lsd"
fi

# neovim background hack
_real_nvim="$(command -v nvim)"
nvim() {
    printf '\x1b]11;#EFF1F5\x1b\\'
    "${_real_nvim}" $@
    local ret_val="$?"
    printf '\x1b]11;#FAFAFA\x1b\\'
    return "$ret_val"
}

eval "$(starship init bash)"
