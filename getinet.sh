#!/bin/bash
ETH=`nmcli con show --active | grep ethernet | awk '{print $1;}'`
if [[ -n $ETH ]]
then
	ETH="eth:<fc=#45a5f5>$ETH</fc>"
fi

WLAN=`nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\: -f2`
if [[ -n $WLAN ]]
then
	WLAN="wlan:<fc=#45a5f5>$WLAN</fc>"
	ETH="$ETH "
fi

INET="$ETH$WLAN"
if [[ -n $INET ]]
then
	echo $INET
else 
	echo "no internet"
fi