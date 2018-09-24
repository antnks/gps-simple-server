#!/bin/bash

PROCESS_SINGLE_LINE=1
BASE_DIR=/path/to/

DB_H0_OK=$BASE_DIR/server_h0

DELIM_H0="#"

SIG_H0="*"

DB_ERRORS=$BASE_DIR/server_error.log
LOGROTATE=30000000

# read char by char until we find one of valid delimiters
while IFS= read -r -N 1 c
do
	case "$c" in
		$DELIM_H0) line=$str; str="" ;;
		*)         str="$str$c"
	esac
	if [ ! -z "$str" ]; then continue; fi

	sig="$(echo $line | head -c 1)"
	DB_WRITE=""

	# dump received text to syslog
	#logger "$line"

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

	# one line per command only - exit after processing first line
	# use this together with "timeout" bash command to prevent stalled scripts and DoS
	if [ "$PROCESS_SINGLE_LINE" == "1" ]
	then
		exit 0
	fi

done

