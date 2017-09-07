function [newDataDict] = updateDictIndices(data,dataDict,regions,regionLabels)
% Updates indices of the dictionary to be up to date with data

if exist('regions','var') && exist('regionLabels','var')
    [~,~,~,~,sortedTPIndices,sortedFPIndices] = ...
        getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
    for i=1:length(dataDict)
        dataDict(i).tpIndices = sortedTPIndices{i};
        dataDict(i).fpIndices = sortedFPIndices{i};
        [unorderTPIndices,unorderFPIndices] = ...
            getClassifiedNeighbors2(data,dataDict(i),regions,regionLabels);
        dataDict(i).unorderTPIndices = unorderTPIndices;
        dataDict(i).unorderFPIndices = unorderFPIndices;
        
        dataDict(i).indices = [];
        dataDict(i).unorderIndices = [];
    end
else
    [~,~,orgIndices] = getClassifiedNeighborsUnlabeled(data,dataDict);
    for i=1:length(dataDict)
       dataDict(i).indices = orgIndices{i};
       dataDict(i).unorderIndices = getClassifiedNeighborsUnlabeled(data,...
           dataDict(i));
       
       dataDict(i).tpIndices = [];
       dataDict(i).fpIndices = [];
       dataDict(i).unorderTPIndices = [];
       dataDict(i).unorderFPIndices = [];
    end
end
newDataDict = dataDict;
end

