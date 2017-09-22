function [labels] = labelNeighbors(neighbors,subLen,regions,regionLabels)
% Labels neighbors
labels = [];

for i=1:length(neighbors)
   neighbor = neighbors(i);
   foundLabel = 0;
   
   % Exactly falls in region
   for j=1:length(regionLabels)
       if neighbor >= regions(j,1) && neighbor+subLen-1 <= regions(j,2)
           labels = [labels; regionLabels(j)];
           foundLabel = 1;
           break;
       end
   end
   
   if ~foundLabel
       betweenRegionsIndex = (neighbor >= regions(:,1) & neighbor <= regions(:,2));
       % find out which region the neighbor falls in
       [~,betweenRegionsIndex] = max(betweenRegionsIndex);
       betweenRegions = regions(betweenRegionsIndex,:);
       % If more than half falls outside of region...
       if (neighbor + subLen - 1) - betweenRegions(2) > subLen/2
           if  betweenRegionsIndex + 1 > length(regionLabels)
               labels = [labels; regionLabels(betweenRegionsIndex)];
           else
               labels = [labels; regionLabels(betweenRegionsIndex+1)];
           end
           foundLabel = 1;

       else
           labels = [labels; regionLabels(betweenRegionsIndex)];
           foundLabel = 1;


       end
   end
   
   % Should not be -1
   if ~foundLabel
       labels = [labels; -1];
   end
   
end
end

