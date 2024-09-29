#! /bin/bash

# This script will cleanup files to make them BIDS compatible.
# The goal here is to fix any errors and/or warnings from the BIDS validator.

echo 'starting up the script'
set -e #stop immediately if error occurs

echo 'about to import globals'
# LOAD IN GLOBAL VARIABLES
source globals.sh

echo 'about to assign subject'
subj=$1

# delete scout images
# KIRSTEN UNCOMMENTED THIS LINE AND THE LINE BELOW IT - RECOMMENT THEM
echo 'about to remove scout files'
find $bids_dir/sub-$subj -name "*scout*" -delete

echo 'about to remove dup files'
# delete duplicate runs if you run multiple -- OPTIONAL FOR YOU
# find $bids_dir/sub-$subj -name "*dup*" -delete

# if you took AP/PA fieldmaps, here's an example on modifying the output to be bids-compatible
# MAKE SURE YOU MODIFY THE FILENAMES TO MATCH YOUR STUDY'S FILENAMES

#####################################
# KZ - didn't need to change the filename, they already have "epi" instead of "magnitude"

# # change _magnitude to _epi in filename for fieldmap niftis and jsons:
# mv $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-AP_magnitude.json $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-AP_epi.json
# mv $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-AP_magnitude.nii.gz $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-AP_epi.nii.gz
# mv $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-PA_magnitude.json $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-PA_epi.json
# mv $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-PA_magnitude.nii.gz $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-PA_epi.nii.gz

#####################################
# KZ - we do want to do this one

# If you want fmriprep to use your fieldmaps for susceptibility distortion correction,
# you need to tell fmriprep which fieldmaps to use to correct each functional run.

# To do this, you add an IntendedFor line to fieldmap json files. We provide an example below,
# but keep in mind you need to EDIT THIS FOR YOUR SPECIFIC STUDY (e.g., number of runs, task names, etc.)

echo 'about to insert IntendedFor'

# SESSION 1: list all run filenames
beginning='"IntendedFor": ['
run1="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-01_bold.nii.gz"\","
run2="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-02_bold.nii.gz"\","
run3="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-03_bold.nii.gz"\","
run4="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-04_bold.nii.gz"\","
run5="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-05_bold.nii.gz"\","
run6="\""ses-01/func/sub-${subj}_ses-01_task-PredictingAttention_run-06_bold.nii.gz"\""
end="],"

# KZ - note for subjects 1 and 12, corresponding to 101&201 and 112&212, the lines above should change to reflect the number of runs for that subjects

#insert="${beginning}${run1} ${run2} ${run3} ${run4} ${run5} ${run6}${end}"
insert="${beginning}${run1}${end}"

# # insert IntendedFor field after line 35 (i.e., it becomes the new line 36)
sed -i "35 a \ \ ${insert}" $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-AP_epi.json
echo 'insertion 1 complete'

sed -i "35 a \ \ ${insert}" $bids_dir/sub-$subj/ses-01/fmap/sub-${subj}_ses-01_dir-PA_epi.json
echo 'insertion 2 complete'

# # SESSION 2: list all run filenames
# run1="\""ses-02/func/sub-${subj}_ses-02_task-postscenes_run-01_bold.nii.gz"\","
# run2="\""ses-02/func/sub-${subj}_ses-02_task-familiarization_run-01_bold.nii.gz"\","
# run3="\""ses-02/func/sub-${subj}_ses-02_task-reward_run-01_bold.nii.gz"\","
# run4="\""ses-02/func/sub-${subj}_ses-02_task-reward_run-02_bold.nii.gz"\","
# run5="\""ses-02/func/sub-${subj}_ses-02_task-decision_run-01_bold.nii.gz"\","
# run6="\""ses-02/func/sub-${subj}_ses-02_task-familiarization_run-02_bold.nii.gz"\","
# run7="\""ses-02/func/sub-${subj}_ses-02_task-reward_run-03_bold.nii.gz"\","
# run8="\""ses-02/func/sub-${subj}_ses-02_task-reward_run-04_bold.nii.gz"\","
# run9="\""ses-02/func/sub-${subj}_ses-02_task-decision_run-02_bold.nii.gz"\","
# run10="\""ses-02/func/sub-${subj}_ses-02_task-postfaces_run-01_bold.nii.gz"\""

# insert="${beginning}${run1} ${run2} ${run3} ${run4} ${run5} ${run6} ${run7} ${run8} ${run9} ${run10}${end}"

# sed -i "35 a \ \ ${insert}" $bids_dir/sub-$subj/ses-02/fmap/sub-${subj}_ses-02_dir-AP_epi.json
# sed -i "35 a \ \ ${insert}" $bids_dir/sub-$subj/ses-02/fmap/sub-${subj}_ses-02_dir-PA_epi.json
