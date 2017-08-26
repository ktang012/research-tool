function [] = plotDataRegions(handle,data,regions)
% Plots the data and regions
cla(handle,'reset');
white = [1 1 1];
for i=1:size(regions,1)
    area(handle,...
        regions(i,:), [10 10], 'FaceColor', white, ...
        'LineStyle', ':');
    hold(handle,'on');
end
plot(handle,data);
hold(handle,'off');

end

