function [gen_atom_mat,spike_idx,x_hat_mat,e_hat_mat] = compute_nerds(y, opts)
%COMPUTE_NERDS
%
%input  y - input 1-D fluorescent signal (element should be all positive)
%       opts.L - approximate length of template (gen_atom)
%       opts.numTrials - number of iterations that you want to run
%       opts.thresh - thershold parameter to suppress outlier spikes
%       opts.wsize - window size to sum close spikes together in window size
%       opts.verbose - true/false 
%
%output gen_atom_mat - all learned template from trial one to numTrials
%       spike_idx - set of spike occurence index
%       x_hat_mat - learned spike
%       e_hat_mat - learned DCT coefficients (baseline drift)

if nargin < 2
    opts = struct;
end

if ~isfield(opts, 'L')
    L = input('\nwhat is the approximated length?: ');
    opts.L = 100;
end
if ~isfield(opts, 'numTrials')  opts.numTrials = 10;    end
if ~isfield(opts, 'thresh')     opts.thresh = 0.1;      end
if ~isfield(opts, 'wsize')      opts.wsize = 10;        end
if ~isfield(opts, 'verbose')    opts.verbose = false;   end

% get some variable that use frequently
L = opts.L;
wsize = opts.wsize;
thresh = opts.thresh;

% vectorize and padding input
y = vec(y);         % vectorize input signal
y = y - min(y);     % shift to get positive signal
y = padding(y, opts.L);  % zero padding to prevent circular shift
N = length(y);      % length of input signal (with padding)

% create initial atom/template (length L)
gen_atom = exp(-[0:1:N-1]'./(L/4));
gen_atom = gen_atom/norm(gen_atom);         % normalized
gen_atom_freq = 1/sqrt(N)*fft(gen_atom);    % frequency normalized
initial_atom = gen_atom;

gen_atom_mat = zeros(N-L, opts.numTrials+1);
gen_atom_mat(:,1) = initial_atom(1:N-L);

x_hat_mat = zeros(N-L, opts.numTrials);
e_hat_mat = zeros(N, opts.numTrials);


for trials = 1:opts.numTrials
    
    opts_spg = spgSetParms('verbosity', opts.verbose);
    dict_fun = @(x,mode) dict(x, mode, N, gen_atom_freq);
    
    % non-negativity constraint on coefficients
    x_hat = spg_bp_NN(dict_fun,y,1:N,opts_spg);
    x_hat(N-L:N) = 0; % set last L coefficient to zeros
    
    % update dictionary
    [gen_atom, spk_idx] = gen_new_atom(y, x_hat, N, L, wsize, thresh);
    
    % all result
    gen_atom_mat(:, trials+1) = gen_atom(1:N-L);
    x_hat_mat(:,trials) = x_hat(1:N-L);
    e_hat_mat(:,trials) = x_hat(N+1:end);
    
    spike_idx{trials} = spk_idx;
    fprintf('Number of trials: %d\n', trials);
    
    % stopping criteria if template converge
    if norm(gen_atom_mat(:,trials+1)-gen_atom_mat(:,trials))<1e-8
        return;
    end
    
end

end


