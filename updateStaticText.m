function [] = updateStaticText(handle,textBox,isUpToDate)
% Updates data and dictTemplates static text
if ~isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Templates');
    end
elseif isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data (Updated)');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Templates (Updated)');
    end
else
    errordlg('Error with updateStaticText: isUpToDate value');
end

end

