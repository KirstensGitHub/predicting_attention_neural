# !/bin/bash

source globals.sh

event_files=$(find $bids_dir -type f -name "*events.tsv")

for file in $event_files; do
	echo "processing $file"
	sed -i 's/,\s\*TODO.\+//' $file
done
