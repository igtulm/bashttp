#!/bin/bash

. config/config

. modules/console
. modules/debug
. modules/http

debug__on="${config[debug_on]}"
debug__file="${config[debug_file]}"

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
