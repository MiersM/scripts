#!/bin/bash
#cleans, updates and upgrades
apt-get clean && apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y
echo "Done"
