function [] = plotDictTemplates(handle,dataDict,lineWidth)
% Plots dictionary templates in dataDict
if nargin < 3
    lineWidth = 1.5;
end

cla(handle);
for i=1:length(dataDict)
    plot(handle,...
        [1:length(dataDict(i).template)],dataDict(i).template,...
        'LineWidth',lineWidth);
    hold(handle,'on');
end
hold(handle,'off');


end

