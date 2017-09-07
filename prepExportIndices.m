function [indices] = prepExportIndices(dataDict, selectedTemplateIndex, flags, dataHasLabels)
% Returns a matrix for turning into a text file
% Flags(1) is ordered/unordered
% Flags(2) is correct indices
% Flags(3) is incorrect indices
% correct == NaN if the data is unlabelled
indices = [];

if selectedTemplateIndex == 1
    if flags(1)
        for i=1:length(dataDict)
            if ~dataHasLabels
                templateIndices = dataDict(i).indices;
                subLen = dataDict(i).length;
                label = dataDict(i).label;
                template = i;
                for j=1:length(templateIndices)
                   indexEntry = [templateIndices(j) subLen label NaN template];
                   indices = [indices; indexEntry];
                end
            else
                if flags(2)
                    tpIndices = dataDict(i).tpIndices;
                    subLen = dataDict(i).length;
                    label = dataDict(i).label;
                    correct = 1;
                    template = i;
                    
                    for j=1:length(tpIndices)
                        indexEntry = [tpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
                if flags(3)
                    fpIndices = dataDict(i).fpIndices;
                    subLen = dataDict(i).length;
                    label = dataDict(i).label;
                    correct = 0;
                    template = i;
                    for j=1:length(fpIndices)
                        indexEntry = [fpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
            end
        end
    else
        for i=1:length(dataDict)
            if ~dataHasLabels
                templateIndices = dataDict(i).unorderIndices;
                subLen = dataDict(i).length;
                label = dataDict(i).label;
                template = i;
                for j=1:length(templateIndices)
                    indexEntry = [templateIndices(j) subLen label NaN template];
                    indices = [indices; indexEntry];
                end
            else
                if flags(2)
                    tpIndices = dataDict(i).unorderTPIndices;
                    subLen = dataDict(i).length;
                    label = dataDict(i).label;
                    correct = 1;
                    template = i;
                    for j=1:length(tpIndices)
                        indexEntry = [tpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
                if flags(3)
                    fpIndices = dataDict(i).unorderFPIndices;
                    subLen = dataDict(i).length;
                    label = dataDict(i).label;
                    correct = 0;
                    template = i;
                    for j=1:length(fpIndices)
                        indexEntry = [fpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
            end
        end
    end
else
    if selectedTemplateIndex <= length(dataDict)+1
        k = selectedTemplateIndex - 1;
        
        if flags(1)
            if ~dataHasLabels
                templateIndices = dataDict(k).unorderIndices;
                subLen = dataDict(k).length;
                label = dataDict(k).label;
                template = k;
                for j=1:length(templateIndices)
                    indexEntry = [templateIndices(k) subLen label NaN template];
                    indices = [indices; indexEntry];
                end
            else
                if flags(2)
                    tpIndices = dataDict(k).tpIndices;
                    subLen = dataDict(k).length;
                    label = dataDict(k).label;
                    correct = 1;
                    template = k;
                    
                    for j=1:length(tpIndices)
                        indexEntry = [tpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
                if flags(3)
                    fpIndices = dataDict(k).fpIndices;
                    subLen = dataDict(k).length;
                    label = dataDict(k).label;
                    correct = 0;
                    template = k;
                    for j=1:length(fpIndices)
                        indexEntry = [fpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
            end
        else
            if ~dataHasLabels
                templateIndices = dataDict(k).unorderIndices;
                subLen = dataDict(k).length;
                label = dataDict(k).label;
                template = k;
                for j=1:length(templateIndices)
                    indexEntry = [templateIndices(k) subLen label NaN template];
                    indices = [indices; indexEntry];
                end
            else
                if flags(2)
                    tpIndices = dataDict(k).unorderTPIndices;
                    subLen = dataDict(k).length;
                    label = dataDict(k).label;
                    correct = 1;
                    template = k;
                    
                    for j=1:length(tpIndices)
                        indexEntry = [tpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
                if flags(3)
                    fpIndices = dataDict(k).unorderFPIndices;
                    subLen = dataDict(k).length;
                    label = dataDict(k).label;
                    correct = 0;
                    template = k;
                    for j=1:length(fpIndices)
                        indexEntry = [fpIndices(j) subLen label correct template];
                        indices = [indices; indexEntry];
                    end
                end
            end
        end
    else
        disp('Error with selectedTemplateIndex in prepExportIndices');
    end
end

end



