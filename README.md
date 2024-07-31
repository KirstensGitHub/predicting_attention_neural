## Replicating code for "Modeling the attention of others activates social regions in the brain"

Welcome! To prepare our data for your own replication and analysis, you'll need to:
- download and preprocess the MRI data
- preprocess the behavioral data

### Dependencies

<mark>TODO</mark>

### Preprocessing MRI data

First, download the MRI data for this experiment from <mark>LINK HERE</mark>.

1. Edit `code/preprocessing/globals.sh` so that:
  - The `scanner_dir` path points to wherever you've saved the MRI data.
  - The `project_dir` points to the root of this repository.
  - The `scratch_dir` points to the `data/work` directory.
2. Put your FreeSurfer [license](https://surfer.nmr.mgh.harvard.edu/fswiki/License) in `code/preprocessing`.
3. `cd` into `code/preprocessing` and run:
  - `step1_preproc_batch.sh`
  - `step2_preproc_batch.sh`
  - `step2_fix_scan_tsvs.sh`
  - `step2_fix_event_tsvs.sh`
4. From the root of this repository, run `bids-validator data/bids --verbose |& tee code/preprocessing/logs/bids-validation.txt` using the [bids-validator](https://www.npmjs.com/package/bids-validator) NodeJS package. If any errors arise, stop and fix them before continuing.
5. `cd` back into `code/preprocessing`. For `mriqc` and `fmriprep`, you will have to decide if you are going to use `slurm` to handle these as batch jobs (recommended) or run the scripts manually.
  - Using `slurm`:
    - If you are on Princeton's Scotty computer cluster or a similar cluster in which your slurm nodes do not have internet access, each user will have to run `run_mriqc.sh` for a subject once *without* using slurm, to allow the program to download the necessary TemplateFlow files. You can do that by running `./run_mriqc.sh [3-digit subject code]` (eg. `./run_mriqc.sh 013`) for any subject besides 1 and 12, before proceeding to the slurm commands below.
    - Edit the `slurm_mriqc.sh` and `slurm_fmriprep.sh` files with your email & specific job details for your cluster.
    - Run `sbatch slurm_mriqc.sh`.
    - Run `sbatch slurm_fmriprep.sh`.
  - Manual: run
    - `run_mriqc_group.sh`
    - `run_fmriprep.sh` for all subjects in the study (eg. `./run_fmriprep.sh 013` for subject 13). Note that subjects 1 and 12, because their data collection was split into multiple parts, comprise 4 subject IDs: `101`, `201`, `112`, and `212`.
  - <mark>TODO: right now these scripts, slurm or otherwise, depend on the specific filepaths & `singularity` command of PNI. Work to make this system-agnostic!</mark>

After the steps above are completed, all the MRI data should be nicely organized in the `data` folder. Error logs can be found in the `code/preprocessing/logs` folder. You can investigate the mriqc and fmriprep outputs in their respective folders within the `data/bids/derivatives/` directory.


<mark>TODO: these scripts </mark>
