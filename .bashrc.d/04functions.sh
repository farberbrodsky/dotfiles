# install updates
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

# run in the background
bgrun() { (nohup $@ >/dev/null 2>&1 & disown) }
open() { bgrun xdg-open $1; }
dlph() { bgrun dolphin "$(pwd)"; }

# run any file
run() {
    if [ "$#" != "1" ]; then
        >&2 echo "Pass a file"
        return 1
    fi
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
        >&2 echo "Unknown language."
        return 1
    fi
}

# pep8
if command -v autopep8 >/dev/null 2>&1; then
    inpep() { autopep8 --in-place --aggressive --aggressive $1; }
fi

# VLC download
if command -v cvlc >/dev/null 2>&1; then
    viddl() { cvlc "$1" -vvv --sout "#transcode{venc=mp4v}:file{dst=$2.mp4}" vlc://quit; }
fi

# disposable vm
if [ -d "$HOME/disposable-vm" ]; then
    runvm()     { cd $HOME/disposable-vm/ && TERM=xterm ./run_clone.sh;    }
    runmainvm() { cd $HOME/disposable-vm/ && TERM=xterm ./run_main_ssh.sh; }
fi

# upload files to termbin or transfer.sh
fencrypt() { mypass=$(openssl rand -base64 12 | head -c 10); zipname="$(basename $1).zip";echo "PASSWORD: $mypass"; zip -P "$mypass" -q -r "$zipname" $1; echo "Saved to $zipname"; }
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n  transfer <file|directory>\n  ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://transfer.sh/$file_name"|tee /dev/null;fi;}
pastebin(){ if [ $# -eq 0 ];then nc termbin.com 9999;else nc termbin.com 9999 < $1;fi }
