## Preprocessing MRI data

These scripts show the steps taken to preprocess the MRI data for analysis.

We provide the preprocessed data publicly [here](https://www.dropbox.com/scl/fo/6wzepx3baxel0f4n62k3s/AP4xny1B7vN7hXr6pBclmw8?rlkey=2kr2y9ba748lhhsu35avv51e2&st=fhbupdc6&dl=0)

Data was preprocessed by running the steps in step1_preproc and step2_preproc, followed by MRIqc and fMRIprep. We opted to run MRIqc and fMRIprep on a computing cluster, submitting it using SLURM (e.g. via `slurm_fmriprep.sh`).
  - `step1_preproc.sh`
  - `step2_preproc.sh`
  - `slurm_mriqc.sh`
  - `slurm_fmriprep.sh`
    * note: minor alterations were made to these scripts in the case of two subjects who had data from extra runs (subjects 1 and 12 who, for processing purposes were each treated as two unique subjects - 101 & 201, and 112 & 212, respectively).
