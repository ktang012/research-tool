function [] = plotNeighbors(handle,data,indices,subLen)
hold(handle,'on');
for i=1:length(indices)
    plot(handle,...
        indices(i):indices(i)+subLen-1,...
        data(indices(i):indices(i)+subLen-1),...
        'LineWidth',3);
    hold(handle,'on');
end

