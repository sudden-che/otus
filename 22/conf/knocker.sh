#!/bin/bash

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

me=`basename "$0"`

if [[ $# -eq 0 ]]; then
    echo "Usage: ./$me "
    exit 1
fi

ipaddr="${1}"
for port in '2222:udp' '3333:udp' '4444:udp'; do {
    echo "${port}"
    proto="$(awk -F: '{print $2}' <<< "${port}")"
    port="$(awk -F: '{print $1}' <<< "${port}")"
    case "${proto}" in
        "tcp") nc "${ipaddr}" "${port}"
            ;;
        "udp") echo close | nc "${ipaddr}" -u "${port}"
            ;;
        *) echo "Failed: Invalid Protocol"
    esac
}
done
