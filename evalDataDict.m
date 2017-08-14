function [dictIndices,Fscore,numClassTP,numClassFP,indLengths] = evalDataDict(data,dataDict,bounds,boundLabels,estTotalTP)
% Evaluates F score of the dictionary

[dictTPIndices,dictFPIndices, TPLengths, FPLengths] = ...
    getClassifiedNeighbors2(data,dataDict,bounds,boundLabels);

dictIndices = [dictTPIndices; dictFPIndices];
indLengths = [TPLengths; FPLengths];

numClassTP = length(dictTPIndices);
numClassFP = length(dictFPIndices);

precision = numClassTP / (numClassTP + numClassFP);
recall = numClassTP / estTotalTP;

beta = 0.8;
Fscore = F_betaScore(precision,recall,beta);

end

