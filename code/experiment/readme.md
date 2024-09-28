### Running the experiment

First, unzip the stimulus folder (fps_60). Then, to run the experiment, open and run `experiment_run.psyexp` or `experiment_run.py` in Psychopy version 2023.1.2

Note that, reviewing our code and experiment data, we explored the impact of adjusting some psychopy code settings on the timing of stimulus presentation, primarily for video stimulus display. The code here is intended to represent the original state of the experiment at the time of data collection, but we encourage users to tweak timing and display settings as needed to suit their design and equipment (external monitors, MRI set up, etc)

### Stimulus generation

The stimuli were generating following the same general approach as in [our previous behavioral study](https://www.pnas.org/doi/abs/10.1073/pnas.2307584120) for creating veridical and scrambled attention videos (code [here](https://github.com/KirstensGitHub/predicting_attention)), but in this stimulus set we specifically selected for stimuli with 13 or more attention hotspots. We were also more selective about pruning out stimuli with undesirable features for this study (excluding based on visual noise in the video, any distracting textual elements in the background image, etc.). 
