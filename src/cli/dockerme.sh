#!/bin/bash

load_config() {
    config_path="$HOME/.config/containerme.sh"
    if [ -f "$config_path" ]; then
        source "$config_path"
    fi
}

new() {
    load_config
    IMAGE="$1"
    NAME="$2"
    echo $NAME
    if [ -z $NAME ]; then
        echo $NAME
        NAME="${IMAGE}"
    fi
    PORT=$(curl "$URL/api/containers" -X POST -H "Content-Type: application/json" -d "{\"name\": \"${NAME}\", \"image\": \"$IMAGE\"}" 2> /dev/null | jq -r '.binds[0].HostPort')
    echo "Container running. SSH is forwarded on port $PORT"
}

rmct() {
    load_config
    NAME="$1_containerme"
    SUCCESS=$(curl "$URL/api/containers" -X DELETE -H "Content-Type: application/json" -d "{\"name\": \"${NAME}\"}" 2> /dev/null | jq -r '.success')
    if [ $SUCCESS = "false" ]; then
        echo "Container $NAME not found"
        exit 1
    fi
    echo "Container $NAME removed"
}

lsct() {
    load_config
    curl "$URL/api/containers" 2> /dev/null | jq '.containers | .[] | {name: .Name, image: .image, port: .ports[0].HostPort}'

}

restart() {
    load_config
    NAME="$1_containerme"
    SUCCESS=$(curl "$URL/api/containers?restart=1" -X PATCH -H "Content-Type: application/json" -d "{\"name\": \"${NAME}\"}" 2> /dev/null | jq -r '.success')
    if [ $SUCCESS = "false" ]; then
        echo "Container $NAME not found"
        exit 1
    fi
    echo "Container $NAME restarted"
}

while [ "$1" != "" ]; do
    case $1 in
        "new")
            new $2 $3
            exit
            ;;
        "rm")
            rmct $2
            exit
            ;;
        "ls")
            lsct
        ;;
        "restart")
            restart $2
            exit
            ;;
        *)
            echo "Usage: $0 [new|rm|ls|restart]"
            exit 1
            ;;
    esac
    shift
done