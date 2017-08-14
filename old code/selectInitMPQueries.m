function [candidates,candIndices] = selectInitMPQueries(data,mp,k,subLen)
% Returns k indices of candidate queries from the matrix profile
candidates = [];
candIndices = [];
while (length(candIndices) < k)
    [val,ind] = min(mp);
    
    if val == inf
        break;
    end
    
    % apply exclusion zone for trivial matches
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf <= 0
        bottomHalf = 1;
    elseif upperHalf > length(mp)
        upperHalf = length(mp);
    end
    mp(ind:upperHalf) = inf;
    mp(bottomHalf:ind) = inf; 
    
    
    if ind-floor(subLen/2) <= 0 || ind+floor(subLen/2) > length(mp)
        continue;
    end
    
    candIndices = [candIndices; ind];
    candidate = data(ind:ind+subLen-1);
    candidates = [candidates candidate];
    
end


end

