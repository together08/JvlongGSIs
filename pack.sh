echo "Start Packing"
echo ""
dirsize = "$(du -sm "baseromdir"/system | awk '{print $1}' | sed 's/$/& (MB)/')"
size = $dirsize + 130
cd "$LOCALDIR"


# mke2fs+e2fsdroid Pack
time = $(date "+%Y%m%d")
packimg = "$romname"-JvlongGSI-$time.img
$bindir/mke2fs -t ext4 -b 4096 "$outdir"/"packimg" $size
$bindir/e2fsdroid -e -T 0 -S "baseromdir"/config/system_file_contexts -C "baseromdir"/config/system_fs_config  -a /system -f "baseromdir"/system "$outdir"/"packimg"
echo "Packing Finished."
echo "Path: $outdir/$packimg"

