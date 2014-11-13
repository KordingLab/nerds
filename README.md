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

```go
[gen_atom_out, spike_idx, x_hat_out, e_hat_out] = compute_nerds(y, opts)
```

where input has 2 arguments
* `y` is 1-D fluorescent/ calcium signal (either row or column format)
* `opts` is matlab structure contains parameters described in MATLAB code (if not specify, it will assign default parameters)
  * `opts.numTrials` - number of iteration, default `numTrials = 10`
  * `opts.L` - length of template that we want to estimate, default `ask user`
  * `opts.thresh` - thresholding parameter, default `thresh = 0.1` i.e. we thershold spikes whose amplitude less than 10 % from  range of recovered spikes 
  * `opts.wsize` - window size where we apply summation of spikes (`peak_sum`) in order to remove small group of low magnitude splikes output from algorithm
  * `opts.verbose` - verbose parameter for SPGL1, default `verbose = false`

and output has 4 arguments
* `gen_atom_out` is estimated template where each column contains estimated template of each iteration
* `spike_idx` is cell that contain index that spikes occur
* `x_hat_out` is matrix where each column contains estimated spikes train produced in each iteration (we'll fix amplitude problem soon)
* `e_hat_out` is matrix contains DCT coefficient which can transform back to base-line drift in calcium signal

`opts.L` is estimated length of template (called `gen_atom`) where you can estimate the length by the following figure:

<img align="center" src="https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_example.png" width="500px"/>

Example Code
------------

See `example_synth.m` file for an example from the paper where we show that solving Non-Negative Basis Pursuit hold a promising result of estimating . And `example_nerds.m` that we apply NERDS algorithm 
to real data.

For synthetic example, you can follow the code which will produce result graphs as follow. Note that post-processing, we use some thresholding after compute spikes train and summing close peak together:

#### Plot of baseline drift, reconstruct spikes and synthetic data
<img align="center" src="https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_synth_result1.png" width="500px"/>
#### Plot estimated spikes and synthetic data
<img align="center" src="https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerd_synth_result2.png" width="500px"/>
#### Plot result of NERDS applying on real data
<img align="center" src="https://github.com/KordingLab/nerds/blob/master/nerds_figures/nerds_realdata.png" width="500px"/>

Team members
----------
* [Eva Dyer](http://www.ece.rice.edu/~eld1/)
* [Christoph Studer](http://www.csl.cornell.edu/~studer/)
* [Titipat Achakulvisut](http://klab.smpp.northwestern.edu/wiki/index.php5/Titipat_Achakulvisut)

Acknowledgement
----------
* The calcium and electrophysiology data included in `example_real_data.mat` was collected in [Jason MacLean's Lab](http://www.macleanlab.com) at the University of Chicago. Check out [this paper]() for more details regarding the experimental methods utilized to acquire these simultaneous recordings. 
