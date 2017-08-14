function [queryIndices,queries,distances] = selectMPQueries(data,dictIndices,thresholds,subLen,mp,k)
% Not generalized... prototype function

% Add exclusion zone to all entries
for i=1:length(dictIndices)
    ind = dictIndices(i);
    
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(mp)
        upperHalf = length(mp);
    end
    mp(ind:upperHalf) = inf;
    mp(bottomHalf:ind) = inf;   
end

% When learning query lengths, use resample() to candidate subLen
queryIndices = [];
queries = [];
distances = [];
for i=1:k
    % Pick a candidate and add exclusion zone
    [~,ind] = min(mp);
    candidate = data(ind:ind+subLen-1);
    
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(mp)
        upperHalf = length(mp);
    end
    mp(ind:upperHalf) = inf;
    mp(bottomHalf:ind) = inf;
    
    % Assumes all entries are of equal length (will need to resample
    % to length of candidate otherwise)
    % Also this does not need to be nested...
    dictQueries = [];
    for j=1:length(dictIndices)
        % Store as row vector, znormalize (should remove because...?)
        % Something out of phase...? (try to use DTW?)
        dictQuery = (data(dictIndices(j):dictIndices(j)+subLen-1));
        dictQueries = [dictQueries; zscore(dictQuery)'];
    end
    
    D = squareform(pdist([zscore(candidate)'; dictQueries]));
    D = D(1,2:end); % get distances of candidate to entries
    
    discardCandidate = 0;
    for j=1:length(D)
        ind;
        dist = D(j);
        if D(j) < thresholds(j) * 2
            discardCandidate = 1;
            break;
        end
    end
    
    if ~discardCandidate
        queries = [queries candidate];
        queryIndices = [queryIndices; ind];
        distances = [distances; dist];
    end
    
end


end

