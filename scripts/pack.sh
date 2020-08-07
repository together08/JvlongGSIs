bin = 

echo ""
echo "开始打包"
echo ""
echo "当前img大小为: "
echo ""
echo "_________________"
echo ""
du -sh ./out/system | awk '{print $1}'
#echo ""
du -sm ./out/system | awk '{print $1}' | sed 's/$/& (MB)/'
#echo ""
du -sb ./out/system | awk '{print $1}' | sed 's/$/& (B)/'
echo "_________________"
echo ""
#read -p "按任意键开始打包" var
#size="$(du -sb ./out/system | awk '{print $1}')"
echo "用MB单位大小 在自动识别的大小添加120M左右以保证打包成功率"
echo ""
read -p "请输入要打包的数值: " size

#make_ext4fs打包
#./make_ext4fs -T 0 -S ./out/config/system_file_contexts -C ./out/config/system_fs_config -l $size -a /system ./out/system.img ./out/system

#mke2fs+e2fsdroid打包
$bin/mke2fs -t ext4 -b 4096 ./out/system.img $size
$bin/e2fsdroid -e -T 0 -S ./out/config/system_file_contexts -C ./out/config/system_fs_config  -a /system -f ./out/system ./out/system.img
#$bin/mkuserimg_mke2fs.sh "./out/system" ext4 "./out/system.img" /system $size -T 0 -C ./out/config/system_fs_config -c ./out/config/system_file_contexts
echo "打包完成"
echo "