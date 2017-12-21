#!/bin/bash

nohup ./app.sh start >/dev/null 2>&1 &

cd web

nohup python -m CGIHTTPServer 3001 > /dev/null 2>&1 &
nohup php -S localhost:3002 > /dev/null 2>&1 &
nohup node-http-server port=3003 > /dev/null 2>&1 &

sleep 1

TEST_THREADS=2
TEST_CONNECTIONSS=10


echo -ne "\n\nTesting bashttp...\n\n"
wrk -t $TEST_THREADS -c $TEST_CONNECTIONSS -H 'Host: 127.0.0.1' http://127.0.0.1:3000/
echo -ne "\n\n"

echo -ne "Testing python...\n\n"
wrk -t $TEST_THREADS -c $TEST_CONNECTIONSS -H 'Host: 127.0.0.1' http://127.0.0.1:3001/
echo -ne "\n\n"

echo -ne "Testing php...\n\n"
wrk -t $TEST_THREADS -c $TEST_CONNECTIONSS -H 'Host: 127.0.0.1' http://127.0.0.1:3002/
echo -ne "\n\n"

echo -ne "Testing node...\n\n"
wrk -t $TEST_THREADS -c $TEST_CONNECTIONSS -H 'Host: 127.0.0.1' http://127.0.0.1:3003/
echo -ne "\n\n"

sleep 1

killall -9 tcpserver > /dev/null 2>&1
killall -9 python > /dev/null 2>&1
killall -9 php > /dev/null 2>&1
killall -9 node > /dev/null 2>&1
