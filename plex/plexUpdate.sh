#!/bin/bash
#------------------------------------------------------------------------------
# Author: 	Joel Gurnett
# Desc: 	update script for plex media server for ubuntu 64bit
# Date:		February 10, 2020
#------------------------------------------------------------------------------

# try to download updated packege, else print an error
if wget "https://plex.tv/downloads/latest/1?channel=16&build=linux-ubuntu-x86_64&distro=ubuntu&X-Plex-Token=removed" -O plex.deb ; then
	echo "Package Downloaded"

	# extract pagage, with print staements to show status
	if sudo dpkg -i plex.deb ; then
		echo "Plex updated ..."
		rm plex.deb
		echo "Files cleaned up."

	# if it fails display error
	else 
		echo "Error updating"
	fi

else 
	echo "Package Failed to Download"

fi