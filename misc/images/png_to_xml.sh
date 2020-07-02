#!/bin/bash

# A script to generate Zabbix map XML from PNG images
# depends on base64

echo "Generating XML"

imagedir="$1"
outputfile="$2"

echo '<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
	<version>4.4</version>
	<date>'$(date "+%Y-%m-%d")'T'$(date "+%H:%M:%S")'Z</date>
  <images>' > "$outputfile"

imagecount=$(ls $imagedir/*.png | wc -l)
for imagefile in $imagedir/*.png; do
	((imagesdone++))
	echo "    <image>
      <name>$(basename "${imagefile%.png}")</name>
      <imagetype>1</imagetype>
      <encodedImage>$(base64 --wrap=0 "$imagefile")</encodedImage>
    </image>" >> "$outputfile"
	echo -n "$[$imagesdone*100/$imagecount]% "
done
echo '  </images>

</zabbix_export>' >> "$outputfile"
echo
