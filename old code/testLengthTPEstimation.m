% Sample total tp from first iteration of candidates (average of k sampels)
% To score a given neighbor classification for being a TP or FP
% N_i = S_default/S_i, where N_i is how much it contributes to being a TP
% or FP. For example, if N_i is of length default, it will contribute a
% score of 1. If N_i is double the length of default, it will contribute a
% score of at most 2 (close to 2). This will provide a means to counting
% the number of TP and FP of variable lengths to calculate the F1 score.


% How to evaluate the length of a query? Learn threshold at length=def, then
% length=def+step, if it improves the F1 score, then continue extending
% until length=def*stop. If it immediately does not improve, then take the
% length with highest score (the one prior to the extension)


tpCount = [];
queryLabel = 8;
ind = 25342;
for subLen=70:7:210
    dp = findNN(X,locomotive_sample(ind:ind+subLen-1));
    nn = findRangeNNs(dp,subLen,inf);
    labels = labelNeighbors(nn,subLen,bounds,boundLabels);
    tp = sum(labels == queryLabel);
    tpCount = [tpCount; tp];
end
ind = 1170;
tpCount2 = [];
for subLen=70:7:210
    dp = findNN(X,locomotive_sample(ind:ind+subLen-1));
    nn = findRangeNNs(dp,subLen,inf);
    labels = labelNeighbors(nn,subLen,bounds,boundLabels);
    tp = sum(labels == queryLabel);
    tpCount2 = [tpCount2; tp];
end
ind = 11694;
tpCount3 = [];
for subLen=70:7:210
    dp = findNN(X,locomotive_sample(ind:ind+subLen-1));
    nn = findRangeNNs(dp,subLen,inf);
    labels = labelNeighbors(nn,subLen,bounds,boundLabels);
    tp = sum(labels == queryLabel);
    tpCount3 = [tpCount3; tp];
end
ind = 28134;
tpCount4 = [];
for subLen=70:7:210
    dp = findNN(X,locomotive_sample(ind:ind+subLen-1));
    nn = findRangeNNs(dp,subLen,inf);
    labels = labelNeighbors(nn,subLen,bounds,boundLabels);
    tp = sum(labels == queryLabel);
    tpCount4 = [tpCount4; tp];
end
ind = 0;
tpCount5 = [];
for subLen=70:7:210
    dp = findNN(X,zeros(subLen,1));
    nn = findRangeNNs(dp,subLen,inf);
    labels = labelNeighbors(nn,subLen,bounds,boundLabels);
    tp = sum(labels == queryLabel);
    tpCount5 = [tpCount5; tp];
end



