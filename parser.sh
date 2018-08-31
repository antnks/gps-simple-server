#!/bin/bash

FILELOGOK=/path/to/server
FILELOGER=/path/to/server_error.log
LOGROTATE=30000000

while read -d '#' line; do
	sig="$(echo $line | head -c 1)"

	if [ "$sig" == "*" ]
	then

		sz=`stat --printf="%s" $FILELOGOK.csv`
		if [ "$sz" -gt "$LOGROTATE" ]
		then
			backup=`date +"%Y%m%d%H%M%S"`
			gzip -c $FILELOGOK.csv > ${FILELOGOK}_${backup}.csv.gz
			rm $FILELOGOK.csv
		fi

		printf '%s\n' "$line" >> $FILELOGOK.csv
	else
		printf '%s\n' "$line" >> $FILELOGER
		exit 1
	fi
done

