function [] = histogramNeighborDist(dictEntry,data,regions,regionLabels,classifiedIndices,buckets)
% Given a dictionary entry, plot a distribution of the its neighbors
if ~exist('buckets','var')
   buckets = 100; 
end

subLen = dictEntry.length;
label = dictEntry.label;

dp = findNN(data,smooth(dictEntry.template));
if exist('classifiedIndices','var')
    for i=1:length(classifiedIndices)
        ind = classifiedIndices(i);
        bottomHalf = ind-floor(subLen/2);
        upperHalf = ind+floor(subLen/2);
        if bottomHalf <= 0
            bottomHalf = 1;
        elseif upperHalf > length(dp)
            upperHalf = length(dp);
        end
        dp(ind:upperHalf) = inf;
        dp(bottomHalf:ind) = inf;
    end
    length(classifiedIndices)
end

[neighborIndices,distances] = findRangeNNs(dp,subLen,inf);
neighborLabels = labelNeighbors(neighborIndices,subLen,regions,regionLabels);

correctIndices = (neighborLabels == label);
incorrectIndices = (neighborLabels ~= label);

length(neighborIndices)


figure;
histogram(distances(correctIndices),buckets);
hold on;
histogram(distances(incorrectIndices),buckets);
legend('Correct Neighbors','Incorrect Neighbors');


end

