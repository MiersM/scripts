alias ll='ls -l'
alias la='ls -all'
alias ..='cd ..'
alias vi=vim

alias gitreset='git fetch origin && git reset --hard origin/master'

#if user is not root, pass all commands via sudo

if [ $UID -ne 0 ]; then

alias nethogs='sudo nethogs'

alias ports='sudo netstat -tulanp'

alias monitor='exec htop && exec nload'

alias svi='sudo vim'

alias haste='bash /home/tijn/gitStuff/pastel/haste.sh'

alias updating='sudo apt-get clean && echo "finished cleaning" && echo "" && sudo apt-get update && echo -n "finished updating" && echo "" && sudo apt-get upgrade -y && echo "finished upgrading" && echo "" && sudo apt-get dist-upgrade -y && echo "finished dist-upgrade"'

fi
