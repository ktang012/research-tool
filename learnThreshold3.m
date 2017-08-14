function [best_t,best_F1,nnIndices] = ...
    learnThreshold3(data,dataDict,query,queryLabel,bounds,boundLabels,...
                    estTotalTP, cumulativeTP,cumulativeFP)
%LEARNTHRESHOLD3 Summary of this function goes here
%   Detailed explanation goes here

dp = findNN(data,smooth(query));
subLen = length(query);

% remove correctly predicted TP from dp
for i=1:length(dataDict)
    predTPLengths = ones(length(dataDict(i).nnIndices),1) * dataDict(i).length;
    dp = removeDPNeighbors(dp,dataDict(i).nnIndices,predTPLengths);
end

[best_t,best_F1,splitIndex,nnIndices] = ...
    findBestThreshold(dp,subLen,queryLabel,bounds,boundLabels,...
                      estTotalTP,cumulativeTP,cumulativeFP);
nnIndices = nnIndices(1:splitIndex);

end

