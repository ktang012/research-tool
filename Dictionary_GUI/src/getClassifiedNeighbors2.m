function [dictTPIndices,dictFPIndices,...
    predTPLengths,predFPLengths,...
    orgTPIndices,orgFPIndices] = ...
        getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
% Given a weakly labeled time series, returns true positive and false
% positive indices as classified by the dictionary. The organized indices
% correspond to the respective dictionary entries

dictTPIndices = [];
dictFPIndices = [];

% Lengths of neighbors
predTPLengths = [];
predFPLengths = [];

orgTPIndices = {};
orgFPIndices = {};

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
    orgTPIndices{i} = entryTPIndices;
    orgFPIndices{i} = entryFPIndices;
    
    
    predTPLength = ones(length(entryTPIndices),1) * dataDict(i).length; 
    predTPLengths = [predTPLengths; predTPLength];
    
    predFPLength = ones(length(entryFPIndices),1) * dataDict(i).length;
    predFPLengths = [predFPLengths; predFPLength];
    
    % add correct predictions
    dictTPIndices = [dictTPIndices; entryTPIndices];
    dictFPIndices = [dictFPIndices; entryFPIndices];
end

end
