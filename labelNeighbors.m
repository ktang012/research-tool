function [labels] = labelNeighbors(neighbors,subLen,bounds,boundLabels)
% Labels neighbors
labels = [];
foundLabel = 0;
for i=1:length(neighbors)
   neighbor = neighbors(i);
   for j=1:length(boundLabels)
       if neighbor >= bounds(j,1) - subLen/4 && neighbor+subLen-1 <= bounds(j,2) + subLen/4
           labels = [labels; boundLabels(j)];
           foundLabel = 1;
           break;
       end
   end
   
   if ~foundLabel
       labels = [labels; -1];
   end
   
end
end

