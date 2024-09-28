# Helper functions for MRI analysis

import os
import csv
import json
import numpy as np
import pandas as pd
import nibabel as nib
import nilearn as nl
import datetime

from nilearn import image
from nilearn import plotting
from nilearn.interfaces import fmriprep
from nilearn.image import load_img
from nilearn.signal import clean
from nilearn.image import resample_img
from nilearn.signal import clean
from nilearn.masking import compute_brain_mask

import nilearn.plotting as plotting
import matplotlib.pyplot as plt
from nilearn.plotting import plot_glass_brain

from nilearn import glm



def get_good_runs(data_dir, subject, percent_frames=.30, fwd=.5):
    '''
    input   :  data_dir  - string - path to subject directories
               subject   - string - subject directory
    output  :  good_runs - list   - list of runs with <30% of frames with motion (>=.5 FWD)
    '''
    
    good_runs = []
    
    for r in ['01','02','03','04','05','06']:
        
        # note: not using res-2 <-- lower resolution?
        df      = pd.read_csv(data_dir+subject+'/ses-01/func/'+subject+'_ses-01_task-PredictingAttention_run-'+r+'_desc-confounds_timeseries.tsv', sep="\t")
        percent = df[df['framewise_displacement']>=fwd].shape[0] / df.shape[0]
    
        # if bad motion in less than 30% of frames --> good run
        if percent < percent_frames:
            good_runs.append(r)
    
    return(good_runs)


def get_data(image, mask=False, avg_mask=np.nan, full_output=False):
    '''
    inputs  : mask_type - string - mask_type (options: gm (grey matter), 
                                                    whole-brain, 
                                                    wm (white matter))
              image     - string - path to mri data for a single run
    outputs : masked_data - ???? - brain data with grey matter mask applied
    '''
    
    # Load your fMRI data
    fmri_image = nib.load(image)
    
    if mask == True:
        
        fmri_data = fmri_image.get_fdata()

        resampled_mask_img  = nl.image.resample_to_img(avg_mask, fmri_image, interpolation='nearest')
        resampled_mask_data = resampled_mask_img.get_fdata()

        binary_mask = resampled_mask_data > 0.5 
        binary_mask_img = nl.image.new_img_like(fmri_image, binary_mask.astype(int))

        # Apply the mask to the Niimg object
        masked_fmri_data = nl.masking.apply_mask(fmri_image, binary_mask_img)
        
        #masked_data_4d = masked_fmri_data.reshape(1, 78, 93, 78, 110)
        #masked_img = nib.Nifti1Image(masked_fmri_data, affine=fmri_image.affine)
        
        final_data = masked_fmri_data
    
    else:
        
        final_data = fmri_image.get_fdata()
    
    if full_output:
        
        affine = fmri_image.affine
        header = fmri_image.header
        shape  = final_data.shape
        
        return(final_data, affine, header, shape)
    
    else:
        
        return(final_data)
    
def make_avg_mask(data_dir, sub_dirs):
    '''
    inputs : path to data
             subject direcoty
    outputs: average grey matter mask
    '''

    grey_list      = [nl.image.load_img(data_dir + subject + '/ses-01/anat/' + subject + '_ses-01_space-MNI152NLin2009cAsym_label-GM_probseg.nii.gz' ) for subject in sub_dirs]
    aggregate_mask = nl.image.mean_img(grey_list)
    
    return( aggregate_mask )
    
    
