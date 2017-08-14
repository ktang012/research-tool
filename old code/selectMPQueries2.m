function [queries,queryIndices,distances] = selectMPQueries2(data,dataDict,mp,subLen,k)
% Selects queries from MP based on what we have in our dictionary
% subLen is the length of the candidate queries
% Comparisons are done after smooth(zscore(x))

%dictQueries = [];
fastDictQueries = [];
for i=1:length(dataDict)
    dictQuery = dataDict(i).query;
    dictInd = dataDict(i).queryIndex;
    dictSubLen = dataDict(i).length;
    
    % resample, if needed, and place into matrix for pdist
    if (dictSubLen ~= subLen)
        dictQuery = resample(dictQuery,subLen,dictSubLen);
    end
    %dictQueries = [dictQueries smooth(zscore(dictQuery))];
    fastDictQueries = [fastDictQueries; dictQuery];
    
    % remove entries from matrix profile
    bottomHalf = dictInd-floor(dictSubLen/2);
    upperHalf = dictInd+floor(dictSubLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(mp)
        upperHalf = length(mp);
    end
    mp(dictInd:upperHalf) = inf;
    mp(bottomHalf:dictInd) = inf;   
end

% a column in distances is the distance of all candidates 
% to the ith entry in that column
queryIndices = [];
queries = [];
distances = [];
while (length(queryIndices) < k)
    % Pick a candidate and add exclusion zone
    [val,ind] = min(mp);
    
    if val == inf
        break;
    end
    
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(mp)
        upperHalf = length(mp);
    end
    mp(ind:upperHalf) = inf;
    mp(bottomHalf:ind) = inf;
    
    if ind+subLen-1 > length(data)
        continue;
    end
    
    candidate = data(ind:ind+subLen-1);
    
    % Euclidean
    %{
    E = pdist([smooth(zscore(candidate)) dictQueries]');
    E = squareform(E);
    E = E(1,2:end); % get row of distances of candidate to entries
    %}
    
    if length(dataDict) == 1
        fastDP = findNN([0;fastDictQueries],smooth(candidate(1:end-1)));
        D = fastDP(1);
    else
        % Fast NN -- maybe more representative of thresholds?
        fastDP = findNN([fastDictQueries],smooth(candidate));
        % add index offset to find exact index of start of a dictEntry in
        % the distance profile
        dictDPIndices = cumsum([ones(1,length(dataDict)) * subLen]);
        dictDPIndices = [1 dictDPIndices(1:end-1)];
        D = [];
        for i=1:length(dataDict)
            D = [D; fastDP(dictDPIndices(i))];
        end
    end

    discardCandidate = 0;
    
    drow = [];
    for j=1:length(D)
        dist = D(j);
        drow = [drow dist];
        if D(j) <= dataDict(j).threshold * 1.25
            discardCandidate = 1;
            break;
        end
    end
    
    if ~discardCandidate
        queries = [queries candidate];
        queryIndices = [queryIndices; ind];
        distances = [distances; drow];
    end
    
end


end

