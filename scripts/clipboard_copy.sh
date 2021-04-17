TEMP=$(xclip -sel clip -o)
xdotool keyup $1
sleep 0.02

xdotool key --clearmodifiers ctrl+c
sleep 0.02

xclip -sel clip -o > /tmp/clipboard-$1

echo $TEMP | xclip -sel clip -i
