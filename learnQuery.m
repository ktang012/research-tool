function [learnedQuery,bestThreshold,bestFscore] = learnQuery(trainData,dataDict,...
    queryInd,queryLabel,candidateData,F_beta,startLen,stepLen,endLen,...
    regions,regionLabels,estTotalTPs,cumulativeTPCount,cumulativeFPCount)
% Learns the length and threshold for a query
listThreshold = [];
listFscores = [];
listSubLen = [];

lengthInd = 1;

for subLen=startLen:stepLen:endLen
    if queryInd+subLen-1 > length(candidateData)
        break;
    end
    query = candidateData(queryInd:queryInd+subLen-1);
    
    % Remove correctly predicted instances
    dp = findNN(trainData,smooth(query));
    for i=1:length(dataDict)
        predTPLengths = ones(length(dataDict(i).tpIndices),1) * dataDict(i).length;
        dp = removeDPNeighbors(dp,dataDict(i).tpIndices,predTPLengths);
    end
    
    [t,Fscore] = findBestThreshold2(dp,subLen,queryLabel,regions,regionLabels,F_beta,...
        estTotalTPs,cumulativeTPCount,cumulativeFPCount);
    
    listThreshold = [listThreshold; t];
    listFscores = [listFscores; Fscore];
    listSubLen = [listSubLen; subLen];

    lengthInd = lengthInd + 1;
end

[bestFscore,bestInd] = max(listFscores);

bestThreshold = listThreshold(bestInd);
bestSubLen = listSubLen(bestInd);
learnedQuery = candidateData(queryInd:queryInd+bestSubLen-1);
end

