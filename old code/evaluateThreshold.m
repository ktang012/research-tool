function [precision,recall] = evaluateThreshold(nnIndices,neighborLabels,queryLabel)
% evalutates threshold for the first candidate entry
tp = sum(neighborLabels(1:length(nnIndices)) == queryLabel);
fp = sum(neighborLabels(1:length(nnIndices)) ~= queryLabel);
total_tp = sum(neighborLabels == queryLabel);

precision = tp / (tp + fp);
recall = tp / total_tp;

end

