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
rompath = "$1"
romname = "$2"
tmpdir = "./temp/"
toolsdir = "$LOCALDIR/tools"
imgextractor = "$toolsdir/imgextractor/imgextractor.py"
mkdir "$tmpdir"
echo "Make ErfanGSI First."
bash ./erfan-tools/url2GSI.sh "$rompath" "$romname"
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
erfan_product = $(ls ./erfan-tools/output/ | grep -i "ErfanGSI" | grep "img" | grep "AB")
mv "$erfan_product" "$tmpdir"/erfangsi.img
echo "Starting JvlongGSIs Make..."


baseromdir = "$tmpdir"/base-rom
erfandir = "$tmpdir"/erfangsi

# Mount system.img and copy files
bash ./unpack.sh "$rompath" "$baseromdir"
cd "$baseromdir"
mkdir system
python3 $imgextractor ./system.img ./system

cd "$erfandir"
mkdir system
python3 $imgextractor ./erfangsi.img ./system
# Use diff to compare and add files
diff
# Package The GSI
