#!/bin/bash
cd ~/odyssey/

ls -Rt

FILE=$(find . -type f -printf "%-.22T+ %M %n %-8u %-8g %8s %Tx %.8TX %p\n" | sort -r | sed 's/.*\.\///' | grep "_worksheet.pdf" | rofi -dmenu -i -p "open pdf")
if [[ $FILE == *.pdf ]]
then
    zathura "$FILE" &
fi

