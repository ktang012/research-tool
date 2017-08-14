function [newDP] = removeDPNeighbors(dp,indices,predTPLengths)
% Removes neighbors that are classified by entries in dataDict
% from the candidate's distance profile
% Should I remove only if it is not infinity?
if ~isempty(indices)
    for i=1:length(indices)
        ind = indices(i);
        if 1 %dp(ind) ~= inf
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
end
newDP = dp;

end

