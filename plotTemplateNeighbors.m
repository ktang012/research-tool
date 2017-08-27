function [] = plotTemplateNeighbors(handle,flags,data,template,dispNumNeighbors)
% Plots a selected template from the dictionary against respective
% neighbors
% flags(1) == 1 is ordered indices
% TODO: If flags(2) and flags(3) then plot color blue and red, else default
% colors
cla(handle,'reset');
if length(flags) == 3
    if flags(1)
        if flags(2) && flags(3)
            colors = [0 0 1];
            if dispNumNeighbors > length(template.tpIndices)
                tpLimit = length(template.tpIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            for i=1:tpLimit
                tp = template.tpIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            colors = [1 0 0];
            if dispNumNeighbors > length(template.fpIndices)
                fpLimit = length(template.fpIndices);
            else
                fpLimit = dispNumNeighbors;
            end
            for i=1:fpLimit
                fp = template.fpIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
        elseif flags(2)
            if dispNumNeighbors > length(template.tpIndices)
                tpLimit = length(template.tpIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            for i=1:tpLimit
                tp = template.tpIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)));
                hold(handle,'on');
            end
        elseif flags(3)
            if dispNumNeighbors > length(template.fpIndices)
                fpLimit = length(template.fpIndices);
            else
                fpLimit = dispNumNeighbors;
            end
            for i=1:fpLimit
                fp = template.fpIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)));
                hold(handle,'on');
            end
        end
    else
        if flags(2) && flags(3)
            colors = [0 0 1];
            if dispNumNeighbors > length(template.unorderTPIndices)
                tpLimit = length(template.unorderTPIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            colors = [1 0 0];
            if dispNumNeighbors > length(template.unorderFPIndices)
                fpLimit = length(template.unorderFPIndices);
            else
                fpLimit = dispNumNeighbors;
            end
            for i=1:fpLimit
                fp = template.unorderFPIndices(i);
                plot(handle,zscore(data(fp:fp+template.length-1)),...
                    'Color',colors);
                hold(handle,'on');
            end
            
        elseif flags(2)
            if dispNumNeighbors > length(template.unorderTPIndices)
                tpLimit = length(template.unorderTPIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                plot(handle,zscore(data(tp:tp+template.length-1)));
                hold(handle,'on');
            end
        elseif flags(3)
            if dispNumNeighbors > length(template.unorderFPIndices)
                fpLimit = length(template.unorderFPIndices);
            else
                fpLimit = dispNumNeighbors;
            end
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

