function [newMP] = removeMPNeighbors2(data,mp,dataDict)
% Removes neighbors already found by the entries of dataDict from the
% matrix profile computed using data
bounds = [1 length(data)];
boundLabels = dataDict(1).label; % need to change this later
[nnIndices,~,~,predTPLengths] = getClassifiedNeighbors(data,dataDict,bounds,boundLabels);

for j=1:length(nnIndices)
    ind = nnIndices(j);
    subLen = predTPLengths(j);
    % remove entries from matrix profile
    if mp(ind) ~= inf
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
end
newMP = mp;

end

