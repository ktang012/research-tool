function [] = plotNNs2(data, indices, indLengths, bounds, boundLabels, dataDict)
% Plots the time series sequence and highlights the query and motifs
legendNames = {};
legendNames{1} = 'Data';
legendNames{2} = 'Query';

figure;
%% plot bounds
subplot(3,1,1);
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
for i=1:length(indices)
    if indices(i)+indLengths(i)-1 > length(data)
        continue;
    end
    plot(indices(i):indices(i)+indLengths(i)-1, data(indices(i):indices(i)+indLengths(i)-1), ...
        'LineWidth',3);
    hold on;
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
subplot(3,1,2);
plot(labelAnnotations, 'LineWidth',3);

%% plot entries
for i=1:length(dataDict)
    subplot(3,1,3);
   plot([1:length(dataDict(i).query)],dataDict(i).query);
   hold on;
end

title('Dictionary Queries');


end

