#!/bin/bash

while read -d '#' line; do
	sig="$(echo $line | head -c 1)"
	if [ "$sig" == "*" ]
	then
		printf '%s\n' "$line" >> server.txt
	else
		printf '%s\n' "$line" >> server_error.txt
		exit 1
	fi
done

