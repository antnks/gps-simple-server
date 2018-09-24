#!/bin/bash

BASE_DIR=/path/to/

DB_H0_OK=$BASE_DIR/server_h0

DELIM_H0="#"

SIG_H0="*"

DB_ERRORS=$BASE_DIR/server_error.log
LOGROTATE=30000000

# delimeters of supported protocols
IFS="$DELIM_H0"

touch $DB_H0_OK.csv
touch $DB_H0_ER

while read line
do
	sig="$(echo $line | head -c 1)"
	DB_WRITE=""

	# detect protocol
	if [ "$sig" == "$SIG_H0" ]
	then
		DB_WRITE=$DB_H0_OK
	else
		printf '%s\n' "$line" >> $DB_ERRORS
		exit 1
	fi

	# protocol has been detected and varibale set, write it
	printf '%s\n' "$line" >> $DB_WRITE.csv

	# db rotate
	sz=`stat --printf="%s" $DB_WRITE.csv`
	if [ "$sz" -gt "$LOGROTATE" ]
	then
		backup=`date +"%Y%m%d%H%M%S"`
		gzip -c $DB_WRITE.csv > ${DB_WRITE}_${backup}.csv.gz
		rm $DB_WRITE.csv
	fi

done

