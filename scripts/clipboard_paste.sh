TEMP=$(xclip -sel clip -o)
xdotool keyup $1
xclip -sel clip -i < /tmp/clipboard-$1
sleep 0.01

xdotool key ctrl+v
sleep 0.01

echo $TEMP | xclip -sel clip -i
