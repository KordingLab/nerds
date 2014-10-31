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
* [SPGL1](https://www.math.ucdavis.edu/~mpf/spgl1/) (Solver for large-scale sparse reconstruction) see also git [link](https://github.com/mpf/spgl1) and adjusted SPGL1 (note that we include SPGL1 and extra code in our repo)


Usage
---------
To setup SPGL1 package, change directory to the downloaded SPGL1 folder then type following line in Matlab shell.

`spgsetup`

In order to download NERDS folder, either download zip file from git repository directly or use git to clone 
repository to particular directory that we want

`git clone https://github.com/KordingLab/nerds`

After that, run `setup_nerds.m` code in order to include path and setup SPGL1 tool.


Example Code
---------



Team members
----------
* Eva Dyer
* Christoph Studer
* Titipat Achakulvisut
