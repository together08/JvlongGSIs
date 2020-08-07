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


rompath = "$1"
romname = "$2"
tmpdir = "./temp/"
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
echo "Copy ErfanGSI's Product."
erfan_product = $(ls ./erfan-tools/output/ | grep -il "ErfanGSI" | grep -il "AB" | grep -il "*.img")
mv "$erfan_product" "$tmpdir"/erfangsi.img
echo "Starting JvlongGSIs Make..."


baseromdir = "$tmpdir"/base-rom
erfandir = "$tmpdir"/erfangsi

# Mount system.img and copy files
bash ./unpack.sh "$rompath" "$baseromdir"
bash ./unpack.sh "$tmpdir"/erfangsi.img "$erfandir"
cd "$tmpdir"
cd base-rom
mkdir system_mount
mkdir system
sudo mount ./system.img system_mount
cp -r system_mount/* system
sudo umount system_mount
rm -rf system_mount
cd ..
cd erfangsi
mkdir system_mount
mkdir system
sudo mount ./system.img system_mount
cp -r system_mount/* system
sudo umount system_mount
rm -rf system_mount

# Use diff to compare and add files
diff
# Package The GSI
