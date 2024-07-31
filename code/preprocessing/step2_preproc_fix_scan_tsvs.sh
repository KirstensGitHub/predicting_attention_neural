#! /bin/bash

source globals.sh

for subdir in /$bids_dir/*; do
	dir_name=$(basename $subdir)
	if [[ $dir_name == sub-* ]]; then
		num=$(echo "$dir_name" | grep -Po "\d+$")
		echo "$dir_name:"

		scans_fp="$bids_dir/$dir_name/ses-01/${dir_name}_ses-01_scans.tsv"
		scans_old_fp="$scratch_dir/${dir_name}_ses-01_scans_OLD.tsv"

		if [ ! -f "$scans_old_fp" ]; then
			echo "copying scans to scans_OLD"
			cp "$scans_fp" "$scans_old_fp"
		else
			echo "scans_OLD already exists for $dir_name, not copying"
		fi

		echo "deleting scout & dup names from scans tsv"
		sed -i '/scout/d' $scans_fp
		sed -i '/dup/d' $scans_fp
	fi
done	
