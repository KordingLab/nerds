function labdist_fast = metric_labdist_fast(sa,la,sb,lb,q,k)
%LABDIST_FAST(SA,LA,SB,LB,Q,K)
%   Calculates the multi-unit metric distance between two spike trains
%   Uses a fast version of the algorithm
%    SA, SB - spike times on the two spike trains
%    LA, LB - spike labels (positive integers)
%    Q - timing precision parameter
%    K - label reassigning parameter
%
%   Dmitriy Aronov, 6/20/01

%Assign labels in the form 1,2,...,L and count spikes of each label
lbs = unique([la lb]);
L = size(lbs,2);
for c = 1:L
    j = find(la==lbs(c));
    la(j) = c;
    numa(c) = size(j,2);
    j = find(lb==lbs(c));
    lb(j) = c;
    numb(c) = size(j,2);
end

%Choose the spike train to separate to subtrains
if prod(numb+1) < prod(numa+1)
    t = la;
    la = lb;
    lb = t;
    t = sa;
    sa = sb;
    sb = t;
    t = numa;
    numa = numb;
    numb = t;
end
for c = 1:L
    tb{c} = sb(find(lb==c));
end

%Set up an indexing system
ind = [];
for c = 1:L
    j = repmat(0:numb(c),prod(numb(c+1:end)+1),1);
    j = repmat(reshape(j,prod(size(j)),1),prod(numb(1:c-1)+1),1);
    ind = [ind j];
end
ind = sortrows([sum(ind,2) ind]);
ind = ind(:,2:end);

%Initialize the array
m = zeros(size(ind,1),size(sa,2)+1);
m(1,:) = 0:size(sa,2);
m(:,1) = sum(ind,2);

%Perform the calculation
for v = 2:size(m,1)
    for w = 2:size(m,2)
        alt = m(v,w-1) + 1;
        th = ind(v,:);
        for c = find(th > 0);
            ps = th;
            ps(c) = ps(c) - 1;
            n = find(sum(abs(ind-repmat(ps,size(ind,1),1)),2)==0);
            alt = [alt m(n,w) + 1];
            qcost = q*abs(sa(w-1) - tb{c}(th(c)));
            kcost = k*not(la(w-1) == c);
            alt = [alt m(n,w-1) + qcost + kcost];
        end
        m(v,w) = min(alt);
    end
end

labdist_fast = m(end,end);