function [learnedQuery,bestT,bestF1] = learnQuery(trainData,dataDict,...
    queryInd,queryLabel,candidateData,startLen,stepLen,endLen,...
    bounds,boundLabels,estTotalTPs,cumulativeTP,cumulativeFP)
% Learns the length and threshold for a query
bestSubLen = 0;
bestT = 0;
bestF1 = 0;
prevF1 = 0;
bestF1Precision = 0;
prevF1Precision = 0;
listT = [];
listF1 = [];
listF1Precision = [];
listSubLen = [];

lengthInd = 1;
baseWeightTotalTP = estTotalTPs(1);


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
    
    weight = baseWeightTotalTP/estTotalTPs(lengthInd);
    
    % experimental
    avgTPs = 0;
    for i=1:length(dataDict)
        avgTPs = avgTPs + estTotalTPs(i);
    end
    avgTPs = avgTPs + estTotalTPs(lengthInd);
    if ~isempty(dataDict)
        avgTPs = avgTPs/(length(dataDict)+1);
    end
    baseTotalTP = avgTPs;
    
    [t,F1] = findBestThreshold2(dp,subLen,queryLabel,bounds,boundLabels,...
        baseTotalTP,cumulativeTP,cumulativeFP,weight);
    
    listT = [listT; t];
    listF1 = [listF1; F1];
    listSubLen = [listSubLen; subLen];
    
    %% Need to penalize longer lengths...!!!
    
    if F1 < prevF1
        break;
    end
    
    lengthInd = lengthInd + 1;
end

[bestF1,bestInd] = max(listF1);

bestT = listT(bestInd);
bestSubLen = listSubLen(bestInd);
learnedQuery = candidateData(queryInd:queryInd+bestSubLen-1);
end

