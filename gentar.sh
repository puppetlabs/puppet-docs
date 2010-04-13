rm -rf output
mkdir output
rake generate
# very lame hack to make docs usable via relative paths
# for downloaded copies, which requires that HTML
# versions also have relative paths.  
cd output
ln -s ../files guides/files
ln -s ../../files guides/types/files
ln -s ../../../files guides/types/nagios/files
ln -s ../../../files guides/types/selinux/files
ln -s ../../files guides/types/ssh/files
ln -s ../files references/files
cd -
now=`date '+%m-%d-%y'`
filename="puppetdocs-$now.tar"
(rm $filename)
(rm $filename.gz)
(cd output && tar -cvf ../$filename *)
gzip $filename
cp $filename.gz puppetdocs-latest.tar.gz
