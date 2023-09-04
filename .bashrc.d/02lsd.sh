# use lsd instead of ls if it exists
if command -v lsd >/dev/null 2>&1; then
    alias ls="lsd"
fi

