function [bestT,bestF1,splitIndex,nnIndices,nnLabels,distances,F1s,precisions,recall] = ...
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
        %{
        tp = weight * (sum(nnLabels == queryLabel)) + cumulativeTP;
        fp = weight * (predictions - tp) + cumulativeFP;
        %}
        
        %{
        tp = (1/weight) * (sum(nnLabels == queryLabel)) + cumulativeTP;
        fp = (1/weight) * (predictions - tp) + cumulativeFP;
        %}
        
        % for weight * fp, entry length grows as more are added (.775)
        % for 1/weight * tp, entry length is minimum (.82)
        % for no weights, high length to small length (.70)
        
        tp = (sum(nnLabels == queryLabel)) + cumulativeTP;
        fp = (predictions - tp) + cumulativeFP;
        
        
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
    baseTotalTP = sum(nnLabels == queryLabel);
end

recall = tpCount ./ baseTotalTP;
%% 


F1s = 2 .* ((precisions) .* recall)./(precisions + recall);



%F1s =  1.25 .* ((precisions .* recall) ./ ((0.25 .* precisions) + recall));


[bestF1, ind] = max(F1s);
splitIndex = ind;

if length(distances) == ind
    bestT = distances(ind);
else
    bestT = (distances(ind) + distances(ind+1)) / 2;
end


end



