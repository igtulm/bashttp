FROM ubuntu:16.04

RUN apt-get update && apt-get install -y ucspi-tcp \
    rm -rf /var/lib/apt/lists/*

CMD bash app start

