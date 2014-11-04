function [gen_atom, set] = gen_new_atom(y, x_hat, N, L, wsize, thresh)

if nargin<6
    thresh = 0.5*std(x);
end

if nargin<5
    wsize = 10; % arbitrary assign value to wsize
end

% x = [x_A; x_B] which is spike component and baseline component
x_hat_A = x_hat(1:N);
x_hat_A = peak_sum(x_hat_A, wsize, thresh); % added function to sum peak in some window size
x_hat_B = x_hat(N+1:2*N);
set = find(x_hat_A);

y_E = y - dct(x_hat_B); % subtract approximated baseline

gen_atom = kernelupdate_gamma(y_E, set, x_hat_A, L);
gen_atom = gen_atom./norm(gen_atom);

end