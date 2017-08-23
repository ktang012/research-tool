function [] = plotTemplateNeighbors(handle,flags,data,template,dispNumNeighbors)
% Plots a selected template from the dictionary against respective
% neighbors
% TODO: If flags(2) and flags(3) then plot color blue and red, else default
% colors
cla(handle,'reset');
if length(flags) == 3
    if flags(1)
       if flags(2)
           if dispNumNeighbors > length(template.tpIndices)
               tpLimit = length(template.tpIndices);
           else
               tpLimit = dispNumNeighbors;
           end
           for i=1:tpLimit
               tp = template.tpIndices(i);
               plot(zscore(data(tp:tp+template.length-1)));
               hold(handle,'on');
           end
       end
       if flags(3)
           if dispNumNeighbors > length(template.fpIndices)
               fpLimit = length(template.fpIndices);
           else
               fpLimit = dispNumNeighbors; 
           end
           for i=1:fpLimit
               fp = template.fpIndices(i);
               plot(zscore(data(fp:fp+template.length-1)));
               hold(handle,'on');
           end
       end
    else
        if flags(2)
            if dispNumNeighbors > length(template.unorderTPIndices)
                tpLimit = length(template.unorderTPIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                plot(zscore(data(tp:tp+template.length-1)));
                hold(handle,'on');
            end
        end
        if flags(3)
            if dispNumNeighbors > length(template.unorderFPIndices)
                fpLimit = length(template.unorderFPIndices);
            else
                fpLimit = dispNumNeighbors;
            end
            redVal = 1;
            for i=1:fpLimit
                fp = template.unorderFPIndices(i);
                plot(zscore(data(fp:fp+template.length-1)));
                hold(handle,'on');
            end
        end
    end
    plot(template.template,'LineWidth',4,'Color','k');
    hold(handle,'off');
else
    errordlg('Error with plotTemplateNeighbor flags');
end

