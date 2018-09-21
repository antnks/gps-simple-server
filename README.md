# h02-server
Simple server to receive GPS data from h02 protocol compatible devices, like sinotrack st-901

Requirements:

`sudo apt-get install ucspi-tcp bc`

To start server:

`tcpserver -R -H -v 0.0.0.0 12345 /path/to/server.sh`

Protocol: https://dl.dropboxusercontent.com/s/o1723krpnn0jvqo/document.pdf
