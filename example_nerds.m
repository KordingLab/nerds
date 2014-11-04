%% EXAMPLE
% example of nerds on real data
% 
% ephys - single cell recording assuming that it has more sampling rate
% flo - fluorescent signal from Calcium imaging
load('example_data')
peak_counts = count_peaks(ephys, flo); % assume

%%
N = length(flo);
L = 70;         % length of template
thresh = 0.3;   % threshold 
iter = 5;       % number of iteration
wsize = 12;     % window size

[gen_atom_mat,set_list,x_hat_mat,e_hat_mat] = nerds(flo, L, iter, thresh, wsize);

%%
mode = 1;
gen_atom_freq = 1/sqrt(N)*fft(gen_atom_mat(:,end));
flo_conv = dumb_dict(x_hat_mat(:,end), mode, N, gen_atom_freq);

plot(flo)
hold on
stem(x_hat_mat(:,end))
plot(flo_conv)



