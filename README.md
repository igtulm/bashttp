# Bash Http
> A web server written in Bash

Run
===

This application uses [ucspi-tcp](https://en.wikipedia.org/wiki/Ucspi-tcp) for socket listening.

Ubuntu
------

1) Before running execute `sudo apt-get install ucspi-tcp`
2) Change your directory to the application root
3) Run the application: `./app start`

Docker
------

1) Change your directory to the application root
2) Build a container `docker build -t bashttp .`
3) Run the application in the container: `docker run --rm -ti -v $(pwd):/usr/src/app -w /usr/src/app -p 3000:3000 bashttp`

TODO
====

The main idea of the project is a simple API implementation. I am moving towards this direction now.

