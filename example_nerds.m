%% EXAMPLE
% example of nerds on real data: example_data.mat
% 
% ephys - single cell recording assuming that it has more sampling rate
% flo - 1D fluorescent signal from Calcium imaging
load('example_data')
flo = flo - min(flo);
% or flo = rescale(flo); will adjust signal to range 0 to 1
peak_counts = count_peaks(ephys, flo);

%% Run compute_nerds
% - if we plot fluorescent data, we can see that length of each peak has
%   length (index) around 70
%
N = length(flo);
L = 70;         % length of template approximate from fluorescent signal
thresh = 0.1;   % thresholding parameter, plot x_hat_mat to estimate threshold
iter = 5;       % number of iteration
wsize = 12;     % window size
[gen_atom_mat,set_list,x_hat_mat,e_hat_mat] = compute_nerds(flo, L, iter, thresh, wsize);

%% Plot result
% convolve signal back
mode = 1;
gen_atom_freq = 1/sqrt(N)*fft(gen_atom_mat(:,end));
flo_conv = dumb_dict(x_hat_mat(:,end), mode, N, gen_atom_freq);
%equivalent to flo_conv = ifft(fft(gen_atom_mat(:,end))*fft(x_hat_mat(:,end)))

plot(flo)
hold on
stem(x_hat_mat(:,end))
plot(flo_conv)
xlabel('time index')
ylabel('Amplitude')
title('Example of NERDS on fluorescent data')
legend('fluorescent signal', 'recovered spike', ...
       'convolved spike with template')