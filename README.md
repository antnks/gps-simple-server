# GPS simple server
Simple server to receive GPS data from a tracker device. Supported protocols:

* h02 - [protocol document](https://dl.dropboxusercontent.com/s/o1723krpnn0jvqo/document.pdf), example devices: `sinotrack st-901`

Requirements:

`sudo apt-get install ucspi-tcp bc`

To start server:

`tcpserver -R -H -v 0.0.0.0 12345 /path/to/server.sh`

Advanced startup command:

`sudo -H -u username bash -c "/usr/bin/tcpserver -c 1000 -R -H -v 0.0.0.0 12345 timeout 180 /home/username/git/gps-simple-server/server.sh 2>&1 | logger &"`

Where:

* `-u username` - linux user to run the process
* `-c 1000` - maximum allowed connections
* `timeout 180` - script will be killed in 180 seconds and restarted
* `| logger` - tcpserver's info aout established connections will be sent to syslog
