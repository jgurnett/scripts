#!/bin/bash
#------------------------------------------------------------------------------
# Author: 	Joel Gurnett
# Desc: 	update clamAV database and scan system with clamAV
# Date:		July 24, 2020
#------------------------------------------------------------------------------

SCAN_DIR="/home"
LOG_FILE="/var/log/clamav/clamscan_weekly.log"

echo >> $LOG_FILE
date >> $LOG_FILE

# update clam database
if /usr/bin/freshclam ; then
	echo "FreshClam updated the database!" >> $LOG_FILE
else
	echo "FreshClam Failed!" >> $LOG_FILE
fi

# scan your directory
/usr/bin/clamscan -i -r $SCAN_DIR >> $LOG_FILE
