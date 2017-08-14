% Learns a data dictionary with queries of length subLen and its 
% respective threshold for one class 

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

% Want to classify locomotive
boundLabels(boundLabels == 7) = 8;

run_start = bounds(23,1);
run_end = bounds(23,2);
run_sample = X(run_start:run_end);

walk_start = bounds(25,1);
walk_end = bounds(25,2);
walk_sample = X(walk_start:walk_end);

% locomotive: walk_slow and run are under label 8
locomotive_sample = [run_sample; walk_sample];

% Find best k queries using matrix profile
subLen = 75;
k = 10;
queryLabel = 8;

% Need to change these variables to corresponding class
[mp, pi] = interactiveMatrixProfileVer2(smooth(locomotive_sample),subLen);

% candIndices is with respect to locomotive_sample
candIndices = selectInitMPQueries(mp,k,subLen);
candidates = [];
for i=1:length(candIndices)
    query_start = candIndices(i);
    candidate = locomotive_sample(query_start:query_start+subLen-1);
    candidates = [candidates candidate];
end
% Begin learning thresholds for queries
thresholds = []; trainPre = []; trainRec = []; trainF1 = [];
start_t = 5; step_t = 0.25; end_t = 8;
for i=1:length(candIndices)
    % Get query
    candidate = candidates(:,i);
    
    % Learn threshold for query
    [t,pre,rec,F1] = learnThresholdInit(X,candidate,queryLabel,start_t,step_t,end_t,...
                                 bounds,boundLabels);                    
    thresholds = [thresholds; t]; trainPre = [trainPre; pre];
    trainRec = [trainRec; rec]; trainF1 = [trainF1; F1];
end

[~, bestQueryInd] = max(trainF1);
bestQuery = candidates(:,bestQueryInd);

% mpNNIndices is used to edit the MP by removing instances caught by the
% query we added
mpDP = findNN(locomotive_sample,smooth(bestQuery));
mpNNIndices = findRangeNNs(mpDP,length(bestQuery),thresholds(bestQueryInd));
newMP = removeMPNeighbors(mp,mpNNIndices,length(bestQuery));

dataDict = [];
dictEntry= struct('query',candidates(:,bestQueryInd),...
                  'queryIndex',candIndices(bestQueryInd),...
                  'length',length(candidates(:,bestQueryInd)),...
                  'threshold',thresholds(bestQueryInd),...
                  'label',queryLabel);
dataDict = [dataDict; dictEntry];



% Still need to incorporate allNNIndices to learnThreshold2
% Reason: Same sample of neighbors found by initial bestQuery
% This will be a more accurate as opposed to drawing another sample of
% neighbors from the candidate query -- essentially, we want to
% have the other entries classify what the initial bestQuery had missed
% However...
% You cannot use findRangeNNs straight away and you need to use allNNIndices
% first findNN(data,entry_2) -- allNNIndices is created from dp of
% findNN(data, entry_1), so create dp for second entry and remove
% neighbors found by second entry... cumulatively repeat (e.g. for third
% entry white out neighbors found by first and second entries)

k = 20;
[c2,ci2,cd2] = selectMPQueries2(locomotive_sample,dataDict,newMP,subLen,k);
candIndices = ci2;
candidates = c2;

% estimate number of possible neighbors
dpSample = findNN(X,smooth(dictEntry(1).query));
neighborsSample = findRangeNNs(dpSample,dictEntry(1).length,inf);
neighborLabels = labelNeighbors(neighborsSample,dictEntry(1).length,bounds,boundLabels);
estNumTotalTP = sum(neighborLabels == dictEntry(1).label);

thresholds_2 = []; trainPre_2 = []; trainRec_2 = []; trainF1_2 = [];
start_t = 5; step_t = 0.25; end_t = 8;
for i=1:length(candIndices)
   candidate = candidates(:,i);
   
   [t,pre,rec,F1] = learnThreshold2(X,dataDict,estNumTotalTP,candidate,...
                                    queryLabel,start_t,step_t,end_t,...
                                    bounds,boundLabels);
   thresholds_2 = [thresholds_2; t]; trainPre_2 = [trainPre_2; pre];
   trainRec_2 = [trainRec_2; rec]; trainF1_2 = [trainF1_2; F1];
end
[~,bestQueryInd] = max(trainF1_2);
bestQuery = candidates(:,bestQueryInd);
dictEntry= struct('query',candidates(:,bestQueryInd),...
                  'queryIndex',candIndices(bestQueryInd),...
                  'length',length(candidates(:,bestQueryInd)),...
                  'threshold',thresholds_2(bestQueryInd),...
                  'label',queryLabel);
dataDict = [dataDict; dictEntry];



%{
% Begin learning thresholds for queries
thresholds = []; trainPre = []; trainRec = []; trainF1 = [];
start_t = 5; step_t = 0.25; end_t = 8;
for i=1:length(candIndices)
    % Get query
    candidate = candidates(:,i);
    
    % Learn threshold for query
    [t,pre,rec,F1] = learnThreshold2(X,candidate,queryLabel,start_t,step_t,end_t,...
                                 bounds,boundLabels);                    
    thresholds = [thresholds; t]; trainPre = [trainPre; pre];
    trainRec = [trainRec; rec]; trainF1 = [trainF1; F1];
end

[~, bestQueryInd] = max(trainF1);
bestQuery = candidates(:,bestQueryInd);

dictEntry= struct('query',candidates(:,bestQueryInd),...
                  'queryIndex',candIndices(bestQueryInd),...
                  'length',length(candidates(:,bestQueryInd)),...
                  'threshold',thresholds(bestQueryInd),...
                  'label',queryLabel);
dataDict = [dataDict; dictEntry];

tempDP = findNN(X,dataDict(1).query);
tempNNIndices = findRangeNNs(tempDP,dataDict(1).length,dataDict(1).threshold);
tempDP = findNN(X,dataDict(2).query);
tempNNIndices = [tempNNIndices;findRangeNNs(tempDP,dataDict(2).length,dataDict(2).threshold)];
plotNNs(X,[dataDict(1).query dataDict(2).query],tempNNIndices,75,0,bounds);
%}


%{
query = queries(:,i);
%dp = findNN(data(:,1),(query));
dp = findNN(X,(query));
nnIndices = findRangeNNs(dp,subLen,thresholds(i));
%plotNNs(data(:,1),smooth(query),nnIndices,subLen,dp,bounds+243000);
plotNNs(X(:,1),smooth(query),nnIndices,subLen,dp,bounds);
%}
