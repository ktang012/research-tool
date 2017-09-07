function [] = plotDictNeighbors(handle,flags,data,dataDict,dataHasLabels)
% Plots to dictNeighbors based on flag configuration and input dataDict
% flags is a 3x1 vector, where flags(1) is for in order or out of order
% neighbor evaluation. flags(2) is to plot TPs, flags(3) is to plot FPs
if length(flags) == 3
    if flags(1) == 1
        for i=1:length(dataDict)
            subLen = dataDict(i).length;
            indices = [];
            if dataHasLabels
                if flags(2) == 1
                    indices = [indices; dataDict(i).tpIndices];
                end
                if flags(3) == 1
                    indices = [indices; dataDict(i).fpIndices];
                end
                pl
            else
                indices = [indices; dataDict(i).indices];
            end
            plotNeighbors(handle,data,indices,subLen);
            hold(handle,'on');
        end
    elseif flags(1) == 0
        for i=1:length(dataDict)
            subLen = dataDict(i).length;
            indices = [];
            if dataHasLabels
                if flags(2) == 1
                    indices = [indices; dataDict(i).unorderTPIndices];
                end
                if flags(3) == 1
                    indices = [indices; dataDict(i).unorderFPIndices];
                end
            else
                indices = [indices; dataDict(i).unorderIndices];
            end
            plotNeighbors(handle,data,indices,subLen);
            hold(handle,'on');
        end
    end
    hold(handle,'off');
else
    errordlg('Error with plotDictNeighbor flags');
end
end

