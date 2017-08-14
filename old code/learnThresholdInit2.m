function [best_t,best_F1,nnIndices]= ...
    learnThresholdInit2(data,query,queryLabel,bounds,boundLabels)
% Returns set of all neighbors less than or equal to the best threshold
dp = findNN(data,smooth(query));
subLen = length(query);
[best_t,best_F1,splitIndex,nnIndices] = ...
    findBestThreshold(dp,subLen,queryLabel,bounds,boundLabels);
nnIndices = nnIndices(1:splitIndex);
end

