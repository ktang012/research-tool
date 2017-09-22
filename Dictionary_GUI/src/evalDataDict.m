function [dictIndices,Fscore,numClassTP,numClassFP,indLengths] = ...
    evalDataDict(data,dataDict,beta,regions,regionLabels,estTotalTP)
% Evaluates F score of the dictionary

[dictTPIndices,dictFPIndices, TPLengths, FPLengths] = ...
    getClassifiedNeighbors2(data,dataDict,regions,regionLabels);

dictIndices = [dictTPIndices; dictFPIndices];
indLengths = [TPLengths; FPLengths];

numClassTP = length(dictTPIndices);
numClassFP = length(dictFPIndices);

precision = numClassTP / (numClassTP + numClassFP);
recall = numClassTP / estTotalTP;

Fscore = F_betaScore(precision,recall,beta);

end

