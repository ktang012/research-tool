function [predTPIndices,numClassTP,numClassFP,predTPLengths] = getClassifiedNeighbors(data,dataDict,bounds,boundLabels)
% gets indices of correctly classified neighbors
% and the corresponding lengths of those neighbors

predTPIndices = [];
numClassTP = 0;
numClassFP = 0;
predTPLengths = [];

for i=1:length(dataDict)
    dictDP = findNN(data,smooth(dataDict(i).query));
    
    % if i == 1, this does nothing
    if i ~= 1
        dictDP = removeDPNeighbors(dictDP,predTPIndices,predTPLengths);
    end
    
    % all neighbors within t_i of entry_i
    entryNNIndices = findRangeNNs(dictDP,dataDict(i).length,dataDict(i).threshold);
    numPred = length(entryNNIndices);
    
    % label the neighbors according to boundaries ("actual" labels)
    neighborLabels = labelNeighbors(entryNNIndices,dataDict(i).length,bounds,boundLabels);
    
    % correct predictions
    entryNNIndices = entryNNIndices(neighborLabels == dataDict(i).label);
    predTPLength = ones(length(entryNNIndices),1) * dataDict(i).length; 
    predTPLengths = [predTPLengths; predTPLength];
    
    % number of tp and fp
    numClassTP = numClassTP + length(entryNNIndices);
    numClassFP = numClassFP + (numPred - length(entryNNIndices));
    
    % add correct predictions
    predTPIndices = [predTPIndices; entryNNIndices];
end


end