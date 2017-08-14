function [precision,recall] = evaluateThreshold2(nnIndices,neighborLabels,queryLabel,...
                 estNumTotalTP,numClassTP,numClassFP)
% evaluates candidate with respect to dictionary entries

% Because we did indices = findRangeNNs(dp,sublen,inf)
% to get all possible neighbors from a dp for the candidate and then
% nn = findRangeNNs(dp,sublen,t), it gives us an in order
% list of indices cut off at t
% Further note, neighborLabels is from t=inf and nnIndices is from t=t

tp = sum(neighborLabels(1:length(nnIndices)) == queryLabel);
fp = sum(neighborLabels(1:length(nnIndices)) ~= queryLabel);

tp = tp + numClassTP;
fp = fp + numClassFP;

precision = tp / (tp + fp);
recall = tp / estNumTotalTP;


end

