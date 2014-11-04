function x_out = padding(x, L)
%input: x - row or column vector
%       L - padding length (default to length of template/atom)
%output x_out - padded column vector

if nargin<2
    L = 0;
    disp('Apply no padding to the data...');
end

N = length(x);
x = vec(x); % vectorize x
x_out = [x; x(N-L:N)];

end

