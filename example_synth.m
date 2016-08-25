function y = example_synth
% function to create synthetic noisy calcium data

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
idx = randi(round(0.8*N), [1, s_A]);
x_A = zeros(N,1);
x_A(idx(1:s_A)) = abs(randn(s_A,1))+0.5;

idx = randperm(10)+5;   % only use low frequencies
x_B = zeros(N,1);
x_B(idx(1:s_B)) = randn(s_B,1)*sqrt(0.5);

% generate synthetic signal
y_A = sqrt(N)*ifft(sqrt(N)*gen_atom_freq.*(1/sqrt(N)*fft(x_A)));
y_B = dct(x_B); % baseline component
noise = randn(N,1)*sqrt(sigma^2);
y = y_A + y_B + noise; % observed calcium signal

% actual spike position
actual_spikes = nan(N,1); 
actual_spikes(find(x_A)) = max(y_A)+0.07;

% Non-negative Basis Pursuit (BP)
x_hat = spg_bp_NN(dict_fun, y, 1:N, opts);
x_hat_A = x_hat(1:N);
x_hat_A(x_hat_A <= 0.1*(max(x_hat_A)-min(x_hat_A))) = 0; % thresholding x_hat_A
x_hat_A = peak_sum(x_hat_A);
recov_spikes = nan(N,1); 
recov_spikes(find(x_hat_A)) = max(y_A)+0.03;

y_E = ifft((gen_atom_freq*sqrt(N)).*(fft(x_hat_A))); % estimate of y_A

% display results
figure(1)
subplot(211)
plot(y, 'Color',[1,0.9,0.5])
hold on
plot(y_A,'--','LineWidth', 2, 'Color',[0,0.45,0.74])
plot(y_B,'-','LineWidth', 2, 'Color',[0.1,0.5,0])
plot(y_E,'--','LineWidth', 2, 'Color',[0.85,0.32,0.1])
axis([0 N -0.2 0.45])
leg_1 = legend('Corrupted signal', 'Original signal','Baseline drift','Recovered signal', ...
               'Location', 'best');
set(leg_1, 'FontSize', 10)
xlabel('Sample index')
ylabel('Amplitude')
hold off
grid on

subplot(212)
plot(y, 'Color',[1,0.9,0.5])
hold on
stem(max(gen_atom)*x_hat_A, 'Color', [0.85,0.32,0.1]) % correct amplitude
plot(actual_spikes, 'x', 'Color', [0,0.45,0.74], 'MarkerSize', 8)
plot(recov_spikes, 'o', 'Color', [0.85,0.32,0.1], 'MarkerSize', 8)
axis([0 N -0.2 0.45])
leg_2 = legend('Original signal','Estimated coefficients', ...
               'Location', 'best');
set(leg_2, 'FontSize', 10)
xlabel('Sample index')
ylabel('Amplitude')
hold off
grid on

end

