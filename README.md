# h02-server
Simple server to receive GPS data from h02 protocol compatible devices, like sinotrack st-901

Requirements:

`sudo apt-get install ucspi-tcp`

To start server:

`tcpserver -R -H -v 0.0.0.0 12345 /path/to/server.sh`
