function gam_pdf = est_gam_dist(gen_atom, L)
%EST_GAM_DIST estimating gamma distribution 
%input  gen_atom - input signal
%       L - length of gen_atom that we want to use to estimate
%           gamma distribution
%output gam_pdf - estimated gammadistribution
%    
% example: gam_est = estimate_gamma_dist(gen_atom)

N = length(gen_atom);
if nargin<2
    L = N;
end

gen_atom = vec(gen_atom);
gen_atom_est = zeros(N,1);
gen_atom_est(1:L) = gen_atom(1:L);
gen_atom_est = gen_atom_est/trapz([1:N]', gen_atom_est); % pdf
F = @(param, xdata) gampdf(xdata, param(1), param(2)); % create gamma pdf function
init_con = [5, 5]; % initial condition of gamma params (need to change)

options = optimset(optimset('lsqcurvefit'),'Display','off');
sol = lsqcurvefit(F, init_con, [1:N]', gen_atom_est, [], [], options);
gam_pdf = vec(gampdf(1:N, sol(1), sol(2)));  % create gamma pdf function
gam_pdf = gam_pdf/norm(gam_pdf); % normailze (not sure that we need to normalize...)


end

