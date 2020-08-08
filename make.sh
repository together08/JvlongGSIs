#!/bin/bash

# Made By together08

usage() {
    echo "Usage: $0 <Path to firmware> <ROM NAME>"
    echo -e "\tPath to firmware: The zip"
    echo -e "\tROM NAME: The ROM's name"
}

if [ "$2" == "" ]; then
    echo "ERROR: Please enter all needed parameters"
    usage
    exit 1
fi

LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mkdir output
HOST="$(uname)"
rompath="$1"
romname="$2"
tmpdir="./temp"
scriptdir="$LOCALDIR/scripts"
toolsdir="$LOCALDIR/tools"
bindir="$toolsdir/bin/$HOST"
imgextractor="$toolsdir/imgextractor/imgextractor.py"
outdir="./output"

echo "Update tools..."
git pull
cd erfan-tools
git pull
echo "Update finished."
cd "$LOCALDIR"

mkdir -p "$tmpdir"
echo "Make ErfanGSI First."
bash ./erfan-tools/url2GSI.sh "$rompath" "$romname" -ab
# If erfan make failed, don't go on
if [ $? -ne 0 ]; then 
           echo "ErfanGSI make failed."
           exit 1
fi
echo ""
echo ""
echo ""
echo "ErfanGSI Make Finished."
echo "Copy ErfanGSI's GSI."
erfan_product=$(ls "./erfan-tools/output/" | grep -i "ErfanGSI" | grep "img" | grep "AB")
cp $erfan_product "$tmpdir"/erfangsi.img
echo "Starting JvlongGSIs Make..."


baseromdir="$tmpdir/base-rom"
erfandir="$tmpdir/erfangsi"

# Mount system.img and copy files
bash ./unpack.sh "$rompath" "$baseromdir"
cd "$baseromdir"
mkdir -p system
python3 $imgextractor ./system.img ./system

cd "$erfandir"
mkdir -p system
python3 $imgextractor ./erfangsi.img ./system

# Get Device Info
bash "$scriptdir/getinfo.sh" "$baseromdir"
source "$scriptdir/getinfo.sh"

# Get PT Info
sourcetype="Aonly"
if [ -d "$baseromdir/system/system" ]; then
    sourcetype="AB"
fi

# Copy bin files
if ["$sourcetype"="Aonly"]; then # Aonly or AB, Need to be know
	baserombin="$baseromdir/system/bin"
else
	baserombin="$baseromdir/system/system/bin"
fi
erfanbin="$erfandir/system/system/bin"
cp -n "$erfanbin"/* "$baserombin"

# Package The GSI
bash pack.sh

