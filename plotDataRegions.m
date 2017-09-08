function [] = plotDataRegions(handle,data,regions)
% Plots the data and regions
L = get(gca,{'xlim','ylim'}); 
cla(handle);

if exist('regions','var')
    maxVal = ceil(max(data)) * 2;
    minVal = ceil(min(data)) * 2;
    white = [1 1 1];
    for i=1:size(regions,1)
        area(handle,...
            regions(i,:), [minVal maxVal; minVal maxVal], 'FaceColor', white, ...
            'LineStyle', ':');
        hold(handle,'on');
    end
end
plot(handle,data);
zoom reset;
set(gca,{'xlim','ylim'},L);
hold(handle,'off');

end

