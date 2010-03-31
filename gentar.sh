now=`date '+%m-%d-%y'`
filename="puppetdocs-$now.tar"
(rm $filename)
(rm $filename.gz)
rake generate
(cd output && tar -cvf ../$filename *)
gzip $filename
cp $filename.gz puppetdocs-latest.tar.gz
