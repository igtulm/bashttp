#!/bin/bash

source modules/console
source modules/http
source modules/config

start() {
    local script_path=$0

    console__info "Starting server on ${config[ip]}:${config[port]}"

    tcpserver "${config[ip]}" "${config[port]}" "./$script_path" connection_handler
}

connection_handler() {
    http__request
    http__try_route || http__try_file
    http__response
}

$@
