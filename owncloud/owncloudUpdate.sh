#!/bin/bash
#------------------------------------------------------------------------------
# Author: 	Joel Gurnett
# Desc: 	update script for owncloud
# Date:		January 18, 2021
#------------------------------------------------------------------------------

WEB_DIR="/var/www/html"

# function to revert changes when upgrade fails
revert_changes() {
	sudo mv $WEB_DIR/owncloud-$VERSION_OLD $WEB_DIR/owncloud
	cd $WEB_DIR/owncloud
	sudo -u www-data php occ maintenance:mode --off
	sudo service apache2 start
}


echo "Enter old version number: "
read VERSION_OLD
echo "Enter new version number (10.6.0): "
read VERSION_NEW

cd $WEB_DIR/owncloud
# preparing server
if sudo -u www-data php occ maintenance:mode --on ; then
	echo "Entered maintenance mode!"
else
	echo "Failed to enter maintenance mode"
	exit 1
fi

if sudo service apache2 stop ; then
	echo "Apache2 has Stopped"
else
	echo "Failed to stop apache2"
	sudo -u www-data php occ maintenance:mode --off
	echo "Changes reverted"
	exit 2
fi

# backing up server
if sudo mv $WEB_DIR/owncloud $WEB_DIR/owncloud-$VERSION_OLD ; then
	sudo tar -cvf $WEB_DIR/owncloud-$VERSION_OLD.tar.gz $WEB_DIR/owncloud-$VERSION_OLD
	echo "Owncloud backed up"
	cd $WEB_DIR
	if sudo mysqldump -u owncloud -p owncloud > owncloud-$VERSION_OLD-dump.sql ; then
		echo "Database backed up"
	else
		echo "Error backing up"
		revert_changes
		echo "Changes reverted"
		exit 3
	fi
else
	echo "Error backing up"
	revert_changes
	echo "Changes reverted"
	exit 3
fi

# download new version
if wget https://download.owncloud.org/community/owncloud-$VERSION_NEW.tar.bz2 ; then
	echo "Download Successful!"
	if sudo tar -xvf owncloud-$VERSION_NEW.tar.bz2 ; then
		echo "Extraction Successful!"
	else
		echo "Error extracting"
		revert_changes
		echo "Changes reverted"
		exit 4
	fi

else
	echo "Error downloading"
	revert_changes
	echo "Changes reverted"
	exit 4

fi

# copy old files
sudo cp $WEB_DIR/owncloud-$VERSION_OLD/config/config.php $WEB_DIR/owncloud/config/config.php
sudo cp -r $WEB_DIR/owncloud-$VERSION_OLD/apps-external $WEB_DIR/owncloud/apps-external

# permissions
if sudo chown -R www-data:www-data $WEB_DIR/owncloud ; then
	echo "Permissions successfully changed!"
else
	echo "Permissions failed to change"
	exit 5
fi

cd $WEB_DIR/owncloud
# upgrade 
if sudo -u www-data php occ upgrade ; then
	echo "Owncloud upgraded!"
else
	echo "Failed to upgrade owncloud"
	revert_changes
	echo "Changes reverted"
	exit 6
fi 

# restarting server
if sudo -u www-data php occ maintenance:mode --off ; then
	echo "Exited maintenance mode!"
else
	echo "Failed to exit maintenance mode"
	exit 7
fi

if sudo service apache2 start ; then
	echo "Apache2 has started"
else
	echo "Failed to start apache2"
	exit 8
fi

# scan files
#sudo -u www-data php occ files:scan --all