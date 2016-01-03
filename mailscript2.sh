#!/bin/bash
# OPENMAILBOX
# logincredentials go into the .sendOMailAuthFile file
# The auth file must have values for the -f (from@domain) and -xp (password) options of sendEmail,
# structured as:
#
#    user=me.surnamen@gmail.com
#    pwd=xxxxxxx
#
# packages required: libio-socket-ssl-perl libnet-ssleay-perl sendEmail
# We will fill in the rest, and other params are passed through to sendEmail

function sendMailFct {
        local authFile="/root/.sendOMailAuthFile" # location of mail auth file
        for arg in "$@"; do
                if [[ "$arg" == "-k" ]]; then
                        shift
                        authFile="$1"
                        shift
                fi
        done
        source $authFile
        sendEmail -f $user -xu $user -xp $pwd -s smtp.openmailbox.org:587 -o tls=yes "$@"
}

if [[ -z $sourceMe ]]; then
        sendMailFct "$@"
fi
