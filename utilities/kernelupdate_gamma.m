function gen_atom = kernelupdate_gamma(y_E,set,x2,L)
% y_E: calcium imaging intensity signal
% set: non-zero indices
% x2: coefficient signal which has length equals to N
% L: length of template

N = length(x2);
notset = setdiff(1:N,set); % find different of two sets
N = length(y_E);
x2(notset) = 0; % learn kernel from the main spikes only!

y_E_fft = 1/sqrt(N)*fft(y_E);
x_hat_A_fft = 1/sqrt(N)*fft(x2);

LSdict_fun = @(x,mode) LSdict(x, mode, N, x_hat_A_fft);
maxSVD = max(abs(x_hat_A_fft));

Omega = L:N;
[x_out, ~] = constrained_LS(LSdict_fun,y_E_fft,N,Omega,maxSVD,100,1e-6);

x_new = est_gam_dist(x_out, L);

x_new = x_new./norm(x_new);

gen_atom = [x_new; zeros(N-length(x_new),1)];

end

