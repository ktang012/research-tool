%{
csvData = csvread('Files for Conference Call/FLPAY029S1D1HipRAW.csv',11,1);
data = csvData(243000:733882,1);
mpData = [];

% Label key:
% Transition = 0, Lying = 1, Dust = 2, Internet = 3,
% Reclining = 4, Sweep = 5, Basketball = 6, Run = 7,
% Walk_Slow = 8, Catch = 9, Unknown = 10;
bounds = load('logBounds.mat');
bounds = bounds.bounds;
boundLabels = load('logLabels.mat');
boundLabels = boundLabels.boundLabels;
% combine walk and run into same class
boundLabels(boundLabels == 7) = 8;

run_start = bounds(23,1);
run_end = bounds(23,2);
run_sample = data(run_start:run_end);
walk_start = bounds(25,1);
walk_end = bounds(25,2);
walk_sample = data(walk_start:walk_end);
locomotion_sample = [run_sample; walk_sample];
mpData = locomotion_sample;
queryLabel = 8;
%}

load('USCTrainingSet');
load('USCTestingSet');
load('syntheticSet');

%{
data = trainData;
bounds = trainBounds;
boundLabels = trainLabels;
%}


data = synData;
bounds = synBounds;
boundLabels = synLabels;



queryLabel = 1;
mpData = [];
for i=1:length(boundLabels)
    if boundLabels(i) == queryLabel
       startInd = bounds(i,1);
       endInd = bounds(i,2);
       m = data(startInd:endInd);
       mpData = [mpData; m];
    end
end


% dictEntry fields
dictEntry = struct('query',0,...
        'queryIndex',0,...
        'length',0,...
        'threshold',0,...
        'label',0,...
        'tpIndices',0,...
        'fpIndices',0);

startLen = 150;
endLen = 200;
stepLen = 10;

mp = interactiveMatrixProfileVer2(mpData,startLen);

k = 30;

dataDict = [];
prevF1 = -1;
newF1 = 0;
cumulativeTPs = [0];
cumulativeFPs = [0];
listNNIndices = [];
F1_diff = 0.0055;
learnTime = [];
searchTime = [];
a = tic;

while (newF1 - F1_diff) > prevF1
    prevF1 = newF1
    
    % candIndices is the index in the data used for the MP
    %% NOTE: can make picking candidates from MP cleaner
    
    b = tic;
    if isempty(dataDict)
        [candidates, candIndices] = selectInitMPQueries(mpData,mp,k,startLen);
        % estimate total TPs at each length for weighing score later
        estTotalTPs = estimateTotalTP(data,candIndices,mpData,queryLabel,...
            bounds,boundLabels,startLen,stepLen,endLen);
    else
        [candidates,candIndices,d] = selectMPQueries2(mpData,dataDict,mp,startLen,k);
        if isempty(candidates)
            break;
        end
    end
    searchTime = [searchTime; toc(b)];
    
    c = tic;
    learnedQueries = {}; thresholds = []; F1Scores = [];
    for i=1:length(candIndices)
        candIndex = candIndices(i);
        [learnedQuery,t,F1] = learnQuery(data,dataDict,...
            candIndex,queryLabel,mpData,startLen,stepLen,endLen,...
            bounds,boundLabels,estTotalTPs,cumulativeTPs(end),cumulativeFPs(end));
        learnedQueries{i} = learnedQuery;
        thresholds = [thresholds; t];
        F1Scores = [F1Scores; F1];
    end
    learnTime = [learnTime; toc(c)];
    
    [maxF1,bestInd] = max(F1Scores);
    
    bestQuery = learnedQueries{bestInd};
    bestThresh = thresholds(bestInd);
       
    % cumulative tpIndices
    dp = findNN(data,smooth(bestQuery));
    [dictTPIndices,dictFPIndices,predTPLengths] = ...
        getClassifiedNeighbors2(data,dataDict,bounds,boundLabels);
    dp = removeDPNeighbors(dp,dictTPIndices,predTPLengths);
    
    % get remaining neighbors within t
    nnIndices = findRangeNNs(dp,length(bestQuery),thresholds(bestInd));
    labels = labelNeighbors(nnIndices,length(bestQuery),bounds,boundLabels);
    
    TPIndices = nnIndices(labels == queryLabel);
    FPIndices = nnIndices(labels ~= queryLabel);
    
    dictEntry = struct('query',zscore(bestQuery),...
        'queryIndex',candIndices(bestInd),...
        'length',length(bestQuery),...
        'threshold',bestThresh,...
        'label',queryLabel,...
        'tpIndices',TPIndices,...
        'fpIndices',FPIndices);
    dataDict = [dataDict; dictEntry];
    
    % experimental var -- might be too optimistic
    %{
    avgTP_OVER_LENGTHS = 0;
    for i=1:length(dataDict)
        temp = dataDict(i).length - startLen;
        temp = (temp/stepLen) + 1;
        avgTP_OVER_LENGTHS = avgTP_OVER_LENGTHS + estTotalTPs(temp); 
    end
    avgTP_OVER_LENGTHS = avgTP_OVER_LENGTHS / length(dataDict);
    %}
    
    avgTP_OVER_LENGTHS = estTotalTPs(1);
    
    [dictIndices,newF1,numClassTP,numClassFP,indLengths] = ...
        evalDataDict(data,dataDict,bounds,boundLabels,avgTP_OVER_LENGTHS);
    
    newF1
    cumulativeTPs = [cumulativeTPs; numClassTP];
    cumulativeFPs = [cumulativeFPs; numClassFP];
end






totalTime = toc(a);