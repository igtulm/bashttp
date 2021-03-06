# MODULE: http

# const

http__PROTOCOL_VER="HTTP/1.1"

declare -A http__METHODS=(
    [HEAD]=HEAD
    [GET]=GET
    [POST]=POST
    [PUT]=PUT
    [DELETE]=DELETE
    [CONNECT]=CONNECT
    [OPTIONS]=OPTIONS
    [TRACE]=TRACE
    [PATCH]=PATCH
)

declare -A http__RESPONSES=(
    [200]=OK
    [400]="Bad Request"
    [401]=Unauthorized
    [403]=Forbidden
    [404]="Not Found"
    [405]="Method Not Allowed"
    [500]="Internal Server Error"
)

# var

http__req_protocol=
http__req_method=
http__req_route=
http__req_body=
http__res_code=
http__res_body=

declare -A http__req_headers
declare -A http__res_headers

http__server_name=""
http__timeout=3000
http__serve_dir="./"


# func

http__request() {
    local request_start_line=

    # Read start line
    read -t "$http__timeout" -r request_start_line

    local start_line="$(echo $request_start_line| tr -d '\r')"
    if (($(echo $start_line | wc -w) != 3)); then
        http__response 400

        exit 0
    fi

    http__req_protocol="$(echo $start_line| cut -d ' ' -f 3)"
    if [ $http__req_protocol != $http__PROTOCOL_VER ]; then
        http__response 400

        exit 0
    fi

    http__req_method="$(echo $start_line| cut -d ' ' -f 1)"
    if [ ! ${http__METHODS[$http__req_method]} ]; then
        http__response 405

        exit 0
    fi

    http__req_route="$(echo $start_line| cut -d ' ' -f 2| tr /A-Z/ /a-z/)"

    # Read headers
    # TODO: if there is no Host at first header then throw msg and close connection instantly without iterations more
    while read -t "$http__timeout" -r request_header; do
        header="$(echo $request_header| tr -d '\r')"

        # break on empty string
        [ -z "$header" ] && break

        header_key="$(echo $header| cut -d ':' -f 1)"
        header_value="$(echo $header| cut -d ' ' -f 2-)"

        http__req_headers[$header_key]=$header_value
    done

    # Read message-body if Content-Length header is presented
    if [ ${http__req_headers[Content-Length]} ]; then
        # Read message-body to buffer
        read -t "${config[timeout]}" -r http__req_body

        # Cut data from buffer with length specified
        http__req_body="$(printf "%s" $http__req_body| tr -d '\r'| cut -c -${http__req_headers[Content-Length]})"
    fi
}

http__throw_json_msg_by_code() {
    local status_code=$1

    http__res_headers[Content-Type]="application/json"
    http__res_body="$(printf "{code: %d, message: %s}" "$status_code" "${http__RESPONSES[$status_code]}")"

    http__setContentLength
}

http__response() {
    local root="${config[web_root]}"
    local path="$http__req_route"

    local target="$root$path"

    if [ -d $target ]; then
        target+="index.html"
    fi

    # TODO check if target doesn't exist

    debug__toFile $target

    http__res_code=200
    local status_code="$http__res_code"

    local status_line="$(printf "%s %u %s" "$http__PROTOCOL_VER" "$status_code" "${http__RESPONSES[$status_code]}")"
    http__res_headers[Server]="${config[server_name]}"
    http__res_headers[Date]="$(date +"%Y-%m-%d %T")"
    http__res_headers[Connection]=close

    if (($status_code < 200)) || (($status_code >= 300)); then
        http__throw_json_msg_by_code $status_code
    fi

    # send response
    echo -n "$status_line"
    echo -en "\r\n"
    local response_headers_string=""
    for key in "${!http__res_headers[@]}"; do
        echo -en "$key: "${http__res_headers["$key"]}"\r\n"
        response_headers_string+="$key: "${http__res_headers["$key"]}"; "
    done
    echo -en "\r\n"

    cat "$target"

    echo -en "\r\n"
}

http__try_route() {
    http__res_code=404

    # To do
    return -1
}

http__setMesageBodyForFile() {
    http__res_body="$(<"$1")"
    http__res_headers[Content-Length]="$(stat -c %s $1)"
}

http__setContentLength() {
    return
    http__res_headers[Content-Length]="$(echo -n "$http__res_body"| wc -c)"
}

http__setContentTypeForFile() {
    local extension="$(basename $1| rev | cut -d . -f 1 | rev)"

    case "$extension" in
        aac) type="audio/aac";;
        abw) type="application/x-abiword";;
        arc) type="application/octet-stream";;
        avi) type="video/x-msvideo";;
        azw) type="application/vnd.amazon.ebook";;
        bin) type="application/octet-stream";;
        bz) type="application/x-bzip";;
        bz2) type="application/x-bzip2";;
        csh) type="application/x-csh";;
        css) type="text/css";;
        csv) type="text/csv";;
        doc) type="application/msword";;
        eot) type="application/vnd.ms-fontobject";;
        epub) type="application/epub+zip";;
        gif) type="image/gif";;
        htm) type="text/html";;
        html) type="text/html";;
        ico) type="image/x-icon";;
        ics) type="text/calendar";;
        jar) type="application/java-archive";;
        jpeg) type="image/jpeg";;
        jpg) type="image/jpeg";;
        js) type="application/javascript";;
        json) type="application/json";;
        midi) type="audio/midi";;
        mpeg) type="video/mpeg";;
        mpkg) type="application/vnd.apple.installer+xml";;
        odp) type="application/vnd.oasis.opendocument.presentation";;
        ods) type="application/vnd.oasis.opendocument.spreadsheet";;
        odt) type="application/vnd.oasis.opendocument.text";;
        oga) type="audio/ogg";;
        ogv) type="video/ogg";;
        ogx) type="application/ogg";;
        otf) type="font/otf";;
        png) type="image/png";;
        pdf) type="application/pdf";;
        ppt) type="application/vnd.ms-powerpoint";;
        rar) type="application/x-rar-compressed";;
        rtf) type="application/rtf";;
        sh) type="application/x-sh";;
        svg) type="image/svg+xml";;
        swf) type="application/x-shockwave-flash";;
        tar) type="application/x-tar";;
        tiff) type="image/tiff";;
        ts) type="video/vnd.dlna.mpeg-tts";;
        ttf) type="font/ttf";;
        vsd) type="application/vnd.visio";;
        wav) type="audio/x-wav";;
        weba) type="audio/webm";;
        webm) type="video/webm";;
        webp) type="image/webp";;
        woff) type="font/woff";;
        woff2) type="font/woff2";;
        xhtml) type="application/xhtml+xml";;
        xls) type="application/vnd.ms-excel";;
        xml) type="application/xml";;
        xul) type="application/vnd.mozilla.xul+xml";;
        zip) type="application/zip";;
        7z) type="application/x-7z-compressed";;

        *) type="$(file -ib "$1")" ;;
    esac

    http__res_headers[Content-Type]="$type"
}

http__try_file() {
    http__res_code=404

    local root="${config[web_root]}"
    local path="$http__req_route"

    local target="$root$path"

    if [ -d $target ]; then
        target+="/index.html"
    fi

    if [ -f $target ]; then
        http__setMesageBodyForFile "$target"
        http__setContentTypeForFile "$target"
        http__setContentLength

        http__res_code=200

        return
    fi

    return -1
}

# END
