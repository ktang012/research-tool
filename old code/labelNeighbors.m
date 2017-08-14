function [labels] = labelNeighbors(neighbors,subLen,bounds,boundLabels)
% Labels neighbors
labels = [];
for i=1:length(neighbors)
   neighbor = neighbors(i);
   for j=1:length(boundLabels)
       if neighbor >= bounds(j,1) && neighbor+subLen-1 <= bounds(j,2)
           labels = [labels; boundLabels(j)];
       end
   end
    
end
end

