function [] = updateListboxTemplates(myHandle,dataDict)
% Set list box content and selection
set(myHandle,'String',[]);
set(myHandle,'Value',[]);

templateList = {};
templateList{1} = 'All templates';
for i=1:length(dataDict)
    templateInd = num2str(i);
    templateLabel = num2str(dataDict(i).label);
    threshold = num2str(dataDict(i).threshold);
    templateLen = num2str(dataDict(i).length);
    templateString = strcat('Template ',templateInd,...
        '(',templateLabel,'), t=',threshold,', length=',templateLen);
    templateList{i+1} = templateString;
end
set(myHandle,'String',templateList);
set(myHandle,'Value',1);
end

