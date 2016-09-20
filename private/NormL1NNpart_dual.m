function d = NormL1NNpart_dual(x,weights,set)
% Dual of partially non-negative L1 gauge function
% Note that only entries in 'set' are forced to be non-negative

%idx = x(set)<0;
%x(set(idx)) = 0;
x(set(x(set)<0))=0;
d = norm(x./weights,inf);
