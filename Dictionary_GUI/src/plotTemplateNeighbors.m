function [] = plotTemplateNeighbors(handle,flags,data,template,...
    dispNumNeighbors,dataHasLabels)
% Plots a selected template from the dictionary against respective
% neighbors
% flags(1) == 1 is ordered indices
% If flags(2) and flags(3) then plot color blue and red, else default
% colors
cla(handle);
if length(flags) == 3
    if flags(1)
        if ~dataHasLabels
            neighborLimit = min(length(template.indices), dispNumNeighbors);
            for i=1:neighborLimit
                ind = template.indices(i);
                plot(handle,zscore(data(ind:ind+template.length-1)));
                hold(handle,'on');
            end 
        elseif flags(2) && flags(3) && dataHasLabels
            colors = [0 0 1];
            tpLimit = min(length(template.tpIndices), dispNumNeighbors);
            for i=1:tpLimit
                tp = template.tpIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            colors = [1 0 0];
            fpLimit = min(length(template.fpIndices), dispNumNeighbors);
            for i=1:fpLimit
                fp = template.fpIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
        elseif flags(2) && dataHasLabels
            tpLimit = min(length(template.tpIndices), dispNumNeighbors);
            for i=1:tpLimit
                tp = template.tpIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)));
                hold(handle,'on');
            end
        elseif flags(3) && dataHasLabels
            fpLimit = min(length(template.fpIndices), dispNumNeighbors);
            for i=1:fpLimit
                fp = template.fpIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)));
                hold(handle,'on');
            end
        end
    else
        if ~dataHasLabels
            neighborLimit = min(length(template.unorderIndices), dispNumNeighbors);
            for i=1:neighborLimit
                ind = template.indices(i);
                plot(handle,zscore(data(ind:ind+template.length-1)));
                hold(handle,'on');
            end 
        elseif flags(2) && flags(3) && dataHasLabels
            colors = [0 0 1];
            tpLimit = min(length(template.unorderTPIndices), dispNumNeighbors);
            fpLimit = min(length(template.unorderFPIndices), dispNumNeighbors);
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            colors = [1 0 0];
            for i=1:fpLimit
                fp = template.unorderFPIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            
        elseif flags(2) && dataHasLabels
            tpLimit = min(length(template.unorderTPIndices), dispNumNeighbors);
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)));
                hold(handle,'on');
            end
        elseif flags(3) && dataHasLabels
            fpLimit = min(length(template.unorderFPIndices), dispNumNeighbors);
            for i=1:fpLimit
                fp = template.unorderFPIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)));
                hold(handle,'on');
            end
        end
    end
    plot(handle,template.template,'LineWidth',4,'Color','k');
    hold(handle,'off');
else
    errordlg('Error with plotTemplateNeighbor flags');
end

