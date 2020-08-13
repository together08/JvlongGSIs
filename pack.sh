#!/bin/bash

echo "Start Packing"
echo ""
dirsize="$(du -sm "baseromdir" | awk '{print $1}' | sed 's/$/& (MB)/')"
size=$dirsize + 130
cd "$LOCALDIR"
time=$(date "+%Y%m%d")

# AB Pack
packimg="$romname"-JvlongGSI-AB-$time.img
$bindir/mke2fs -t ext4 -b 4096 "$outdir"/$packimg $size
$bindir/e2fsdroid -e -T 0 -S "baseromdir"/config/system_file_contexts -C "baseromdir"/config/system_fs_config  -a /system -f "baseromdir"/system "$outdir"/$packimg
echo "AB GSI Packing Finished."
echo "Path: $outdir/$packimg"

# Aonly Pack
packimg="$romname"-JvlongGSI-Aonly-$time.img
$bindir/mke2fs -t ext4 -b 4096 "$outdir"/$packimg $size
$bindir/e2fsdroid -e -T 0 -S "baseromdir"/config/system_file_contexts -C "baseromdir"/config/system_fs_config  -a /system -f "baseromdir"/system/system "$outdir"/$packimg
echo "Aonly GSI Packing Finished."
echo "Path: $outdir/$packimg"
