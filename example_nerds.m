%% EXAMPLE
% example of nerds on real data: example_data.mat
% 
% ephys - single cell recording assuming that it has more sampling rate
% flo - 1D fluorescent signal from Calcium imaging
load('example_real_data')
flo = flo - min(flo);
N = length(flo);
% or flo = rescale(flo); will adjust signal to range 0 to 1
<<<<<<< HEAD
peak_counts = count_peaks(ephys, flo);
N = length(flo);
actual_spikes = nan(N,1); 
=======
peak_counts = peak_count(ephys, flo);
actual_spikes = nan(N,1);
>>>>>>> 23775270f94052cb1267dff1ef1e45a97d302f94
actual_spikes(find(peak_counts)) = 1.05*max(flo);

%% Run compute_nerds
% - if we plot fluorescent data, we can see that length of each peak has
%   length (index) around 70
%
opts.L = 70;         % length of template approximate from fluorescent signal
opts.thresh = 0.2;   % thresholding parameter, plot x_hat_mat to estimate threshold
opts.numTrials = 5;  % number of iteration
opts.wsize = 12;     % window size
[gen_atom_mat, spike_idx, x_hat_mat, e_hat_mat] = compute_nerds(flo, opts);

%% Plot result
% recovered fluorescent signal from spike and template
mode = 1;
gen_atom_freq = 1/sqrt(N)*fft(gen_atom_mat(:,end));
flo_conv = dumb_dict(x_hat_mat(:,end), mode, N, gen_atom_freq);
%equivalent to flo_conv = ifft(fft(gen_atom_mat(:,end))*fft(x_hat_mat(:,end)))

figure(2)
plot(flo, 'Color',[1,0.9,0.5])
hold on
plot(actual_spikes, 'x', 'Color', [0,0.45,0.74], 'MarkerSize', 8)
stem(x_hat_mat(:,end)*max(gen_atom_mat(:,end)), 'Color', [0.85,0.32,0.1])
plot(flo_conv, 'Color',[0.1,0.5,0])
xlabel('Time index')
ylabel('Amplitude')
title('Example of NERDS on fluorescent data')
legend('Fluorescent signal',...
       'Ground truth ephys',...
       'Recovered spikes', ...
       'Convolved spikes with template', ...
       'Location', 'best')
axis([0 N 0 1.2*max(flo)])
