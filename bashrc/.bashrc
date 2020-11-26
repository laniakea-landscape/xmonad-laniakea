#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

eval $(dircolors -b)

alias ls='ls --color=auto'
alias ll='ls -la'

alias grep='grep --color=auto'

# Switch on/off two monitors
alias hdmion="xrandr --output eDP1 --primary --left-of HDMI1 --output HDMI1 --auto"
alias hdmioff="xrandr --output HDMI1 --off"

# Docker stop all containres
alias dstopall='docker stop $(docker ps | sed -e 1d | cut -d\  -f1)'

# SSH to server on Digital Ocean
alias serv1='ssh laniakea@178.128.172.94'
alias serv2='ssh laniakea@178.128.164.230'
alias serv3='ssh laniakea@178.128.35.47'

if [ -f /.dockerenv ]; then
    PS1='\[\e[1;92m\]\u@\h\[\e[m\] \[\e[1;93m\]\w\[\e[m\] \[\e[1;92m\]\$\[\e[m\] \[\e[0;37m\]'
else
    PS1='\[\e[1;94m\]\u@\h\[\e[m\] \[\e[1;96m\]\w\[\e[m\] \[\e[1;94m\]\$\[\e[m\] \[\e[0;37m\]'
fi
