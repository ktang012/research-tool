function [indices, indLengths, orgIndices] = getClassifiedNeighborsUnlabeled(data, dataDict)
% Given an unlabeled time series, returns the set of indices for the dictionary
% Uses the distance profile to remove classified entries. The organized indices
% correspond to the respective dictionary entries, allowing for indexing
% based on a subset of the dictionary.

indices = [];
orgIndices = {};
indLengths = [];

for i=1:length(dataDict)
    dictDP = findNN(data,smooth(dataDict(i).template));
    
    if i > 1
       dictDP = removeDPNeighbors(dictDP,indices,indLengths); 
    end
    
    entryIndices = findRangeNNs(dictDP,dataDict(i).length,dataDict(i).threshold);
    entryLengths = ones(length(entryIndices),1) * dataDict(i).length;
    
    indices = [indices; entryIndices];
    orgIndices{i} = entryIndices;
    indLengths = [indLengths; entryLengths];
end


end

