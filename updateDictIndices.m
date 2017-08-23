function [newDataDict] = updateDictIndices(data,dataDict,regions,regionLabels)
% Updates indices of the dictionary to be up to date with data
[~,~,~,~,sortedTPIndices,sortedFPIndices] = ...
    getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
for i=1:length(dataDict)
    dataDict(i).tpIndices = sortedTPIndices{i};
    dataDict(i).fpIndices = sortedFPIndices{i};
    [unorderTPIndices,unorderFPIndices] = ...
        getClassifiedNeighbors2(data,dataDict(i),regions,regionLabels);
    dataDict(i).unorderTPIndices = unorderTPIndices;
    dataDict(i).unorderFPIndices = unorderFPIndices;
end
newDataDict = dataDict;
end

