function [spike_rate, spike_train] = gen_spike_1d(N, bin_size, alpha)
%generate simple spike trian length N with decay rate alpha
%use glm framework to simulate 1D spike train
%input: N - number of spike that we want to generate
%       bin_size - length of generated binary spike for each rate
%       alpha - decay rate
%output: spike_rate - (N/bin_sizex1) vector
%        spike_train - (Nx1) vector of spike train

if nargin<3
    alpha = 0.8;
end

if nargin<2
    bin_size = 100;
end

spk_len = floor(N/bin_size); % length of spike rate
spike_train = [];

w_vec = zeros(spk_len,1);
w0 = randn(1);
w_vec(1) = w0;
sigma = 1.0; % standard deviation
for i = 2:spk_len
   w_vec(i) = alpha*w_vec(i-1) + sigma*randn(1);
end
spike_rate = poissrnd(exp(w_vec)); % spike poisson rate

n_trial = 1;
for i = 1:length(spike_rate)
    spike_gen = binornd(1, spike_rate(i)/bin_size, bin_size, n_trial);
    spike_train = [spike_train; spike_gen];
end


end

