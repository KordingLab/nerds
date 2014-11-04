function y = example_synth
% function to create synthetic noisy calcium data
% this is example from Eva IEEE paper

randn('seed', 0);
rand('seed', 0);

N = 4096;
s_A = 10;   % number of spikes
s_B = 5;    % number of sine wave
decay = 0.01;
sigma = sqrt(0.001);

% create generating atom/template
gen_atom = zeros(N,1);
gen_atom = exp(-decay*[0:1:N-1]');
gen_atom = gen_atom/norm(gen_atom);         % normalized template
gen_atom_freq = 1/sqrt(N)*fft(gen_atom);    % frequency normalized


opts = spgSetParms('verbosity',false);
dict_fun = @(x,mode) dict(x, mode, N, gen_atom_freq);
dumb_dict_fun = @(x,mode) dumb_dict(x, mode, N, gen_atom_freq);

% generate sparse vectors x_A and x_B
idx = randperm(N);
x_A = zeros(N,1);
x_A(idx(1:s_A)) = abs(randn(s_A,1))  ;

idx = randperm(10)+5;   % only use low frequencies
x_B = zeros(N,1);
x_B(idx(1:s_B)) = randn(s_B,1)*sqrt(0.5);

% generate signal
y_A = sqrt(N)*ifft(sqrt(N)*gen_atom_freq.*(1/sqrt(N)*fft(x_A)));
y_B = dct(x_B);
noise = randn(N,1)*sqrt(sigma^2);
y = y_A + y_B + noise;


% BPDN-based absorption
x_hat = spg_bp(dict_fun, y,opts);
x_hat_A = x_hat(1:N);
y_E = ifft((gen_atom_freq*sqrt(N)).*(fft(x_hat_A))); % signal estimate


% display results
figure(1)
plot(y_A,'r--','LineWidth',2)
hold on
plot(y)
plot(y_B,'g-','LineWidth',1)
plot(y_E,'m--','LineWidth',2)
axis([0 N -0.15 0.35])
legend('original signal','corrupted signal','baseline drift','recovered signal{}')
xlabel('sample index')
ylabel('amplitude')
hold off
grid on

end

