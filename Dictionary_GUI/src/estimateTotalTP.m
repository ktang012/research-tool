function [estTotalTPs] = estimateTotalTP(data,queryIndices,candidateData,queryLabel,bounds,boundLabels,startLen,stepLen,endLen)
% Estimates the totalTP for each candidate at each length step
% Sample of expected total TPs at each sublength

% Note to self: This is a poorly designed function
totalTPs = [];
if length(queryIndices) > 10
    k = 10;
else
    k = length(queryIndices);
end

for i=1:k
    totalTPsCol = [];
    for subLen=startLen:stepLen:endLen
        if queryIndices(i) + subLen - 1 > length(candidateData)
           break; 
        end
        
        candidate = candidateData(queryIndices(i):queryIndices(i)+subLen-1);
        dp = findNN(data,smooth(candidate));
        nnIndices = findRangeNNs(dp,subLen,inf);
        labels = labelNeighbors(nnIndices,subLen,bounds,boundLabels);
        totalTP = sum(labels == queryLabel);
        totalTPsCol = [totalTPsCol; totalTP];
    end
    totalTPs = [totalTPs totalTPsCol];
end
estTotalTPs = round(sum(totalTPs,2)./k);
end

