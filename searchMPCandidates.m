function [candidateIndices] = ...
    searchMPCandidates(mpData,matrixProfile,dataDict,...
        startLen,stepLen,endLen,k)
% Searches the matrix profile against the data dictionary to find
% candidates that are dissimilar to the dictionary entries

concatEntries = [];
concatIndices = [];
for i=1:length(dataDict)
    concatEntries = [concatEntries; dataDict(i).query];
    if isempty(concatIndices)
        concatIndices = [1 length(concatEntries)];
    else
        indexPair = [concatIndices(end,2)+1 length(concatEntries)];
        concatIndices = [concatIndices; indexPair];
    end
    
    % Remove entries from matrix profile
    dictInd = dataDict(i).queryIndex;
    dictLen = dataDict(i).length;
    bottomHalf = dictInd-floor(dictLen/2);
    upperHalf = dictInd+floor(dictLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(matrixProfile)
        upperHalf = length(matrixProfile);
    end
    matrixProfile(dictInd:upperHalf) = inf;
    matrixProfile(bottomHalf:dictInd) = inf; 
end

candidateIndices = [];
while (length(candidateIndices) < k)
    % Pick a candidate and add exclusion zone
    [val,ind] = min(matrixProfile);
    
    if val == inf
        break;
    end
    
    % begin comparing query to dictionary
    skipCandidate = 0;
    for subLen=startLen:stepLen:endLen
        if subLen > length(concatEntries) || isempty(concatEntries) || isempty(dataDict)
            break;
        elseif length(dataDict) == 1
            query = mpData(ind:ind+subLen-1);
            dp = findNN([mean(concatEntries); concatEntries],smooth(query));
            if dp < dataDict(1).threshold
                skipCandidate = 1;
                break;
            end
        else
            query = mpData(ind:ind+subLen-1);
            dp = findNN(concatEntries,smooth(query));
            for i=1:length(dataDict)-1
                % if "too similar"
                if subLen == dataDict(i).length && dp(concatIndices(i,1)) < dataDict(i).threshold
                    skipCandidate = 1;
                    break;
                end
            end
        end
        
        if skipCandidate
           break;
        end
    end
    
    bottomHalf = ind-floor(startLen/2);
    upperHalf = ind+floor(startLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(matrixProfile)
        upperHalf = length(matrixProfile);
    end
    matrixProfile(ind:upperHalf) = inf;
    matrixProfile(bottomHalf:ind) = inf;
    
    
    if skipCandidate
        continue;
    else
       candidateIndices = [candidateIndices; ind];
    end
end


end

