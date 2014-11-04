% =========================================================================
% FISTA-based constrained least squares
% -------------------------------------------------------------------------
%
% solves:
%
%   minimize   ||A*x-b||^2_2
%   subject to [x]_Omega=0
%              [x]_OmegaC>=0
%
%   A(x,mode) where mode = 1 -> A*x
%                   mode = 2 -> A'*x
%
% -------------------------------------------------------------------------
% (c) 2013 studer@rice.edu
% =========================================================================

function [x,k] = constrained_LS(A,b,N,Omega,maxSVD,maxiter,epsilon)

OmegaC = setdiff(1:N,Omega); % initialization 

xkp = zeros(N,1);
yk = xkp;
tk = 1;
k = 0;

normdiff = inf;
normxk = 0;

L = 2*maxSVD^2;                 % Lipschitz constant

% perform first-order method
while (k < maxiter) && (normdiff > normxk*epsilon)
    k = k+1;
    z = yk-2/L*A(A(yk,1)-b,2);  % gradient
    z(Omega) = 0;
    z(OmegaC) = max(z(OmegaC),0);
    xk = z;
    
    tkn = 0.5*(1+sqrt(1+4*tk^2));
    ykn = xk + (tk-1)/tkn*(xk-xkp);
    
    normdiff = norm(xk-xkp,2);
    normxk = norm(xkp,2);
    
    xkp = xk;
    yk = ykn;
    tk = tkn;
    
end

x = xk;
  
end