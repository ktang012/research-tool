function [dictIndices,F1,numClassTP,numClassFP,indLengths] = evalDataDict(data,dataDict,bounds,boundLabels,estTotalTP)
% Evaluates F1 score of the dictionary

[dictTPIndices,dictFPIndices, TPLengths, FPLengths] = ...
    getClassifiedNeighbors2(data,dataDict,bounds,boundLabels);

dictIndices = [dictTPIndices; dictFPIndices];
indLengths = [TPLengths; FPLengths];

numClassTP = length(dictTPIndices);
numClassFP = length(dictFPIndices);

precision = numClassTP / (numClassTP + numClassFP);
recall = numClassTP / estTotalTP;


F1 = 2 * (precision * recall)/(precision + recall);



%F1 =  1.25 .* ((precision .* recall) ./ ((0.25 .* precision) + recall));

end

