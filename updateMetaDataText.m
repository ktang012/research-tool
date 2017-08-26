function [] = updateMetaDataText(handles,selectedTemplateIndex,dataDict)
% Displays precision, num of TPs,FPs, num unorder TPs,FPs
if selectedTemplateIndex == 1
    numTP = 0;
    numFP = 0;
    for i=1:length(dataDict)
        tp = length(dataDict(i).tpIndices);
        fp = length(dataDict(i).fpIndices);
        numTP = numTP + tp;
        numFP = numFP + fp;
    end
    precision = numTP/(numTP+numFP);
    
    precisionStringVal = strcat('Precision: ', num2str(precision));
    numTPStringVal = strcat('True positives: ', num2str(numTP));
    numFPStringVal = strcat('False positives: ',num2str(numFP));
elseif length(dataDict)+1 >= selectedTemplateIndex
    % display both ordered and unordered
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
end
set(handles.staticText_precision,'String',precisionStringVal);
set(handles.staticText_numTP,'String',numTPStringVal);
set(handles.staticText_numFP,'String',numFPStringVal);
end

