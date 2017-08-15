function [newDP] = removeDPNeighbors(dp,indices,predTPLengths)
% Removes neighbors that are classified by entries in dataDict
% from the candidate's distance profile

if ~isempty(indices)
    for i=1:length(indices)
        ind = indices(i);

        bottomHalf = ind-floor(predTPLengths(i)/2);
        upperHalf = ind+floor(predTPLengths(i)/2);
        if bottomHalf < 0
            bottomHalf = 1;
        elseif upperHalf > length(dp)
            upperHalf = length(dp);
        end
        dp(ind:upperHalf) = inf;
        dp(bottomHalf:ind) = inf; 
    end
end
newDP = dp;

end

