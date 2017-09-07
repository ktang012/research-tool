function [] = updateMetaDataText(handles,selectedTemplateIndex,dataDict,dataHasLabels)
% Displays precision, num of TPs,FPs, num unorder TPs,FPs
if selectedTemplateIndex == 1
    if dataHasLabels
        numTP = 0;
        numFP = 0;
        numNeighbors = '--';
        for i=1:length(dataDict)
            tp = length(dataDict(i).tpIndices);
            fp = length(dataDict(i).fpIndices);
            numTP = numTP + tp;
            numFP = numFP + fp;
        end
        precision = numTP/(numTP+numFP);
    else
        precision = '--';
        numTP = '--';
        numFP = '--';
        for i=1:length(dataDict)
            num = length(dataDict(i).indices);
            numNeighbors = numNeighbors + num;
        end
    end
    precisionStringVal = strcat('Precision: ', num2str(precision));
    numTPStringVal = strcat('True positives: ', num2str(numTP));
    numFPStringVal = strcat('False positives: ',num2str(numFP));
    numNeighborsStringVal = strcat('Neighbors: ', num2str(numNeighbors));
elseif length(dataDict)+1 >= selectedTemplateIndex
    % display both ordered and unordered
    if dataHasLabels
        numTP = length(dataDict(selectedTemplateIndex-1).tpIndices);
        numFP = length(dataDict(selectedTemplateIndex-1).fpIndices);
        precision = numTP/(numTP+numFP);
        numUnorderTP = length(dataDict(selectedTemplateIndex-1).unorderTPIndices);
        numUnorderFP = length(dataDict(selectedTemplateIndex-1).unorderFPIndices);
        precisionUnorder = numUnorderTP/(numUnorderTP+numUnorderFP);
        
        precisionStringVal = strcat('Precision: ',num2str(precision),...
            ' (unorder: ',num2str(precisionUnorder),')');
        numTPStringVal = strcat('True positives: ',num2str(numTP),...
            ' (unorder: ',num2str(numUnorderTP),')');
        numFPStringVal = strcat('False positives: ',num2str(numFP),...
            ' (unorder: ',num2str(numUnorderFP),')');
        numNeighborsStringVal = 'Neighbors: --';
    else
        numNeighbors = length(dataDict(selectedTemplateIndex-1).indices);
        numUnorderNeighbors = length(dataDict(sleectedTemplateIndex-1).unorderIndices);
        
        precisionStringVal = 'Precision: --';
        numTPStringVal = 'True positives: --';
        numFPStringVal = 'False positives: --';
        numNeighborsStringVal = strcat('Neighbors: ', num2str(numNeighbors),...
            ' (unorder: ', num2str(numUnorderNeighbors), ')');
    end
end
set(handles.staticText_precision,'String',precisionStringVal);
set(handles.staticText_numTP,'String',numTPStringVal);
set(handles.staticText_numFP,'String',numFPStringVal);
set(handles.staticText_numNeighbors,'String',numNeighborsStringVal);
end

