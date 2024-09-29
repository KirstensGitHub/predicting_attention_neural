#!/bin/bash

source globals.sh

export SINGULARITYENV_TEMPLATEFLOW_HOME=/home/fmriprep/.cache/templateflow

singularity run --cleanenv \
    --bind $project_dir:/project \
    --bind $scratch_dir:/scratch \
    --bind /usr/people \
    --bind /jukebox/hasson/templateflow:/home/fmriprep/.cache/templateflow \
    /jukebox/hasson/singularity/fmriprep/fmriprep-v23.0.0.simg \
    --participant-label sub-$1 \
    --fs-license-file /project/code/preprocessing/license.txt \
    --no-submm-recon \
    --use-syn-sdc --bold2t1w-dof 6 \
    --nthreads 8 --omp-nthreads 8 \
    --output-spaces T1w fsaverage:den-41k \
                    MNI152NLin2009cAsym:res-native MNI152NLin2009cAsym:res-2 \
    --write-graph --work-dir /scratch \
       /project/data/bids /project/data/bids/derivatives/fmriprep participant
