% example on brain observatory data
load('corrected_traces_exptcont_511509529_sessionA.mat')

opts.numTrials = 1; % set to larger than 1 if you want to learn the template
opts.thresh = 0.05;
opts.L = 100;
N = size(traces,1);

telapsed = zeros(N,1);
x_hat = cell(N,1);
norm_traces = zeros(size(traces));
parpool(8)
parfor i=1:N
    flo = traces(i,:); 
    flo = flo - min(flo);
    flo = flo./max(flo);
    norm_traces(i,:) = flo;
    tstart = tic; 
    [~, ~, x_hat{i}, ~] = compute_nerds(double(flo), opts); 
    telapsed(i) = toc(tstart);
    i,
end

X = zeros(size(traces));
for i=1:N, 
    X(i,:) = x_hat{i}; 
end

%figure; imagesc(X)
%myColorMap = jet(256);
%myColorMap(1:15, :) = ones(15,3); % Set row 128 to white.
%colormap(myColorMap);
%colorbar;

save results-exptcont-511509529-sessionA.mat X telapsed norm_traces


