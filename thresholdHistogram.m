function [ti,fi] = thresholdHistogram(data,query,bounds,boundLabels,queryLabel)

dp = findNN(data,smooth(query));
[indices,distances] = findRangeNNs(dp,length(query),inf);

labels = labelNeighbors(indices,length(query),bounds,boundLabels);

t = distances(labels == queryLabel);
f = distances(labels ~= queryLabel);

ti = indices(labels == queryLabel); %& distances >= 10);
fi = indices(labels ~= queryLabel);

figure;
histogram(t,100);
hold on;
histogram(f,100);
legend('positive','negative');

end

