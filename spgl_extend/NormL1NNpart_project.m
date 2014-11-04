function x = NormL1NNpart_project(x,weights,tau,set)
% Projection onto the partial non-negative part of the L1 ball
% Note that only entries in 'set' are forced to be non-negative

%idx = x(set)<0;
%x(set(idx)) = 0;
x(set(x(set)<0))=0;
x = NormL1_project(x,weights,tau);
