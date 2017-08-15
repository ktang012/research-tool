function [dictTPIndices,dictFPIndices,predTPLengths,predFPLengths] = ...
        getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
% gets indices of classified neighbors
% and the corresponding lengths of those neighbors
% using the data dictionary
% 

dictTPIndices = [];
dictFPIndices = [];
predTPLengths = [];
predFPLengths = [];

for i=1:length(dataDict)
    dictDP = findNN(data,smooth(dataDict(i).query));
    
    % Nothing to remove before first entry
    if i ~= 1
        dictDP = removeDPNeighbors(dictDP,dictTPIndices,predTPLengths);
    end
    
    % all neighbors within t_i of entry_i
    entryNNIndices = findRangeNNs(dictDP,dataDict(i).length,dataDict(i).threshold);
    
    % label the neighbors according to boundaries ("actual" labels)
    neighborLabels = labelNeighbors(entryNNIndices,dataDict(i).length,regions,regionLabels);
    
    % group predictions
    entryTPIndices = entryNNIndices(neighborLabels == dataDict(i).label);
    entryFPIndices = entryNNIndices(neighborLabels ~= dataDict(i).label);
    
    predTPLength = ones(length(entryTPIndices),1) * dataDict(i).length; 
    predTPLengths = [predTPLengths; predTPLength];
    
    predFPLength = ones(length(entryFPIndices),1) * dataDict(i).length;
    predFPLengths = [predFPLengths; predFPLength];
    
    % add correct predictions
    dictTPIndices = [dictTPIndices; entryTPIndices];
    dictFPIndices = [dictFPIndices; entryFPIndices];
end

end
