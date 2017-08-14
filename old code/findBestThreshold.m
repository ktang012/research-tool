function [bestT,bestF1,splitIndex,nnIndices,nnLabels,distances] = ...
    findBestThreshold(dp,subLen,queryLabel, bounds,boundLabels,...
        estTotalTP,cumulativeTP,cumulativeFP)
% Iteratively finds threshold in dp and picks best one based on F1 score
nnIndices = [];
distances = [];
nnLabels = [];
precisions = [];
tpCount = [];

if nargin <=5
    cumulativeTP = 0;
    cumulativeFP = 0;
end

% Once we finish finding all neighbors, we can finally compute the F1 score
% Keep track of precision until then

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
    if (val ~= inf)
        nnIndices = [nnIndices; ind];
        distances = [distances; val];
        
        for i=1:length(boundLabels)
            label = -1;
            if ind >= bounds(i,1) && ind <= bounds(i,2)
                label = boundLabels(i);
                break;
            end
        end
        
        nnLabels = [nnLabels; label];
        
        predictions = length(nnIndices);
        tp = sum(nnLabels == queryLabel) + cumulativeTP;
        fp = predictions - tp + cumulativeFP;
        
        tpCount = [tpCount; tp];
        p = tp / (tp + fp);
        precisions = [precisions; p];
        
    else
        break;
    end
    
    % Bound checking & applying exclusion zone
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

if nargin <= 5
    estTotalTP = sum(nnLabels == queryLabel);
end

recall = tpCount ./ estTotalTP;
F1 = 2 .* ((precisions) .* recall)./(precisions + recall);
[bestF1, ind] = max(F1);
splitIndex = ind;

if length(distances) == ind
    bestT = distances(ind);
else
    bestT = (distances(ind) + distances(ind+1)) / 2;
end


end

