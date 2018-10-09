#!/bin/bash

echo "Content-type: text/html\r\n\r\n"

BASE_DIR=/path/to/gps-simple-server/

link_h0=`grep N $BASE_DIR/server_h0.csv | grep A    | tail -n 1 | ./export.sh | head -n 4 | tail -n 1 | awk -F '"' '{ printf("http://www.google.com/maps/place/%s,%s",$2,$4) }'`
link_wa=`grep N $BASE_DIR/server_wa.csv | grep -v V | tail -n 1 | ./export.sh | head -n 4 | tail -n 1 | awk -F '"' '{ printf("http://www.google.com/maps/place/%s,%s",$2,$4) }'`

echo "h0: <a href=\"$link_h0\">$link_h0</a><br>"
echo "wa: <a href=\"$link_wa\">$link_wa</a>"
