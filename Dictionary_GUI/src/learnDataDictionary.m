function [dataDict, currDictFscore, estTotalTPs, precision, recall] = ...
    learnDataDictionary(data,regions,regionLabels,targetLabel,...
        startLength,stepLength,endLength,F_beta,k,AV_type)

if nargin == 7
    F_beta = 1;
    k = 10;
elseif nargin == 8
    k = 10;
end


if ~iscolumn(data)
    data = data';
end

mpData = [];
concatIndices = [];
for i=1:length(regionLabels)
    if regionLabels(i) == targetLabel
       startInd = regions(i,1);
       endInd = regions(i,2);
       m = data(startInd:endInd);
       c = length(m) + length(mpData);
       concatIndices = [concatIndices; c];
       mpData = [mpData; m];
    end
end

if length(mpData)/20 < startLength
    disp('Warning: input length for matrix profile is too short! Using longest length possible');
    temp_startLength = length(mpData)/20;
else
    temp_startLength = startLength;
end
    
    
[matrixProfile, profileIndex, motifIndex] = interactiveMatrixProfileVer2(mpData,temp_startLength);
if exist('AV_type','var')
    [AV,cmp] = createAnnotationVec(matrixProfile,mpData,startLength,AV_type);
    matrixProfile = cmp;
end

dataDict = [];
prevDictFscore = -1;
currDictFscore = 0;
Fdiff = 0.005;
cumulativeTPCount = 0;
cumulativeFPCount = 0;
estTotalTPs = 0;

while (currDictFscore - Fdiff) > prevDictFscore
    prevDictFscore = currDictFscore;
    candIndices = searchMPCandidates(mpData,matrixProfile,dataDict,...
        startLength,stepLength,endLength,k, concatIndices);
    
    % no more candidates to check
    if isempty(candIndices)
        break;
    end
    
    if estTotalTPs == 0
       estTotalTPs = estimateTotalTP(data,candIndices,mpData,targetLabel,...
           regions,regionLabels,startLength,stepLength,endLength);
       estTotalTPs = estTotalTPs(1);
    end
    
    
    learnedQueries = {}; thresholds = []; Fscores = [];
    for i=1:length(candIndices)
        candIndex = candIndices(i);

        [learnedQuery,t,Fscore] = learnQuery(data,dataDict,...
            candIndex,targetLabel,mpData,F_beta,startLength,stepLength,endLength,...
            regions,regionLabels,estTotalTPs,cumulativeTPCount,cumulativeFPCount);
        
        learnedQueries{i} = learnedQuery;
        thresholds = [thresholds; t];
        Fscores = [Fscores; Fscore];
    end
    
    [bestFscore,bestInd] = max(Fscores);
    bestQuery = learnedQueries{bestInd};
    bestThreshold = thresholds(bestInd);
    
    [dictTPIndices,~,predTPLengths,~] = ...
        getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
    
    distanceProfile = findNN(data,smooth(bestQuery));
    distanceProfile = removeDPNeighbors(distanceProfile,dictTPIndices,predTPLengths);
    nnIndices = findRangeNNs(distanceProfile,length(bestQuery),bestThreshold);
    labels = labelNeighbors(nnIndices,length(bestQuery),regions,regionLabels);
    
    TPIndices = nnIndices(labels == targetLabel);
    FPIndices = nnIndices(labels ~= targetLabel);
    
    dictEntry = struct('query',zscore(bestQuery),...
        'template',zscore(bestQuery),...
        'queryIndex',candIndices(bestInd),...
        'length',length(bestQuery),...
        'threshold',bestThreshold,...
        'label',targetLabel,...
        'tpIndices',TPIndices,...
        'fpIndices',FPIndices);
    dataDict = [dataDict; dictEntry];
    
    [dictIndices,currDictFscore,cumulativeTPCount,cumulativeFPCount,indLengths] = ...
        evalDataDict(data,dataDict,F_beta,regions,regionLabels,estTotalTPs);
    
    currDictFscore;
    
end



end

