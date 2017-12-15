FROM phusion/baseimage:0.9.22

RUN apt-get update && apt-get install -y \
    build-essential libssl-dev git ucspi-tcp python php nodejs 

RUN cd && git clone https://github.com/wg/wrk.git && \
    cd wrk && make -j4 && cp wrk /usr/local/bin

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
