function [] = plotNNs(data, dataDict, distanceProfile, bounds, boundLabels, queryLabel)
% Plots the time series sequence and highlights the query and motifs
legendNames = {};
legendNames{1} = 'Data';
legendNames{2} = 'Query';

figure;
%% plot bounds
subplot(4,1,1);
if size(bounds,2) > 1
    white = [1 1 1];
    for i=1:size(bounds,1)
       area(bounds(i,:), [10 10], 'FaceColor', white, ...
            'LineStyle', ':');
       hold on;
    end
end
plot(data, 'LineWidth', 1);


hold on;

%% highlight NNs
for i=1:length(dataDict)
    for j=1:length(dataDict(i).tpIndices)
        plot(dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1, ...
            data(dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1), ...
            'LineWidth', 3);
        hold on;
    end
    for j=1:length(dataDict(i).fpIndices)
        plot(dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1, ...
            data(dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1), ...
            'LineWidth', 3);
        hold on;
    end
end
title('Data');

%% plot data annotation -- first create the annotation
labelAnnotations = [];
for i=1:length(boundLabels)
    if boundLabels(i) == 1
        l = ones(bounds(i,2)-bounds(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    else
        l = zeros(bounds(i,2)-bounds(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    end
end
subplot(4,1,2);
plot(labelAnnotations, 'LineWidth',3);

%% plot DP
if distanceProfile ~= 0
    subplot(4,1,3);
    plot(distanceProfile);
    title('Distance Profile');
end

%% plot entries
for i=1:length(dataDict)
    subplot(4,1,4);
   plot([1:length(dataDict(i).query)],dataDict(i).query);
   hold on;
end

title('Dictionary Queries');


end

