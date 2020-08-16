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

export LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
mkdir output
export HOST="$(uname)"
export rompath="$1"
export romname="$2"
export tmpdir="$LOCALDIR/temp"
export scriptdir="$LOCALDIR/scripts"
export toolsdir="$LOCALDIR/tools"
export bindir="$toolsdir/bin/$HOST"
export imgextractor="$toolsdir/imgextractor/imgextractor.py"
export outdir="$LOCALDIR/output"

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
export erfan_product="$(ls "./erfan-tools/output/" | grep -i "ErfanGSI" | grep "img" | grep "AB")"
cp ./erfan-tools/output/$erfan_product "$tmpdir"
cd "$tmpdir"
mv $erfan_product erfangsi.img
cd ..
echo "Starting JvlongGSIs Make..."


export baseromdir="$tmpdir/base-rom"
export erfandir="$tmpdir/erfangsi"

# Mount system.img and copy files
bash ./unpack.sh "$rompath" "$tmpdir"

python3 $imgextractor "$tmpdir"/system.img "$tmpdir"
mv system base-rom

python3 $imgextractor "$tmpdir"/erfangsi.img "$tmpdir"

# Get PT Info
export sourcetype="Aonly"
if [ -d "$baseromdir/system" ]; then
    export sourcetype="AB"
fi

# Change bin dir with sourcetype
if [ "$sourcetype" == "Aonly" ]; then 
	export baserombin="$baseromdir/bin"
else
	export baserombin="$baseromdir/system/bin"
fi

# Copy bin files
export erfanbin="$erfandir/system/bin"
cp -n "$erfanbin"/* "$baserombin"

# Package The GSI
bash "$LOCALDIR"/pack.sh

# Clean up
bash "$LOCALDIR"/clean.sh 
