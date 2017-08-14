function [newMP] = removeMPNeighbors(mp,mpNNIndices,subLen)
% Removes neighbors found by the query from the original matrix profile
for i=1:length(mpNNIndices)
   ind = mpNNIndices(i);
   
   % remove entries from matrix profile
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

newMP = mp;

end

