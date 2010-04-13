rake generate
# very lame hack to make docs usable via relative paths
# for downloaded copies, which requires that HTML
# versions also have relative paths.  
cp -r output/files output/guides/files
cp -r output/files output/guides/types/files
cp -r output/files output/guides/types/nagios/files
cp -r output/files output/guides/types/selinux/files
cp -r output/files output/guides/types/ssh/files
cp -r output/files output/references/files
now=`date '+%m-%d-%y'`
filename="puppetdocs-$now.tar"
(rm $filename)
(rm $filename.gz)
(cd output && tar -cvf ../$filename *)
gzip $filename
cp $filename.gz puppetdocs-latest.tar.gz
