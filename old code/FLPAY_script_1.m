% Learns one query of length subLen and its threshold for one class

% Load entire raw file
% Notes: Sampled at 90Hz for 18992s and logged from 243000 to 733880, 
% which is 5454s
data = csvread('Files for Conference Call/FLPAY029S1D1HipRAW.csv',11,1);

% Extract logged data
X = data(243000:733882,1);

% Label key:
% Transition = 0, Lying = 1, Dust = 2, Internet = 3,
% Reclining = 4, Sweep = 5, Basketball = 6, Run = 7,
% Walk_Slow = 8, Catch = 9, Unknown = 10;

bounds = load('logBounds.mat');
bounds = bounds.bounds;
boundLabels = load('logLabels.mat');
boundLabels = boundLabels.boundLabels;

% Find best k queries using matrix profile
subLen = 75;
k = 10;

run_start = bounds(23,1);
run_end = bounds(23,2);
run_sample = smooth(X(run_start:run_end));

walk_start = bounds(25,1);
walk_end = bounds(25,2);
walk_sample = smooth(X(walk_start:walk_end));

bb_start = bounds(20,1);
bb_end = bounds(20,2);
bb_sample = smooth(X(bb_start:bb_end));

% Need to change these variables to corresponding class
[mp, pi] = interactiveMatrixProfileVer2(walk_sample,subLen);
queryIndices = selectInitMPQueries(mp,k,subLen) + walk_start;
queryLabel = 8;

% Testing locomotion
boundLabels(boundLabels == 7) = 8;

% Begin learning thresholds for queries
thresholds = [];
trainPre = [];
trainRec = [];
trainF1 = [];

start_t = 4;
step_t = 0.1;
end_t = 8;
for i=1:length(queryIndices)
    % Extract query
    query = X(queryIndices(i):queryIndices(i)+subLen-1);
    
    % Learn threshold for query
    [t,pre,rec,F1] = learnThreshold(X,query,queryLabel,start_t,step_t,end_t,...
                                 bounds,boundLabels);                    
    thresholds = [thresholds; t];
    trainPre = [trainPre; pre];
    trainRec = [trainRec; rec];
    trainF1 = [trainF1; F1];
end

[~, bestQueryInd] = max(trainF1);

i = bestQueryInd;
query = X(queryIndices(i):queryIndices(i)+subLen-1);
%dp = findNN(data(:,1),(query));
dp = findNN(X,(query));
nnIndices = findRangeNNs(dp,subLen,thresholds(i));
%plotNNs(data(:,1),smooth(query),nnIndices,subLen,dp,bounds+243000);
plotNNs(X(:,1),smooth(query),nnIndices,subLen,dp,bounds);

