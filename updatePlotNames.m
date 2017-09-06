function [] = updatePlotNames(handles, textBox, name)
% Update plot names
if strcmp(textBox, 'data')
   set(handles.staticText_dataSetName, 'String', name); 
elseif strcmp(textBox, 'dict')
    if exist('name','var')
        set(handles.staticText_dictName, 'String', name);
    else
        set(handles.staticText_dictName, 'String', 'Unnamed'); 
    end
end


end

