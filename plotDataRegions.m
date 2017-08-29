function [] = plotDataRegions(handle,data,regions)
% Plots the data and regions
ax = gca;
L = get(gca,{'xlim','ylim'}); 
cla(handle);
white = [1 1 1];
for i=1:size(regions,1)
    area(handle,...
        regions(i,:), [10 10], 'FaceColor', white, ...
        'LineStyle', ':');
    hold(handle,'on');
end
plot(handle,data);
zoom reset;
set(gca,{'xlim','ylim'},L);
hold(handle,'off');

end

