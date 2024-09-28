## Preprocessing MRI data

First, download the MRI data for this experiment from <mark>LINK HERE</mark>.

1. Edit `code/preprocessing/globals.sh` so that:
  - The `scanner_dir` path points to wherever you've saved the MRI data.
  - The `project_dir` points to the root of this repository.
  - The `scratch_dir` points to the `data/work` directory.
2. Put your FreeSurfer [license](https://surfer.nmr.mgh.harvard.edu/fswiki/License) in `code/preprocessing`.

3. `cd` into `code/preprocessing` and run:
  - `step1_preproc.sh`
  - `step2_preproc.sh`

4. Note: at some point you should check to make sure your data is properly bids formatted. You can do this by running  aspecific bids validation now or by using bids validation checks in fmriprep. 

5. Next, you will wnat to run `fmriprep`. You can decide if you are going to use `slurm` to handle these as batch jobs on a cluster (recommended) or run the scripts manually. (You may also optionally run `mriqc` to review your data before continuing)
  - Using `slurm`:
    - If you are on Princeton's Scotty computer cluster or a similar cluster in which your slurm nodes do not have internet access, each user will have to run `run_mriqc.sh` for a subject once *without* using slurm, to allow the program to download the necessary TemplateFlow files. You can do that by running `./run_mriqc.sh [3-digit subject code]` (eg. `./run_mriqc.sh 013`) for any subject besides 1 and 12, before proceeding to the slurm commands below.
    - Edit the `slurm_mriqc.sh` and `slurm_fmriprep.sh` files with your email & specific job details for your cluster.
    - Run `sbatch slurm_mriqc.sh`.
    - Run `sbatch slurm_fmriprep.sh`.
  - Manual: run
    - `run_mriqc_group.sh`
    - `run_fmriprep.sh` for all subjects in the study (eg. `./run_fmriprep.sh 013` for subject 13). Note that subjects 1 and 12, because their data collection was split into multiple parts, comprise 4 subject IDs: `101`, `201`, `112`, and `212`.
  - <mark>TODO: right now these scripts, slurm or otherwise, depend on the specific filepaths & `singularity` command of PNI, so you will need to update them to accommodate your computing environment.</mark>

After the steps above are completed, all the MRI data should be nicely organized in the `data` folder. Error logs can be found in the `code/preprocessing/logs` folder. You can investigate the mriqc and fmriprep outputs in their respective folders within the `data/bids/derivatives/` directory.
