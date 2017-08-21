function [] = plotDictNeighbors(handle,flags,data,dataDict)
% Plots to dictNeighbors based on flag configuration and input dataDict
% flags is a 3x1 vector, where flags(1) is for in order or out of order
% neighbor evaluation. flags(2) is to plot TPs, flags(3) is to plot FPs
if length(flags) == 3
    if flags(1) == 1
        for i=1:length(dataDict)
            if flags(2) == 1
                plotNeighbors(handle,data,...
                    dataDict(i).tpIndices,dataDict(i).length);
                hold(handle,'on');
            end
            if flags(3) == 1
                plotNeighbors(handle,data,...
                    dataDict(i).fpIndices,dataDict(i).length);
                hold(handle,'on');
            end
        end
    elseif flags(1) == 0
        for i=1:length(dataDict)
            if flags(2) == 1
                plotNeighbors(handle,data,...
                    dataDict(i).unorderTPIndices,dataDict(i).length);
                hold(handle,'on');
            end
            if flags(3) == 1
                plotNeighbors(handle,data,...
                    dataDict(i).unorderFPIndices,dataDict(i).length);
                hold(handle,'on');
            end
        end
    end
    hold(handle,'off');
else
    errordlg('Error with plotDictNeighbor flags');
end
end

