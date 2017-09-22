function [nnIndices, distances, newDP] = findRangeNNs(dp, subLen, t)
% Given distance profile dp and query length subLen
% Returns the indices of all neighbors less than or equal to t
nnIndices = [];
distances = [];
% Discard self-match
[~,ind] = min(dp);
% Bound checking
bottomHalf = ind-floor(subLen/2);
upperHalf = ind+floor(subLen/2);
if bottomHalf < 0
    bottomHalf = 1;
elseif upperHalf > length(dp)
    upperHalf = length(dp);
end
dp(ind:upperHalf) = inf;
dp(bottomHalf:ind) = inf;

while(1)
    [val,ind] = min(dp);
    if (val <= t && val ~= inf)
        nnIndices = [nnIndices; ind];
        distances = [distances; val];
    else
        break;
    end
    
    % Bound checking
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf <= 0
        bottomHalf = 1;
    elseif upperHalf > length(dp)
        upperHalf = length(dp);
    end
    dp(ind:upperHalf) = inf;
    dp(bottomHalf:ind) = inf;
end
newDP = dp;

end

