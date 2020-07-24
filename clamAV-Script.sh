#!/bin/bash
SCAN_DIR="/root"
LOG_FILE="/var/log/clamav/clamscan_weekly.log"

echo >> $LOG_FILE
date >> $LOG_FILE

if /usr/bin/freshclam ; then
	echo "FreshClam updated the database!" >> $LOG_FILE
else
	echo "FreshClam Failed!" >> $LOG_FILE
fi

/usr/bin/clamscan -i -r $SCAN_DIR >> $LOG_FILE