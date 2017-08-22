function [] = plotTemplateNeighbors(handle,flags,data,template,dispNumNeighbors)
% Plots a selected template from the dictionary against respective
% neighbors
cla(handle,'reset');
if length(flags) == 3
    if flags(1)
       if flags(2)
           if dispNumNeighbors > length(template.tpIndices)
               tpLimit = length(template.tpIndices);
           else
               tpLimit = dispNumNeighbors;
           end
           blueVal = 1;
           for i=1:tpLimit
               tp = template.tpIndices(i);
               
               if blueVal - 0.05 <= 0
                   blueVal = 1;
               end
               
               plot(zscore(data(tp:tp+template.length-1)),'Color',[0 0 blueVal]);
               hold(handle,'on');
               blueVal = blueVal - 0.06;
           end
       end
       if flags(3)
           if dispNumNeighbors > length(template.fpIndices)
               fpLimit = length(template.fpIndices);
           else
               fpLimit = dispNumNeighbors; 
           end
           redVal = 1;
           for i=1:fpLimit
               fp = template.fpIndices(i);
               
               if redVal - 0.05 <= 0
                   redVal = 1;
               end
               
               plot(zscore(data(fp:fp+template.length-1)),'Color',[redVal 0 0]);
               hold(handle,'on');
               redVal = redVal - 0.06;
           end
       end
    else
        if flags(2)
            if dispNumNeighbors > length(template.unorderTPIndices)
                tpLimit = length(template.unorderTPIndices);
            else
                tpLimit = dispNumNeighbors;
            end
            blueVal = 1;
            for i=1:tpLimit
                tp = template.unorderTPIndices(i);
                
                if blueVal - 0.05 <= 0
                    blueVal = 1;
                end
                
                plot(zscore(data(tp:tp+template.length-1)),'Color',[0 0 blueVal]);
                hold(handle,'on');
                blueVal = blueVal - 0.06;
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
                
                if redVal - 0.05 <= 0
                    redVal = 1;
                end
                
                plot(zscore(data(fp:fp+template.length-1)),'Color',[redVal 0 0]);
                hold(handle,'on');
                redVal = redVal - 0.06;
            end
        end
    end
    plot(template.template,'LineWidth',4,'Color','k');
    hold(handle,'off');
else
    errordlg('Error with plotTemplateNeighbor flags');
end

