#!/bin/bash

# This script automates adding new users on an OpenVPN server
# The client cert and key, along with the CA cert are all placed into one .ovpn client file

# Checks if script is running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CLIENT_DIR="/etc/openvpn/clients"
if [ ! -d "$CLIENT_DIR" ]
then
	echo -e "Creating backup directory: $CLIENT_DIR ...\n"
        mkdir -p $CLIENT_DIR
fi

# Checks for client folder
if [ ! -d "$CLIENT_DIR" ]
then
	echo -e "Creating backup directory: $CLIENT_DIR ...\n"
        mkdir -p $CLIENT_DIR
fi

helpFct()
{
echo "This script is used to build users to a specific OpenVPN server."
echo "The keys are then placed in a client.ovpn file, which is sent to the user."
echo ""
echo "Usage:"
echo "It is required to specify the client OS in the first parameter."
echo "-w for Windows users!"
echo "-u for NON-Windows users!"
echo "-l is for linux clients!"
echo "If no intial parameter is given, UNIX is used as a default."
}

# Set working dirs
vpnRSA_dir=/etc/openvpn/easy-rsa/
vpnRSA_dir_KEYS=/etc/openvpn/easy-rsa/keys/
caCRT=/etc/openvpn/ca.crt
VPN_Name="smegVPN_"

# OS_Flags
WINDOWS=false
UNIX=true
LINUX=false

# Specifies if mail-flag is on or off
mailing=false

if [ -z "$1" ]
then
        echo "Please use the helpfunction: '$0 -h'"
	exit 1
else
	until [ -z $1 ]
	do
		case $1 in
			-h | --help 	)
				helpFct
				exit 1
				;;
 
			-w | --windows	)
				WINDOWS=true
				UNIX=false
				;;
 
			-u | --unix 	)
				UNIX=true
				;;

			-l | --linux	)
				LINUX=true
				UNIX=false
				;;
				
			-m | --mail	)
				mailing=true
				shift
				clientMail=$1
				;;					

                        [a-z]* 		)
				CLIENT_NAME=$1
				;;
			
			*		)
				echo "Change the client-name please!"
				exit 1
				;;
			esac
		shift
	done
fi

# See if clientname exists already
if [ -f $vpnRSA_dir_KEYS$CLIENT_NAME.crt ]
then 
	echo "Error: $CLIENT_NAME already exists!"
	echo "Choose a new name or remove the old client."
	exit 1
fi

# Enter the easy-rsa directory and establish the default variables
cd $vpnRSA_dir
source ./vars > /dev/null

# Copied from build-key script (to ensure it works!)
export EASY_RSA="${EASY_RSA:-.}"
"$EASY_RSA/pkitool" --batch $CLIENT_NAME

clientCRT=/etc/openvpn/easy-rsa/keys/$CLIENT_NAME.crt
clientKEY=/etc/openvpn/easy-rsa/keys/$CLIENT_NAME.key

echo "..."
echo "Creating Client File"
echo "..."

touch /etc/openvpn/clients/$VPN_Name$CLIENT_NAME.ovpn
clientFile=/etc/openvpn/clients/$VPN_Name$CLIENT_NAME.ovpn

# linux clients need /etc/openvpn/update-resolv-conf.sh to run! more on this:
# https://wiki.archlinux.org/index.php/OpenVPN#DNS

if [ $LINUX = true ]
then
	addition=`cat << EOF
user nobody
group nogroup
script-security 2
up /etc/openvpn/update-resolv-conf
down /etc/openvpn/update-resolv-conf
EOF
`
fi

if [ $WINDOWS = true ]
then
	addition=`cat << EOF
#windows client stuff
EOF
`
fi

if [ $UNIX = true ]
then
	addition=`cat << EOF
user nobody
group nogroup
EOF
`
fi

addKeys()
{
cat << EOF
#OpenVPN client configuration file

client
dev tun
proto udp
remote serverIP portnr # insert server IP and portnumbers here
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
comp-lzo
verb 3

<ca>
`cat $caCRT`
</ca>

<cert>
`cat $clientCRT`
</cert>

<key>
`cat $clientKEY`
</key>

$addition
EOF
}

addKeys >> $clientFile
echo ""
echo "Clientfile created!"
echo ""
#echo "Zipping the file..."
#echo ""

# Zips the file
#cd /etc/openvpn/easy-rsa/keys/clients/
#zip $VPN_Name$CLIENT_NAME.ovpn.zip $VPN_Name$CLIENT_NAME.ovpn

echo ""
echo "Mailing the client file to $clientMail ..."
echo ""

# Mail the client file to the user
# Required packages: sendemail, libio-socket-ssl-perl, libnet-ssleay-perl
# A mailscript is used here to simplify the input.

mailScriptLoc=/etc/openvpn/easy-rsa/mailscript2.sh
mailFile=/etc/openvpn/clients/$VPN_Name$CLIENT_NAME.ovpn
subj="VPN configuration file"
mailText=`cat /etc/openvpn/easy-rsa/mail-content.txt`

if [ $mailing = true ]
then
/bin/bash $mailScriptLoc -t $clientMail -u "$subj" -m "$mailText" -a $mailFile
fi

exit 0 
