function peak_counts = count_peaks(ephys_signal, fluorescent)
% function to count peaks of physiology signal
% this function will call findpeaks_ephys function
%input: ephys_signal - read physiology signal (lx1 vector)
%       fluorescent - fluorescent signal (data in row format mxn matrix)

l = length(ephys_signal);
[m, n] = size(fluorescent);
bin_len = floor(l/n);            % total number of bins
peak_dist = 20;
threshold = min(ephys_signal)+floor((max(ephys_signal)-min(ephys_signal))/2);

peak_counts = zeros(n, 1);       % length equal to column of flo matrix
for i = 1:n
    [val, idx] = findpeaks_ephys(ephys_signal((i-1)*bin_len+1: i*bin_len), ...
                                 peak_dist, threshold);
    peak_counts(i) = length(idx); % number of peak found
end

end


function [val, idx] = findpeaks_ephys(signal, peak_dist, threshold)
% input: signal - 1D signal data either column or row format
%        peak_dist - 
%        threshold - find peak only above threshold

if nargin<3
    threshold = floor(max(signal)/2);
end

if nargin<2
    peak_dist = 10;
end
[msg id] = lastwarn;             % suppress warning
warning('off',id)

[val, idx] = findpeaks(double(signal),'MinPeakDistance', peak_dist, ...
                                      'MinPeakHeight',floor(max(signal)/2));

warning('on',id) % turn warning back again
                                  
end


