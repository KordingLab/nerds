NERDS
---------
**Neural Event Reconstruction and Detection via Sparsity**

Related Publication
---------
* [Dyer, E.L.; Studer, C.; Robinson, J.T.; Baraniuk, R.G., "A robust and efficient method to recover neural events from noisy and corrupted data," Neural Engineering (NER), 6th International IEEE/EMBS Conference, pp.593-596, 2013] (http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=6696004)

Description
---------
Matlab package implementing blind deconvolution method for neural spike recovery from calcium signal

Requirements
---------
* Matlab version >= 2007
* [SPGL1](https://www.math.ucdavis.edu/~mpf/spgl1/) (Solver for large-scale sparse reconstruction) see also git [link](https://github.com/mpf/spgl1) and adjusted SPGL1 (note that we have already included SPGL1 and extra SPGL1 code in NERDS project)

Installation
---------

In order to download NERDS folder, either download `zip file` from git repository directly or use `git` to clone 
repository to particular directory that we want

`git clone https://github.com/KordingLab/nerds`

After that, hover to the folder and run `setup_nerds.m` code in order to include path and setup SPGL1 package (don't worry if you cannot compile `mex` in SPGL1). Note that, in `setup_nerds` file, we included path in nerds folder and run setup file from SPGL1 package.

Usage
---------
You can run NERDS algorithm by using the function `compute_nerds` in main folder

`[gen_atom_mat,spike_idx,x_hat_mat,e_hat_mat] = compute_nerds(y, opts)`

where input has 2 arguments
* `y` is 1-D fluorescent/ calcium signal (either row or column format)
* `opts` is matlab structure contains parameters described in MATLAB code

and output has 4 arguments
* `gen_atom_mat` is estimated template where each column contains estimated template of each iteration
* `spike_idx` is cell that contain index that spikes occur
* `x_hat_mat` is matrix where each column contains estimated spikes train produced in each iteration (we'll fix amplitude problem soon)
* `e_hat_mat` is matrix contains DCT coefficient which can transform back to base-line drift in calcium signal

`opts.L` is estimated length of template (called `gen_atom`) where you can estimate the length by the following figure:
![Alt text](https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_example.png "NERDS paper result")

Example Code
---------

See `example_synth.m` file for an example from the paper and `example_nerds.m` that we apply NERDS algorithm 
to real data.

For synthetic example, you can follow the code which will produce result graphs as follow. Note that post-processing, we use some thresholding after compute spikes train and summing close peak together:

#### Plot of baseline drift, reconstruct spikes and synthetic data
![Alt text](https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_synth_result1.png "NERDS paper result")
#### Plot estimated spikes and synthetic data
![Alt text](https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_synth_result2.png "NERDS Spike train")
#### Revenge of Calcium Signal with Dubstep (by Christoph)
![Alt text](https://github.com/KordingLab/nerds/blob/master/nerds_figures/calcium.gif)

Team members
----------
* Eva Dyer
* Christoph Studer
* Titipat Achakulvisut
