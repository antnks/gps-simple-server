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

	if [ "$sig" == "$SIG_H0" ]
	then
		printf '%s\n' "$line" >> $DB_H0_OK.csv
	else
		printf '%s\n' "$line" >> $DB_H0_ER
		exit 1
	fi

	# db rotate
	sz=`stat --printf="%s" $DB_H0_OK.csv`
	if [ "$sz" -gt "$LOGROTATE" ]
	then
		backup=`date +"%Y%m%d%H%M%S"`
		gzip -c $DB_H0_OK.csv > ${DB_H0_OK}_${backup}.csv.gz
		rm $DB_H0_OK.csv
	fi

done

