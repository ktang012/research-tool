function [] = plotRegionLabels(handle,regions,regionLabels)
% Plots region labels
cla(handle);
hold(handle,'on');
labelAnnotations = [];
%{
for i=1:length(regionLabels)
    if regionLabels(i) == 2
        l = ones(regions(i,2)-regions(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    else
        l = zeros(regions(i,2)-regions(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    end
end
%}
for i=1:length(regionLabels)
   l = ones(regions(i,2)-regions(i,1)+1,1) * regionLabels(i);
   labelAnnotations = [labelAnnotations; l];
end



plot(handle, labelAnnotations);
hold(handle,'off');
end

