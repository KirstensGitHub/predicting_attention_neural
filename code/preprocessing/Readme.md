## Preprocessing MRI data

These scripts show the steps taken to preprocess the MRI data for analysis. We provide the preprocessed data publicly [here](https://www.dropbox.com/scl/fo/6wzepx3baxel0f4n62k3s/AP4xny1B7vN7hXr6pBclmw8?rlkey=2kr2y9ba748lhhsu35avv51e2&st=fhbupdc6&dl=0). Our preprocessing pipeline is based on the guidelines and code provided in the [Pygers workshop](https://brainhack-princeton.github.io/handbook/content_pages/pygers_workshops/syllabus2020.html). 

Data was preprocessed by running the steps in step1_preproc and step2_preproc, followed by fMRIprep. You may also use MRIQC for quality assurance. We ran fMRIprep on a computing cluster, submitting it using SLURM (e.g. via `slurm_fmriprep.sh`). So, a standard sequence of scripts would be:
  - `step1_preproc.sh`
  - `step2_preproc.sh`
  - `slurm_mriqc.sh` 
  - `slurm_fmriprep.sh` 
    * note: minor alterations were made to these scripts in the case of two subjects who had data from extra runs (subjects 1 and 12 who, for processing purposes were each treated as two unique subjects - 101 & 201, and 112 & 212, respectively).
   
NOTE: Comporting with the steps outlined in the Pygers documentation, some of our preprocessing and analysis steps were carried out in a module on a Princeton computing cluster called `pyger/0.11.0`. The contents of that module are listed below.

--------------------------

### packages in environment at /jukebox/pkgs/PYGER/base/envs/0.11.0:

### Name,                    Version,                   Build,  Channel
_libgcc_mutex             0.1                 conda_forge    conda-forge
_openmp_mutex             4.5                       1_gnu    conda-forge
argh                      0.26.2                   py37_0  
argon2-cffi               20.1.0           py37h7b6447c_1  
async_generator           1.10             py37h28b3542_0  
attrs                     20.3.0             pyhd3eb1b0_0  
backcall                  0.2.0                      py_0  
binutils_impl_linux-64    2.31.1               h6176602_1  
binutils_linux-64         2.31.1               h6176602_9  
blas                      1.0                         mkl  
bleach                    3.2.1                      py_0  
blosc                     1.20.1               hd408876_0  
brainiak                  0.11                     pypi_0    pypi
brainiak_tutorials        0.3                           0    pni
brotlipy                  0.7.0           py37h27cfd23_1003  
bzip2                     1.0.8                h7b6447c_0  
ca-certificates           2021.1.19            h06a4308_1  
certifi                   2020.12.5        py37h06a4308_0  
cffi                      1.14.4           py37h261ae71_0  
chardet                   4.0.0           py37h06a4308_1003  
cryptography              3.3.1            py37h3c74f83_0  
cycler                    0.10.0                   py37_0  
cython                    0.29.21          py37h2531618_0  
dbus                      1.13.18              hb2f20db_0  
decorator                 4.4.2                      py_0  
deepdish                  0.3.6              pyh9f0ad1d_0    conda-forge
defusedxml                0.6.0                      py_0  
entrypoints               0.3                      py37_0  
expat                     2.2.10               he6710b0_2  
fontconfig                2.13.0               h9420a91_0  
freetype                  2.10.4               h5ab3b9f_0  
gcc_impl_linux-64         7.3.0                habb00fd_1  
gcc_linux-64              7.3.0                h553295d_9  
glib                      2.66.1               h92f7085_0  
gst-plugins-base          1.14.0               h8213a91_2  
gstreamer                 1.14.0               h28cd5cc_2  
gxx_impl_linux-64         7.3.0                hdf63c60_1  
gxx_linux-64              7.3.0                h553295d_9  
h5py                      2.10.0           py37hd6299e0_1  
hdf5                      1.10.6               hb1b8bf9_0  
icu                       58.2                 he6710b0_3  
idna                      2.10                       py_0  
importlib-metadata        2.0.0                      py_1  
importlib_metadata        2.0.0                         1  
intel-openmp              2020.2                      254  
ipykernel                 5.3.4            py37h5ca1d4c_0  
ipython                   7.21.0           py37h888b3d9_0    conda-forge
ipython_genutils          0.2.0              pyhd3eb1b0_1  
ipywidgets                7.6.3              pyhd3eb1b0_1  
jedi                      0.18.0           py37h89c1867_2    conda-forge
jinja2                    2.11.2                     py_0  
joblib                    1.0.0              pyhd3eb1b0_0  
jpeg                      9b                   h024ee3a_2  
jsonschema                3.2.0                      py_2  
jupyter                   1.0.0                    py37_7  
jupyter_client            6.1.7                      py_0  
jupyter_console           6.2.0                      py_0  
jupyter_core              4.7.0            py37h06a4308_0  
jupyterlab_pygments       0.1.2                      py_0  
jupyterlab_widgets        1.0.0              pyhd3eb1b0_1  
kiwisolver                1.3.0            py37h2531618_0  
lcms2                     2.11                 h396b838_0  
ld_impl_linux-64          2.33.1               h53a641e_7  
libedit                   3.1.20191231         h14c3975_1  
libffi                    3.3                  he6710b0_2  
libgcc-ng                 9.3.0               h2828fa1_18    conda-forge
libgfortran-ng            7.3.0                hdf63c60_0  
libgomp                   9.3.0               h2828fa1_18    conda-forge
libgpuarray               0.7.6                h14c3975_0  
libpng                    1.6.37               hbc83047_0  
libsodium                 1.0.18               h7b6447c_0  
libstdcxx-ng              9.1.0                hdf63c60_0  
libtiff                   4.1.0                h2733197_1  
libuuid                   1.0.3                h1bed415_2  
libxcb                    1.14                 h7b6447c_0  
libxml2                   2.9.10               hb55368b_3  
llvm-openmp               8.0.1                hc9558a2_0    conda-forge
lz4-c                     1.9.2                heb0550a_3  
lzo                       2.10                 h7b6447c_2  
mako                      1.1.4              pyhd3eb1b0_0  
markupsafe                1.1.1            py37h14c3975_1  
matplotlib                3.3.2                h06a4308_0  
matplotlib-base           3.3.2            py37h817c723_0  
mistune                   0.8.4           py37h14c3975_1001  
mkl                       2020.2                      256  
mkl-service               2.3.0            py37he8ac12f_0  
mkl_fft                   1.2.0            py37h23d657b_0  
mkl_random                1.1.1            py37h0573a6f_0  
mock                      4.0.3              pyhd3eb1b0_0  
more-itertools            8.6.0              pyhd3eb1b0_0  
mpi                       1.0                       mpich  
mpi4py                    3.0.3            py37hf046da1_1  
mpich                     3.3.2                hc856adb_0  
nbclient                  0.5.1                      py_0  
nbconvert                 6.0.7                    py37_0  
nbformat                  5.1.1              pyhd3eb1b0_1  
ncurses                   6.2                  he6710b0_1  
nest-asyncio              1.4.3              pyhd3eb1b0_0  
networkx                  2.5                        py_0  
nibabel                   3.2.1              pyhd8ed1ab_0    conda-forge
nilearn                   0.7.1              pyhd8ed1ab_0    conda-forge
nitime                    0.9              py37h902c9e0_2    conda-forge
notebook                  6.1.6            py37h06a4308_0  
numexpr                   2.7.2            py37hb2eb853_0  
numpy                     1.19.2           py37h54aff64_0  
numpy-base                1.19.2           py37hfa32c7d_0  
nxviz                     0.6.2            py37h89c1867_2    conda-forge
olefile                   0.46                     py37_0  
openmp                    8.0.1                         0    conda-forge
openssl                   1.1.1j               h27cfd23_0  
packaging                 20.8               pyhd3eb1b0_0  
palettable                3.3.0                      py_0  
pandas                    1.2.0            py37ha9443f7_0  
pandoc                    2.11                 hb0f4dca_0  
pandocfilters             1.4.3            py37h06a4308_1  
parso                     0.8.1              pyhd3eb1b0_0  
pathtools                 0.1.2                      py_1  
patsy                     0.5.1                    py37_0  
pcre                      8.44                 he6710b0_0  
pexpect                   4.8.0              pyhd3eb1b0_3  
pickleshare               0.7.5           pyhd3eb1b0_1003  
pillow                    8.1.0            py37he98fc37_0  
pip                       20.3.3           py37h06a4308_0  
prometheus_client         0.9.0              pyhd3eb1b0_0  
prompt-toolkit            3.0.8                      py_0  
prompt_toolkit            3.0.8                         0  
psutil                    5.7.2            py37h7b6447c_0  
ptyprocess                0.7.0              pyhd3eb1b0_2  
pybind11                  2.5.0            py37hfd86e86_0  
pycparser                 2.20                       py_2  
pydicom                   2.1.2              pyhd3deb0d_0    conda-forge
pygments                  2.7.4              pyhd3eb1b0_0  
pygpu                     0.7.6            py37heb32a55_0  
pyopenssl                 20.0.1             pyhd3eb1b0_1  
pyparsing                 2.4.7                      py_0  
pyqt                      5.9.2            py37h05f1152_2  
pyrsistent                0.17.3           py37h7b6447c_0  
pysocks                   1.7.1                    py37_1  
pytables                  3.6.1            py37he17a9a8_3    conda-forge
python                    3.7.9                h7579374_0  
python-dateutil           2.8.1                      py_0  
python_abi                3.7                     1_cp37m    conda-forge
pytz                      2020.5             pyhd3eb1b0_0  
pyyaml                    5.3.1            py37h7b6447c_1  
pyzmq                     20.0.0           py37h2531618_1  
qt                        5.9.7                h5867ecd_1  
qtconsole                 4.7.7                      py_0  
qtpy                      1.9.0                      py_0  
readline                  8.0                  h7b6447c_0  
requests                  2.25.1             pyhd3eb1b0_0  
scikit-learn              0.23.2           py37h0573a6f_0  
scipy                     1.5.2            py37h0b6359f_0  
seaborn                   0.11.1             pyhd3eb1b0_0  
send2trash                1.5.0              pyhd3eb1b0_1  
setuptools                51.1.2           py37h06a4308_4  
sip                       4.19.8           py37hf484d3e_0  
six                       1.15.0           py37h06a4308_0  
sqlite                    3.33.0               h62c20be_0  
statsmodels               0.12.1           py37h27cfd23_0  
terminado                 0.9.2            py37h06a4308_0  
testpath                  0.4.4                      py_0  
theano                    1.0.4            py37hfd86e86_0  
threadpoolctl             2.1.0              pyh5ca1d4c_0  
tk                        8.6.10               hbc83047_0  
tornado                   6.1              py37h27cfd23_0  
traitlets                 5.0.5                      py_0  
urllib3                   1.26.2             pyhd3eb1b0_0  
watchdog                  0.10.4           py37h06a4308_0  
wcwidth                   0.2.5                      py_0  
webencodings              0.5.1                    py37_1  
wheel                     0.36.2             pyhd3eb1b0_0  
widgetsnbextension        3.5.1                    py37_0  
xz                        5.2.5                h7b6447c_0  
yaml                      0.2.5                h7b6447c_0  
zeromq                    4.3.3                he6710b0_3  
zipp                      3.4.0              pyhd3eb1b0_0  
zlib                      1.2.11               h7b6447c_3  
zstd                      1.4.5                h9ceee32_0  
