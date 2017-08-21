function [] = plotDataRegions(handles,data,regions)
% Plots the data and regions
cla(handles,'reset');
white = [1 1 1];
for i=1:size(regions,1)
    area(handles,...
        regions(i,:), [10 10], 'FaceColor', white, ...
        'LineStyle', ':');
    hold(handles,'on');
end
plot(handles,data);
hold(handles,'on');

end

