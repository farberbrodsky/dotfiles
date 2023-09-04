_have_nvm() {
    [ -d ~/.config/nvm ]
    return "$?"
}

_lazy_load_nvm() {
    _nvm_loaded=1
    if _have_nvm; then
        export NVM_DIR=~/.config/nvm
        . "$NVM_DIR/nvm.sh"
        . "$NVM_DIR/bash_completion"

        # node, npm and nvm aliases can be removed
        unset -f node npm nvm
    fi
}

# don't define node, npm, nvm if there is no nvm
if _have_nvm; then
    node() {
        if [ "$_nvm_loaded" != "1" ]; then _lazy_load_nvm; fi
        node "$@"
    }
    npm() {
        if [ "$_nvm_loaded" != "1" ]; then _lazy_load_nvm; fi
        npm "$@"
    }
    nvm() {
        if [ "$_nvm_loaded" != "1" ]; then _lazy_load_nvm; fi
        nvm "$@"
    }
fi

if command -v nvim >/dev/null 2>&1; then
    # always define nvim as a wrapper function
    _real_nvim="$(command -v nvim)"
    nvim() {
        if [ "$nvm_loaded" != "1" ]; then _lazy_load_nvm; fi
        "$_real_nvim" "$@"
    }
fi
