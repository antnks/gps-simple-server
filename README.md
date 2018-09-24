# GPS simple server
Simple server to receive GPS data from a tracker device. Supported protocols:

* h02 - [protocol document](https://dl.dropboxusercontent.com/s/o1723krpnn0jvqo/document.pdf), example devices: `sinotrack st-901`

Requirements:

`sudo apt-get install ucspi-tcp bc`

To start server:

`tcpserver -R -H -v 0.0.0.0 12345 /path/to/server.sh`


