function [bestT,bestFscore,splitIndex,nnIndices,nnLabels,distances,F1s,precisions,recall] = ...
    findBestThreshold2(dp,subLen,queryLabel, bounds,boundLabels,...
        baseTotalTP,cumulativeTP,cumulativeFP,weight)
% Iteratively finds threshold in dp and picks best one based on F1 score
% Can weigh each prediction depending on length of query

nnIndices = [];
distances = [];
nnLabels = [];
precisions = [];
tpCount = [];

% Once we finish finding all neighbors, we can finally compute the F1 score
% Keep track of precision until then

% Discard self-match
[val,ind] = min(dp);
if val == 0
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
end

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
        
        label = labelNeighbors(ind,subLen,bounds,boundLabels);
        
        nnLabels = [nnLabels; label];
        numPredictions = length(nnIndices);
        
        tp = (sum(nnLabels == queryLabel)) + cumulativeTP;
        fp = (numPredictions - tp) + cumulativeFP;
        
        
        tpCount = [tpCount; tp];
        p = tp / (tp + fp);
        precisions = [precisions; p];
        
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
        
    else
        break;
    end
end

recall = tpCount ./ baseTotalTP;

beta = 0.8;
Fscore = F_betaScore(precisions,recall,beta);

[bestFscore, ind] = max(Fscore);
splitIndex = ind;

if length(distances) == ind
    bestT = distances(ind);
else
    bestT = (distances(ind) + distances(ind+1)) / 2;
end


end



