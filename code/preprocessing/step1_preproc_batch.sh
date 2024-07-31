#! /bin/bash

source globals.sh

exclude=("1" "12")

function process_dir () {
	sub_name=$(basename $1)
	if [[ $sub_name == patient* ]] || [[ $sub_name == sub* ]]
	then
		raw_num=$(echo "$sub_name" | grep -Po "(?<=_)\d+" )
		num=$( printf "%03d" "$raw_num" )
		echo "--- SUBJECT $raw_num ---"

		skip=false
		for skip_num in "${exclude[@]}"; do
			if [ $raw_num == $skip_num ]; then
				skip=true
				break
			fi
		done

		if [ "$skip" = false ]; then
			echo "running step1_preproc.sh"
			./step1_preproc.sh $num 01 $sub_name |& tee logs/preproc1/$num.txt
		else
			echo "patient number in 'exclude' array; skipping"
		fi
	fi
}

for subdir in /$scanner_dir/*
do
	process_dir $subdir
done
