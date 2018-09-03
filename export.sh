#!/bin/bash

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?><gpx version=\"1.1\" creator=\"h02-server\">"
echo "<trk><trkseg>"

while IFS=, read -r sig id ver time satt alt altd long longd speed az date flags data1 data3 data4 data5
do

	altdeg="$(echo $alt | head -c 2)"
	altpoi="$(echo $alt | tail -c 8)"
	altitude=`bc <<< "scale=4; $altdeg+$altpoi*100/60/100"`
	
	longdeg="$(echo $long | head -c 3)"
    longpoi="$(echo $long | tail -c 8)"
    longitude=`bc <<< "scale=4; $longdeg+$longpoi*100/60/100"`
	
	echo "<trkpt lat=\"$altitude\" lon=\"$longitude\"></trkpt>"

done

echo "</trkseg></trk></gpx>"

