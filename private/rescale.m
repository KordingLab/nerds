function x_out = rescale(x_in)
% function to rescale the input signal to range 0 to 1
%input: x_in - input vector
%output: x_out - output rescale vector

x_in = x_in - min(x_in);
x_out = x_in/max(x_in);

end