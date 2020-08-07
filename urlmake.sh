#!/bin/bash

# Made By together08

usage() {
    echo "Usage: $0 <URL of firmware> <ROM NAME>"
    echo -e "\tURL to firmware: The URL of the firmware"
    echo -e "\tROM NAME: The ROM's name"
}

if [ "$2" == "" ]; then
    echo "ERROR: Please enter all needed parameters"
    usage
    exit 1
fi

DOWNLOAD()
{
    URL="$1"
    ZIP_NAME="$2"
    echo "Downloading firmware to: $ZIP_NAME"
    aria2c -x16 -j$(nproc) -U "Mozilla/5.0" -d "$PROJECT_DIR/input" -o "$ACTUAL_ZIP_NAME" ${URL} || wget -U "Mozilla/5.0" ${URL} -O "$ZIP_NAME"
}

if [[ "$URL" == "http"* ]]; then
        # URL detected
        RANDOMM=$(echo $RANDOM)
        ACTUAL_ZIP_NAME="$RANDOMM"_FIRMWARE.tgz
        ZIP_NAME="$PROJECT_DIR"/input/"$RANDOMM"_FIRMWARE.tgz
        DOWNLOAD "$URL" "$ZIP_NAME"
        URL="$ZIP_NAME"
    fi

