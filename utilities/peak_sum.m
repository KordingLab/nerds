function x_peaksum = peak_sum(x, wsize, threshold)
% function to sum peak of signal x around some window size 
% then zeros thresholding the signal
%
%input: x - input sparse signal
%       wsize - size of window that
%output: x_peaksum - sum peaks 
%

if nargin<3
    threshold = 0.5*std(x);
end

if nargin<2
    wsize = 10; % arbitrary assign value to wsize
end

N = length(x);
x_peaksum = zeros(N,1);
n_bin = floor(length(x)/wsize);

% iterate through bins
for i = 1:n_bin+1
    if i <= n_bin
        x_sel = zeros(N,1);
        x_sel((i-1)*wsize+1:i*wsize) = x((i-1)*wsize+1:i*wsize);
        [~, idx] = max(x_sel);
        peak_sum = sum(x_sel);
        x_peaksum(idx) = peak_sum; % replace maximum place with sum of value in the window
    else
        x_sel = zeros(N,1);
        x_sel(i*wsize:end) = x(i*wsize:end);
        [~, idx] = max(x_sel);
        peak_sum = sum(x_sel);
        x_peaksum(idx) = peak_sum;
    end
end

x_peaksum(x_peaksum<=threshold) = 0; %thresholding small peaks to zero

end

