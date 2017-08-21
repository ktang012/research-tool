function [] = plotDictTemplates(handle,dataDict)
% Plots dictionary templates in dataDict
cla(handle,'reset');
for i=1:length(dataDict)
    plot(handle,...
        [1:length(dataDict(i).template)],dataDict(i).template);
    hold(handle,'on');
end
hold(handle,'off');


end

