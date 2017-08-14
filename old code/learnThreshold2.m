function [best_t,best_precision,best_recall,best_F1] = learnThreshold2(data, dataDict, estNumTotalTP,...
                                                        query, queryLabel,...
                                                        bounds, boundLabels)
% Returns the learned threshold and accuracy of the threshold
% bounds mark is a nx2 matrix marking the start and end of an activity
% boundLabels is a nx1 vector indicating what activity is at bounds(i)

subLen = length(query); % of candidate
predTPIndices = [];
numClassTP = 0;
numClassFP = 0;


[predTPIndices,numClassTP,numClassFP, predTPLengths] = ...
    getClassifiedNeighbors(data,dataDict,bounds,boundLabels);

% compute dp for candidate with removed neighbors
dp = findNN(data,smooth(query));
dp = removeDPNeighbors(dp,predTPIndices,predTPLengths);

% find all neighbors left after removing from DP
[neighbors,distances] = findRangeNNs(dp,subLen,inf);
distances2 = [distances(2:end); inf];
thresholds = mean([distances distances2],2);
thresholds = thresholds(1:end-1);

neighborLabels = labelNeighbors(neighbors,subLen,bounds,boundLabels);

look_ahead = floor(0.01 * length(thresholds));

% find best t for this candidate
bsf_t = 0;
bsf_precision = 0;
bsf_recall = 0;
bsf_F1 = 0;
for i=1:length(thresholds);
   t = thresholds(i*2);
   nnIndices = findRangeNNs(dp,subLen,t);
   length(nnIndices);
   [precision,recall] = evaluateThreshold2(nnIndices,neighborLabels,queryLabel,...
       estNumTotalTP,numClassTP,numClassFP);
   F1 = 2 * (precision * recall)/(precision + recall);
   if F1 > bsf_F1
       bsf_t = t;
       bsf_precision = precision;
       bsf_recall = recall;
       bsf_F1 = F1;
   else
       look_ahead = look_ahead - 1;
   end
   
   if look_ahead <= 0
       break;
   end
end

best_t = bsf_t;
best_precision = bsf_precision;
best_recall = bsf_recall;
best_F1 = bsf_F1;

end