def run_first_level(mask, model, events_dir, data_dir, sub_dirs, events_files, contrast_list):
    
    for events_file, contrast in zip( events_files, contrast_list ):
    
        # for each subject
        for subject in sub_dirs:

            # get runs without excessive motion
            runs = get_good_runs(data_dir, subject)

            # select the images for the good runs
            image_list = [ data_dir+subject+'/ses-01/func/'+subject+'_ses-01_task-PredictingAttention_run-'+x+'_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz' for x in runs ]
            
            # get confounds
            strategy   = [ 'motion','wm_csf','global_signal','compcor','scrub','high_pass' ]
            confounds  = [ nl.interfaces.fmriprep.load_confounds(x, 
                                                                strategy = strategy, 
                                                                fd_threshold=0.5,
                                                                n_compcor = 5,
                                                                motion ='basic',
                                                                demean = False) for x in image_list ]
            confound_list = [x[0] for x in confounds]

            # get sample masks
            sm_list = [x[1] for x in confounds]

            # replace any cases of None with array listing all frames, 0-109
            sm_list = [np.arange(110) if x is None else x for x in sm_list]

            # get data
            full_data = []; affine = []; header = []; shape = []

            for i in image_list:
                f,a,h,s = get_data(i, mask=False, avg_mask=mask, full_output=True) 
                full_data.append(f); affine.append(a); header.append(h); shape.append(s)

            # this is where I formerly did the signal clean (see graveyard)

            # for now, let's set cleaned data equal to the original data
            cleaned_images = full_data #[nib.Nifti1Image(a, affine=None) for a in full_data]

            # load event timings
            event_timing_files = [events_dir+'/'+subject+'_ses-01_task-PredictingAttention_run-'+r+'_'+events_file for r in runs]

            event_dfs = [ pd.read_table(x) for x in event_timing_files ]

            new_event_list = []

            if 'button' in events_file:
                print('for ' + events_file + ', changing duration to .01 seconds')
                for x in event_dfs:
                    x['duration'] = .01
                    new_event_list.append(x)

            # make design matrices
            design_matrices = []

            for e,c in zip(new_event_list, confound_list):

                TR_array   = np.array([x*2 for x in np.arange(110)])
                matrix = glm.first_level.make_first_level_design_matrix(TR_array, 
                                                                        e, 
                                                                        hrf_model='glover', 
                                                                        drift_model=None,
                                                                        add_regs = c)
                design_matrices.append(matrix)
                print('ready to fit the model')
                
            #print(cleaned_images)

            # fit the model
            fitted_model = model.fit(cleaned_images, 
                                     confounds       = confound_list, 
                                     design_matrices = design_matrices,
                                     events          = new_event_list,
                                     sample_masks    = sm_list) 

            print('ready to compute contrasts')
            # plot the result
            z_score  = fitted_model.compute_contrast(contrast, output_type='z_score')
            eff_size = fitted_model.compute_contrast(contrast, output_type='effect_size')
            # NOTE: we'll use z_score for visualizing and effect_size for second-level GLM
            print('contrasts computed')
            
            # make folder path
            path_base = 'first_level_GLM' 
            directory_path = path_base 

            print('directory path created')
            
            # make folder for this batch, if it doesn't exist
            if not os.path.exists(directory_path):
                os.makedirs(directory_path)
                print("Directory created:", directory_path)
            else:
                print("Directory already exists:", directory_path)

            # contrast for filename
            contrast_label = contrast.replace(' ','-')
            
            # timing label
            now   = datetime.datetime.now()
            ctime = now.ctime()
            date_time = ctime.replace(' ','-')
                
            # save contrasts
            z_score.to_filename(directory_path + '/' + contrast_label + '_' + date_time + '_' + str(subject) + '_z-score.nii.gz')
            eff_size.to_filename(directory_path + '/' + contrast_label + '_' + date_time + '_' + str(subject) + '_eff-size.nii.gz')

            print('contrasts saved out')
    
    
    
    ############################## GRAVEYARD ##############################
    
    
    
    ############################# Signal clean #############################
    
        # clean the signal in masked data
        # signal_data  = [ x.get_fdata() for x in full_data ] 

        # clean the data
        # USE THIS FOR HIGH-PASS AND LOW PASS

        # Might not need signal clean -- GLM does high pass automatically

        #                             -- might not need low pass because we have a task (not resting state)

    #     cleaned_data   = [ nl.signal.clean(x, detrend=False, #standardize='zscore_sample', 
    #                      sample_mask=None, filter='butterworth', low_pass=.25, high_pass=.001, 
    #                      t_r=2.0, ensure_finite=False ) for x in signal_data ]

        # convert cleaned data back to image files

    #     cleaned_images = []

    #     for i, a, h in zip(cleaned_data, affine, header):
    #         cleaned_images.append(nib.Nifti1Image(i, a, h))
    
    
    
    ############################### Plot first-level GLM outputs ###############################
    
    #     plot_glass_brain(button_beta, colorbar=True, threshold=2, title='single subject button',
    #                 plot_abs=False)

    #     # Get the Matplotlib figure object
    #     fig = plt.gcf()

    #     # Save the figure as a PDF
    #     save_string = 'button_glm/combo_button/figs/sub_'+str(subject)+'_combined_button_ALL.pdf'
    #     fig.savefig(save_string)
    
    
    ################################ Maks MRI data #################################
    
    #         if len(mask_img)==0:
            
#             # Generate the mask
#             grey_matter_mask = compute_brain_mask(fmri_img, mask_type=mask_type)

#             # "This mask is calculated using MNI152 1mm-resolution template mask onto the target image."
#             # https://nilearn.github.io/stable/modules/generated/nilearn.masking.compute_brain_mask.html

#             # Extract data from both images
#             # fmri_data = fmri_img.get_fdata(); mask_data = grey_matter_mask.get_fdata().astype(bool)

#             # Apply the mask, preserving spatial dimensions
#             masked_fmri_data = nl.masking.apply_mask(fmri_img, grey_matter_mask)

#             # Create nifti image 
#             masked_fmri_image = nib.Nifti1Image(masked_fmri_data, fmri_img.affine, fmri_img.header)

#             final_data = masked_fmri_image

#             # shape  = fmri_img.shape
#             shape  = masked_fmri_data.shape
            
#         elif len(mask_img)>0:
#             im_dat   = nib.load(image).get_fdata()
#             mask_dat = nib.load(mask_img).get_fdata()
            
#             mask_dat = np.expand_dims(mask_dat, axis=-1)
#             print(mask_dat)
            
#             masked_data = im_dat * mask_dat
            
#             final_data = masked_data
#             print(final_data)
            
#             # shape  = fmri_img.shape
#             shape  = masked_data.shape
              
              
              
              
              ############################# Get Data #############################
              
#               def get_data(image, mask=False, mask_img='', mask_type="gm", full_output=False):
#     '''
#     inputs  : mask_type - string - mask_type (options: gm (grey matter), 
#                                                     whole-brain, 
#                                                     wm (white matter))
#               image     - string - path to mri data for a single run
#     outputs : masked_data - ???? - brain data with grey matter mask applied
#     '''
    
#     # Load your fMRI data
#     fmri_img = nib.load(image)
    
#     if mask == True:
        
#         print('Mask functionality removed from get_data

    
#     if full_output:
        
#         return(final_data, affine, header, shape)
    
#     else:
        
#         return(final_data)
    