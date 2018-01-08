# Bash Http
> A web server written in Bash

Description
===========

A simple command-line http server written in Bash. It is useful for testing and local development.
It could be run everywhere where Bash is used.
There is no need to install huge dependencies or programming languages.

Run
===

This application uses [ucspi-tcp](https://en.wikipedia.org/wiki/Ucspi-tcp) for socket listening.

Ubuntu
------

1) Before running execute `sudo apt-get install ucspi-tcp`
2) Change your directory to the application root
3) Run the application: `./app.sh start`

Docker
------

1) Change your directory to the application root
2) Build a container `docker build -t bashttp .`
3) Run the application in the container: `docker run --rm -ti -v $(pwd):/usr/src/app -w /usr/src/app -p 3000:3000 bashttp ./app.sh start`
4) Run benchmarking in the container: `docker run --rm -ti -v $(pwd):/usr/src/app -w /usr/src/app bashttp ./bench.sh`

Benchmarks
----------
_Bashttp_
```
Running 10s test @ http://127.0.0.1:3000/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    91.32ms   50.19ms 479.86ms   92.04%
    Req/Sec    45.84     18.08    80.00     73.22%
  866 requests in 10.02s, 279.98KB read
  Socket errors: connect 0, read 0, write 0, timeout 4
Requests/sec:     86.40
Transfer/sec:     27.93KB
```


_Python embedded server_
```
Running 10s test @ http://127.0.0.1:3001/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     6.73ms   46.63ms 837.32ms   98.58%
    Req/Sec     1.02k     0.94k    3.67k    80.50%
  20315 requests in 10.09s, 7.54MB read
Requests/sec:   2012.69
Transfer/sec:    764.59KB
```

_PHP embedded server_
```
Running 10s test @ http://127.0.0.1:3002/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   344.43us   98.10us   5.33ms   93.63%
    Req/Sec    13.37k   620.60    14.78k    65.84%
  268717 requests in 10.10s, 81.75MB read
Requests/sec:  26605.69
Transfer/sec:      8.09MB
```


_node-http-server_
```
Running 10s test @ http://127.0.0.1:3003/
  2 threads and 10 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency   792.97us  417.15us  17.19ms   98.88%
    Req/Sec     6.49k   509.57     6.83k    96.00%
  129067 requests in 10.00s, 46.90MB read
Requests/sec:  12904.60
Transfer/sec:      4.69MB
```

TODO
====

The main idea of the project is a simple API implementation. I am moving towards this direction now.
