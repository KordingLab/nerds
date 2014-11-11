%% example file to apply different metrics (just skeleton code first)
load('example_data')
flo = flo - min(flo);
peak_counts = count_peaks(ephys, flo);

%% NERDS
N = length(flo);
L = 70;         % length of template approximate from fluorescent signal
thresh = 0.1;   % thresholding parameter, plot x_hat_mat to estimate threshold
iter = 5;       % number of iteration
wsize = 12;     % window size
[gen_atom_mat,set_list,x_hat_mat,e_hat_mat] = compute_nerds(flo, L, iter, thresh, wsize);

%% FAST-OOPSI
[n_best P_best V C]=fast_oopsi(flo); % n_best is spike train

%%
d_nerds = metric_spkd(x_hat_mat(1:end-1,5), peak_counts, 0.1);
d_oopsi = metric_spkd(n_best, peak_counts, 0.1);
