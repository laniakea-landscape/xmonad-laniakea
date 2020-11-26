#!/bin/bash
vol=`amixer -D pulse sget Master | grep -o -m 1 '[[:digit:]]*%'`
if [[ $(amixer -D pulse sget Master | grep -o -m 1 'off') == "off" ]]
then
    vol="---"
fi
#level=`expr $vol / 13`
#$level

#iconbase="$(pwd)/icons/audio-volume"

#case $level in
#  0)  lv='off' ;;
#  1)  lv='low' ;;
#  2)  lv='low' ;;
#  3)  lv='low' ;;
#  4)  lv='medium' ;;
#  5)  lv='medium' ;;
#  6)  lv='medium' ;;
#  7)  lv='high' ;;
#  8)  lv='high' ;;
#  9)  lv='high' ;;
#  *)  lv='muted' ;;
#esac

#echo "<icon=$(pwd)/.xmonad/icons/audio-volume-$lv.xpm/>"
echo "<action=\`amixer set Master toggle && ~/.xmonad/getvolume.sh >> /tmp/.volume-pipe\`>vol:$vol</action>"

exit 0