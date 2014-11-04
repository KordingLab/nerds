function p = NormL1NNpart_primal(x,weights,set)
% Non-negative L1 gauge function

p = norm(x.*weights,1);
if any(x(set) < 0)
    p = Inf;
end

