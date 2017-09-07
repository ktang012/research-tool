function [] = plotDataRegions(handle,data,regions)
% Plots the data and regions
L = get(gca,{'xlim','ylim'}); 
cla(handle);
if exist('regions','var')
    white = [1 1 1];
    for i=1:size(regions,1)
        area(handle,...
            regions(i,:), [10 10], 'FaceColor', white, ...
            'LineStyle', ':');
        hold(handle,'on');
    end
end
plot(handle,data);
zoom reset;
set(gca,{'xlim','ylim'},L);
hold(handle,'off');

end

