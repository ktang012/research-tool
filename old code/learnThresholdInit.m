function [best_t,best_precision,best_recall,best_F1] = learnThresholdInit(data, query, queryLabel,...
                                                        bounds, boundLabels)
% Returns the learned threshold and accuracy of the threshold
% bounds mark is a nx2 matrix marking the start and end of an activity
% boundLabels is a nx1 vector indicating what activity is at bounds(i)

subLen = length(query);
bsf_t = 0;
bsf_precision = 0;
bsf_recall = 0;
bsf_F1 = 0;
dp = findNN(data,smooth(query));

% Implement neighbor identification inside this for t=inf
% This way we can update the score as it progresses and just pick the
% best one!
[neighbors,distances] = findRangeNNs(dp,subLen,inf);


distances2 = [distances(2:end); inf];
thresholds = mean([distances distances2],2);
thresholds = thresholds(1:end-1);

% Want to estimate number of nearest neighbors -- after selecting the best
% candidate, the estimated number of total true positves will be used in subsequent searches
length(neighbors);
neighbor_labels = labelNeighbors(neighbors,subLen,bounds,boundLabels);

look_ahead = floor(0.01 * length(thresholds));

for i=1:length(thresholds)
    t = thresholds(i*2);
    nnIndices = findRangeNNs(dp,subLen,t);
    length(nnIndices);
    [precision,recall] = evaluateThreshold(nnIndices,neighbor_labels,queryLabel);
    F1 = 2 * (precision * recall)/(precision + recall);
    F1;
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



