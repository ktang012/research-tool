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
subLen = 85; % Need to find query length later
k = 20;
queryLabel = 8;

tic;
mp = interactiveMatrixProfileVer2(smooth(locomotive_sample),75);
endMPTime = toc;

subLen = 95;
dataDict = [];
prevF1 = -1;
newF1 = 0;
cumulativeTPs = [];
cumulativeFPs = [];
listNNIndices = [];
F1_diff = 0.0075;

MPQueryTime = [];
learnThreshTime = [];

tic
while (newF1 - F1_diff) > prevF1
    prevF1 = newF1
    
    % candIndices is the index in the data used for the MP
    if isempty(dataDict)
        %tic;
        [candidates, candIndices] = selectInitMPQueries(locomotive_sample,mp,k,subLen);
        %MPQueryTime = [MPQueryTime; toc];
    else
        % Do we really need to edit the MP? It excludes similar entries
        % from dictionary...
        %tic;
        newMP = removeMPNeighbors2(locomotive_sample,mp,dataDict);
        [candidates,candIndices,d] = selectMPQueries2(locomotive_sample,dataDict,newMP,subLen,k);
        %MPQueryTime = [MPQueryTime; toc];
    end
    
    
    
    thresholds = []; trainF1 = [];
    for i=1:length(candIndices)
        % Get query
        candidate = candidates(:,i);
        
        % Learn threshold for query
        if isempty(dataDict)
            %tic;
            [t,F1] = learnThresholdInit2(X,candidate,queryLabel,bounds,boundLabels);
            %learnThreshTime = [learnThreshTime; toc];
        else
            %tic;
            [t,F1] = learnThreshold3(X,dataDict,candidate,...
                queryLabel,bounds,boundLabels,estNumTotalTP,cumulativeTPs(end),cumulativeFPs(end));
            %learnThreshTime = [learnThreshTime; toc];
        end
        
        thresholds = [thresholds; t]; trainF1 = [trainF1; F1];
    end
    
    [~, bestQueryInd] = max(trainF1);
	bestQuery = candidates(:,bestQueryInd);
    
    % cumulative nnIndices
    dp = findNN(X,smooth(bestQuery));
    [removeNNIndices,~,~,predTPLengths] = getClassifiedNeighbors(X,dataDict,bounds,boundLabels);
    dp = removeDPNeighbors(dp,removeNNIndices,predTPLengths);
    
    % get remaining neighbors within t
    nnIndices = findRangeNNs(dp,subLen,thresholds(bestQueryInd));
    labels = labelNeighbors(nnIndices,subLen,bounds,boundLabels);
    
    % get only the indices of the correct predictions
    TPIndices = nnIndices(labels == queryLabel);
    
    dictEntry= struct('query',candidates(:,bestQueryInd),...
        'queryIndex',candIndices(bestQueryInd),...
        'length',length(candidates(:,bestQueryInd)),...
        'threshold',thresholds(bestQueryInd),...
        'label',queryLabel,...
        'nnIndices', TPIndices);
    dataDict = [dataDict; dictEntry];
    
    if length(dataDict) == 1
        dpSample = findNN(X,smooth(dictEntry(1).query));
        neighborsSample = findRangeNNs(dpSample,dictEntry(1).length,inf);
        neighborLabels = labelNeighbors(neighborsSample,dictEntry(1).length,bounds,boundLabels);
        estNumTotalTP = sum(neighborLabels == dictEntry(1).label);
    end
    
    % Need function to evaluate dictionary -- have this be newF1
    [newF1,numClassTP,numClassFP] = evalDataDict(X,dataDict,bounds,boundLabels,estNumTotalTP)
    cumulativeTPs = [cumulativeTPs; numClassTP];
    cumulativeFPs = [cumulativeFPs; numClassFP];
end
endAlgTime = toc;
%{
plotNNs(X,[dataDict(1:end).query],cumNNIndices,dataDict(ind).length,dp,bounds);


cumNNIndices = [];
r = 0;
ind = 1;
dp = findNN(X,smooth(dataDict(ind).query));
nnIndices = findRangeNNs(dp,dataDict(ind).length,dataDict(ind).threshold+r);
plotNNs(X,dataDict(ind).query,nnIndices,dataDict(ind).length,dp,bounds);
cumNNIndices = [cumNNIndices;nnIndices];

ind = 2;
dp = findNN(X,smooth(dataDict(ind).query));
dp = removeDPNeighbors(dp,cumNNIndices,ones(length(cumNNIndices),1)*75);
nnIndices = findRangeNNs(dp,dataDict(ind).length,dataDict(ind).threshold+r);
plotNNs(X,dataDict(ind).query,nnIndices,dataDict(ind).length,dp,bounds);
cumNNIndices = [cumNNIndices;nnIndices];

ind = 3;
dp = findNN(X,smooth(dataDict(ind).query));
dp = removeDPNeighbors(dp,cumNNIndices,ones(length(cumNNIndices),1)*75);
nnIndices = findRangeNNs(dp,dataDict(ind).length,dataDict(ind).threshold+r);
plotNNs(X,dataDict(ind).query,nnIndices,dataDict(ind).length,dp,bounds);
cumNNIndices = [cumNNIndices;nnIndices];



ind = 4;
dp = findNN(X,smooth(dataDict(ind).query));
dp = removeDPNeighbors(dp,cumNNIndices,ones(length(cumNNIndices),1)*75);
nnIndices = findRangeNNs(dp,dataDict(ind).length,dataDict(ind).threshold+r);
plotNNs(X,dataDict(ind).query,nnIndices,dataDict(ind).length,dp,bounds);
cumNNIndices = [cumNNIndices;nnIndices];

ind = 5;
dp = findNN(X,smooth(dataDict(ind).query));
dp = removeDPNeighbors(dp,cumNNIndices,ones(length(cumNNIndices),1)*75);
nnIndices = findRangeNNs(dp,dataDict(ind).length,dataDict(ind).threshold+r);
plotNNs(X,dataDict(ind).query,nnIndices,dataDict(ind).length,dp,bounds);
cumNNIndices = [cumNNIndices;nnIndices];
%}



