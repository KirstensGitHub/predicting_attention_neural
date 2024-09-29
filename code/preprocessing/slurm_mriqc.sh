#!/bin/bash

# Run from BIDS code/preprocessing directory: sbatch slurm_mriqc.sh

# Name of job?
#SBATCH --job-name=mriqc

# Set array to be your subject number(s)
#SBATCH --array=201

# Where to output log files?
# make sure this logs directory exists!! otherwise the script won't run
#SBATCH --output='../../data/bids/derivatives/mriqc/logs/mriqc-%A_%a.log'

# Set partition
#SBATCH --partition=all

# How long is job?
#SBATCH -t 18:00:00

# How much memory to allocate (in MB)?
#SBATCH --cpus-per-task=8 --mem-per-cpu=14000

# Update with your email
#SBATCH --mail-user=kz0108@princeton.edu
#SBATCH --mail-type=BEGIN,END,FAIL

# Remove modules because Singularity shouldn't need them
echo "Purging modules"
echo "++++++++++++++++++++++++++++++++++++++++"
module purge

# Print job submission info
echo "Slurm job ID: " $SLURM_JOB_ID
echo "++++++++++++++++++++++++++++++++++++++++"
date


# # Set subject ID based on array index
printf -v subj "%03d" $SLURM_ARRAY_TASK_ID
echo "++++++++++++++++++++++++++++++++++++++++"


# PARTICIPANT LEVEL
echo "++++++++++++++++++++++++++++++++++++++++
echo "+++++++++++i+++++++++++++++++++++++++++++""
#echo "Running MRIQC on sub-$subj"
echo "Running MRIQC in sub-201"
echo "++++++++++++++++++++++++++++++++++++++++"
echo "++++++++++++++++++++++++++++++++++++++++"

./run_mriqc.sh 201 #$subj

echo "-------------------------------"
echo "Finished running MRIQC on sub-$subj"
date

# GROUP LEVEL -- uncomment the two lines below for group level
#echo "Running MRIQC on group"
#./run_mriqc_group.sh

#echo "KIRSTEN READ THIS -------------------------------"
#echo "Finished running MRIQC on group"
#date
