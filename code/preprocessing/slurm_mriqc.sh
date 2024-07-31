#!/bin/bash

# Run from BIDS code/preprocessing directory: sbatch slurm_mriqc.sh

# Name of job?
#SBATCH --job-name=mriqc

# Set array to be your subject number(s)
#SBATCH --array=002,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,020,021,022,023,101,201,112,212

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
#SBATCH --mail-user=YOUREMAIL@DOMAIN.com
#SBATCH --mail-type=BEGIN,END,FAIL

# Remove modules because Singularity shouldn't need them
echo "Purging modules"
module purge

# Print job submission info
echo "Slurm job ID: " $SLURM_JOB_ID
date

# # Set subject ID based on array index
printf -v subj "%03d" $SLURM_ARRAY_TASK_ID

# PARTICIPANT LEVEL
echo "Running MRIQC on sub-$subj"

./run_mriqc.sh $subj

echo "Finished running MRIQC on sub-$subj"
date

# GROUP LEVEL
echo "Running MRIQC on group"

./run_mriqc_group.sh

echo "Finished running MRIQC on group"
date
