function [gen_atom_out, spike_idx, x_hat_out, e_hat_out] = compute_nerds(y, opts)
%COMPUTE_NERDS
%
%input  y - input 1-D fluorescent signal (element should be all positive, with no NaNs)
%       opts - Structure defining options (all are optional)
%           opts.L - approximate length of template (gen_atom)
%           opts.template0 - initial template estimate
%           opts.numTrials - number of iterations that you want to run
%           opts.thresh - thershold parameter to suppress outlier spikes
%           opts.wsize - window size to sum close spikes together in window size
%           opts.verbose - true/false: Set verbosity of solver
%
%output gen_atom_mat - all learned template from trial one to numTrials
%       spike_idx - set of spike occurence index
%       x_hat_mat - learned spike
%       e_hat_mat - learned DCT coefficients (baseline drift)

if nargin < 2
    opts = struct;
end

if ~isfield(opts, 'numTrials')  opts.numTrials = 10;    end
if ~isfield(opts, 'thresh')     opts.thresh = 0.1;      end
if ~isfield(opts, 'wsize')      opts.wsize = 10;        end
if ~isfield(opts, 'verbose')    opts.verbose = false;   end

if ~isfield(opts, 'L')
   if isfield(opts, 'template0')
      opts.L = numel(opts.template0);
   else
      opts.L = input('\nwhat is the approximated length of template?: ');
   end
end

% get some variable that use frequently
L = opts.L;
wsize = opts.wsize;
thresh = opts.thresh;

% - Check input vector for NaNs
if any(isnan(y))
   error('*** compute_nerds: NaNs found in input data.');
end

% vectorize and padding input
N_orig = length(y);
y = vec(y) - min(vec(y));    % vectorize input signal
y = zero_pad(y, 20*opts.L);  % zero padding to prevent circular shift
N = length(y);               % original length of input signal (with padding)

if (isfield(opts, 'template0'))
   % use estimated initial template
   gen_atom = zeros(N, 1);
   gen_atom(1:L) = opts.template0(1:L);

else   
   % create initial atom/template (length L)
   gen_atom = exp(-(0:1:N-1)'./(L/4));
end

gen_atom = gen_atom/norm(gen_atom);         % normalized
gen_atom_freq = 1/sqrt(N)*fft(gen_atom);    % frequency normalized
initial_atom = gen_atom;

gen_atom_mat = zeros(N-L, opts.numTrials+1);
gen_atom_mat(:,1) = initial_atom(1:N-L);

x_hat_mat = zeros(N-L, opts.numTrials);
e_hat_mat = zeros(N, opts.numTrials);


for trials = 1:opts.numTrials

   % - Display progress
   if (opts.verbose)
      fprintf('NERDS: Trial %d...\n', trials);
   end
   
    opts_spg = spgSetParms('verbosity', opts.verbose);
    dict_fun = @(x,mode) dict(x, mode, N, gen_atom_freq);
    
    % non-negativity constraint on coefficients
    x_hat = spg_bp_NN(dict_fun, y, 1:N, opts_spg);
    x_hat(N-L:N) = 0; % set last L coefficient to zeros

    % Stop if we reached the last trial
    if (trials >= opts.numTrials)
       if (wsize > 1)
          x_hat_A = peak_sum(x_hat, wsize, thresh); % added function to sum peak in some window size
          spike_idx{trials} = find(x_hat_A); %#ok<AGROW>
       else
          spike_idx{trials} = find(x_hat); %#ok<AGROW>
       end
       
       gen_atom_mat = gen_atom(1:N-L);
       x_hat_mat = x_hat(1:N-L);
       e_hat_mat = x_hat(N+1:end);
       break;
    end
    
    % update dictionary
    [gen_atom, spk_idx] = gen_new_atom(y, x_hat, N, L, wsize, thresh);
    
    % all result
    gen_atom_mat(:,trials+1) = gen_atom(1:N-L);
    x_hat_mat(:,trials) = x_hat(1:N-L);
    e_hat_mat(:,trials) = x_hat(N+1:end);
    
    spike_idx{trials} = spk_idx; %#ok<AGROW>
    
    % stopping criteria if template converge
    if norm(gen_atom_mat(:,trials+1)-gen_atom_mat(:,trials))<1e-8
        gen_atom_mat = gen_atom_mat(:,trials+1);
        x_hat_mat = x_hat_mat(:,trials);
        e_hat_mat = e_hat_mat(:,trials);
        break;
    end
end

% post processing: threshold spikes
x_hat_fin = x_hat_mat(:, end);
x_hat_fin(x_hat_fin <= opts.thresh*(max(x_hat_fin)-min(x_hat_fin))) = 0;
x_hat_mat(:, end) = x_hat_fin;

% select used coefficient (without padding)
gen_atom_out = gen_atom_mat(1:N_orig,:);
x_hat_out = x_hat_mat(1:N_orig,:);
e_hat_out = e_hat_mat(1:N_orig,:);

if (opts.verbose)
   fprintf('NERDS: Finished.\n');
end

end


