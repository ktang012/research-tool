function [] = plotEntryVsNeighbors(data,dictEntry,tpLimit,fpLimit)
% Plots the dictionary element's subsequence against all of its neighbors
% in a 2 x 1 plot, where the first are the correct predictions and the
% second are the incorrect predictions

if nargin < 3 || tpLimit > length(dictEntry.tpIndices)
   tpLimit = length(dictEntry.tpIndices); 
end

if nargin < 3 || fpLimit > length(dictEntry.fpIndices)
   fpLimit = length(dictEntry.fpIndices); 
end

figure;

% Plot all the correct predictions
subplot(2,1,1);
blueVal = 1;
for i=1:tpLimit
    tp = dictEntry.tpIndices(i);
    
    if blueVal - 0.05 <= 0
        blueVal = 1;
    end
    
    plot(zscore(data(tp:tp+dictEntry.length-1)),'Color',[0 0 blueVal]);
    %plot(zscore(data(tp:tp+dictEntry.length-1)));
    hold on;
    
    blueVal = blueVal - 0.06;
end
% Plot dictionary query
plot(dictEntry.query,'LineWidth',4,'Color','k');
hold on;

% Plot all the incorrect predictions
subplot(2,1,2);
redVal = 1;
for i=1:fpLimit
    fp = dictEntry.fpIndices(i);
    
    if redVal - 0.05 <= 0
        redVal = 1;
    end
    
    plot(zscore(data(fp:fp+dictEntry.length-1)),'Color',[redVal 0 0]);
    %plot(zscore(data(fp:fp+dictEntry.length-1)));
    hold on;
    
    redVal = redVal - 0.06;
end
% Plot dictionary query
plot(dictEntry.query,'LineWidth',4,'Color','k');
hold on;




end

