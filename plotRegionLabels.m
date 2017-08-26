function [] = plotRegionLabels(handle,regions,regionLabels)
% Plots region labels
cla(handle,'reset');
labelAnnotations = [];
for i=1:length(regionLabels)
    if regionLabels(i) == 1
        l = ones(regions(i,2)-regions(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    else
        l = zeros(regions(i,2)-regions(i,1)+1,1);
        labelAnnotations = [labelAnnotations; l];
    end
end
plot(handle, labelAnnotations);

end

