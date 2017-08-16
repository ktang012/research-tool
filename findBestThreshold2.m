%{
function [bestT,bestFscore] = ...
    findBestThreshold2(distanceProfile,subLen,targetLabel,regions,regionLabels,F_beta,...
        estTotalTPs,cumulativeTPCount,cumulativeFPCount)
% Iteratively finds threshold in dp and picks best one based on F score
% Can weigh each prediction depending on length of query
nnLabels = [];
nnIndices = [];
precisions = [];
tpCount = [];
distances = [];

% Once we finish finding all neighbors, we can finally compute the Fscore
% Keep track of precision until then

% Discard self-match
[val,ind] = min(distanceProfile);
if val == 0
    % Bound checking
    bottomHalf = ind-floor(subLen/2);
    upperHalf = ind+floor(subLen/2);
    if bottomHalf < 0
        bottomHalf = 1;
    elseif upperHalf > length(distanceProfile)
        upperHalf = length(distanceProfile);
    end
    distanceProfile(ind:upperHalf) = inf;
    distanceProfile(bottomHalf:ind) = inf;
end

while(1)
    [val,ind] = min(distanceProfile);
    if (val ~= inf)
        nnIndices = [nnIndices; ind];
        label = labelNeighbors(ind,subLen,regions,regionLabels);
        nnLabels = [nnLabels; label];
        distances = [distances; val];
        numPredictions = length(nnIndices);
        
        tp = (sum(nnLabels == targetLabel)) + cumulativeTPCount;
        fp = (numPredictions - tp) + cumulativeFPCount;

        tpCount = [tpCount; tp];
        p = tp / (tp + fp);
        precisions = [precisions; p];
        
        % Bound checking & applying exclusion zone
        bottomHalf = ind-floor(subLen/2);
        upperHalf = ind+floor(subLen/2);
        if bottomHalf <= 0
            bottomHalf = 1;
        elseif upperHalf > length(distanceProfile)
            upperHalf = length(distanceProfile);
        end
        distanceProfile(ind:upperHalf) = inf;
        distanceProfile(bottomHalf:ind) = inf;
        
    else
        break;
    end
end

recall = tpCount ./ estTotalTPs;

Fscores = F_betaScore(precisions,recall,F_beta);

[bestFscore, bestInd] = max(Fscores);

% Edge case if the best threshold split is at the end...
if length(distances) == bestInd
    bestT = distances(bestInd);
else
    bestT = (distances(bestInd) + distances(bestInd+1)) / 2;
end


end
%}

function [bestT,bestFscore] = ...
    findBestThreshold2(dp,subLen,queryLabel, bounds,boundLabels,F_beta,...
        baseTotalTP,cumulativeTP,cumulativeFP)
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
Fscore = F_betaScore(precisions,recall,F_beta);

[bestFscore, ind] = max(Fscore);
splitIndex = ind;

if length(distances) == ind
    bestT = distances(ind);
else
    bestT = (distances(ind) + distances(ind+1)) / 2;
end


end



