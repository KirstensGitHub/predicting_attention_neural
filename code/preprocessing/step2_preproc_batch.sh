#! /bin/bash

source globals.sh

exclude=("101" "201" "112" "212")

for subdir in /$bids_dir/*; do
	dir_name=$(basename $subdir)
	if [[ $dir_name == sub-* ]]; then
		num=$(echo "$dir_name" | grep -Po "\d+$")
		skip=false
		for skip_num in "${exclude[@]}"; do
			if [ $num == $skip_num  ]; then
				skip=true
				break
			fi
		done

		if [ $skip == false ]; then
			echo "running step2_preproc.sh on $num"
			./step2_preproc.sh $num |& tee logs/preproc2/$num.txt
		else
			echo "$num in exclude group; skipping"
		fi
	fi
done
