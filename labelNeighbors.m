function [labels] = labelNeighbors(neighbors,subLen,regions,regionLabels)
% Labels neighbors
labels = [];
for i=1:length(neighbors)
   neighbor = neighbors(i);
   foundLabel = 0;
   for j=1:length(regionLabels)
       if neighbor >= regions(j,1) && neighbor+subLen-1 <= regions(j,2)
           labels = [labels; regionLabels(j)];
           foundLabel = 1;
           break;
       end
   end
   
   % Try again with lower standards if it doesn't work out
   if ~foundLabel
       for j=1:length(regionLabels)
           if neighbor >= regions(j,1) - subLen/4 && neighbor+subLen-1 <= regions(j,2) + subLen/4
               labels = [labels; regionLabels(j)];
               foundLabel = 1;
               break;
           end
       end
   end
   
   % It's long gone
   if ~foundLabel
       labels = [labels; -1];
   end
   
end
end

