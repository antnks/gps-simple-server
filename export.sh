#!/bin/bash

SKIPINVALID=1
DATELIMIT=$1

SIG_H0="*"
SIG_WA="["

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\" creator=\"h02-server\">"
echo "<trk><trkseg>"

laststat=0
while IFS=, read -r -a FIELD
do
	sig="$(echo ${FIELD[0]} | head -c 1)"

	if [ "$sig" == "$SIG_H0" ]
	then
		time=${FIELD[3]}
		date=${FIELD[11]}
		satt=${FIELD[4]}
		alt=${FIELD[5]}
		altd=${FIELD[6]}
		long=${FIELD[7]}
		longd=${FIELD[8]}
	elif [ "$sig" == "$SIG_WA" ]
	then
		time=${FIELD[2]}
		date=${FIELD[1]}
		satt=${FIELD[3]}
		alt=${FIELD[4]}
		altd=${FIELD[5]}
		long=${FIELD[6]}
		longd=${FIELD[7]}
	else
		continue
	fi

	if [ "$satt" != "A" ] && [ "$SKIPINVALID" == "1" ]; then continue; fi

	d="$(echo $date | head -c 2)"
	M="$(echo $date | head -c 4 | tail -c 2)"
	y="$(echo $date | tail -c 3)"

	recorddate="20$y$M$d"

	# if command line param "stats" specified - check and output days stats only
	if [ ! -z "$DATELIMIT"  ] && [ "$DATELIMIT" == "stats" ]
	then
		if [ "$laststat" != "$recorddate" ]; then echo $recorddate; fi
		laststat=$recorddate
		continue
	fi

	if [ ! -z "$DATELIMIT"  ] && [ "$recorddate" -lt "$DATELIMIT" ]; then continue; fi

	h="$(echo $time | head -c 2)"
	m="$(echo $time | head -c 4 | tail -c 2)"
	s="$(echo $time | tail -c 3)"

	altdeg="$(echo $alt | head -c 2)"
	altpoi="$(echo $alt | tail -c 8)"
	altitude=`bc <<< "scale=4; $altdeg+$altpoi*100/60/100"`

	longdeg="$(echo $long | head -c 3)"
	longpoi="$(echo $long | tail -c 8)"
	longitude=`bc <<< "scale=4; $longdeg+$longpoi*100/60/100"`

	echo "<trkpt lat=\"$altitude\" lon=\"$longitude\">"
	echo "<time>20${y}-${M}-${d}T${h}:${m}:${s}Z</time>"
	echo "</trkpt>"

done

echo "</trkseg></trk></gpx>"

