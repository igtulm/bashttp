#!/bin/bash

nohup ./app start &

cd web

nohup python -m CGIHTTPServer 3001 &
nohup php -S localhost:3002 &
nohup node-http-server port=3003 &

sleep 1

echo -ne "\n\nTesting bashttp...\n\n"
wrk -t2 -c9 -H 'Host: 127.0.0.1' http://127.0.0.1:3000/
echo -ne "\n\n"

echo -ne "Testing python...\n\n"
wrk -t2 -c9 -H 'Host: 127.0.0.1' http://127.0.0.1:3001/
echo -ne "\n\n"

echo -ne "Testing php...\n\n"
wrk -t2 -c9 -H 'Host: 127.0.0.1' http://127.0.0.1:3002/
echo -ne "\n\n"

echo -ne "Testing node...\n\n"
wrk -t2 -c9 -H 'Host: 127.0.0.1' http://127.0.0.1:3003/
echo -ne "\n\n"

sleep 1

killall -9 tcpserver
killall -9 python
killall -9 php
killall -9 node
