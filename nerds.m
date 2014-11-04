function [gen_atom_mat,set_list,x_hat_mat,e_hat_mat] = nerds(y, L, numTrials, thresh, wsize)
% y - input fluorescent signal
% L - approximate length of template (gen_atom)
% numTrials - number of iterations that you want to run
% thresh - thershold measuring from physiological data
% wsize - window size

if nargin<5
    wsize = 10;
end

y = vec(y);         % vectorize signal
y = padding(y, L);  % zero padding to prevent circular shift
N = length(y);

% create initial atom (length L)
gen_atom = exp(-[0:1:N-1]'./(L/4));
gen_atom = gen_atom/norm(gen_atom);         % normalized
gen_atom_freq = 1/sqrt(N)*fft(gen_atom);    % frequency normalized
initial_atom = gen_atom;

gen_atom_mat = zeros(N, numTrials+1);
x_hat_mat = zeros(N, numTrials);
e_hat_mat = zeros(N, numTrials);

gen_atom_mat(:,1) = initial_atom;

for trials = 1:numTrials
    
    opts = spgSetParms('verbosity', true);
    dict_fun = @(x,mode) dict(x, mode, N, gen_atom_freq);
    
    % non-negativity constraint on coefficients
    x_hat = spg_bp_NN(dict_fun,y,1:N,opts);
    x_hat(N-L:N) = 0; % set last L coefficient to zeros
    
    % update dictionary
    [gen_atom, set] = gen_new_atom(y, x_hat, N, L, wsize, thresh);
    
    % all result
    gen_atom_mat(:,trials+1) = gen_atom;
    set_list{trials} = set;
    x_hat_mat(:,trials) = x_hat(1:N);
    e_hat_mat(:,trials) = x_hat(N+1:end);
    fprintf('Number of trials: %d\n', trials);
    
end

end


