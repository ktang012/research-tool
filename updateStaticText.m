function [] = updateStaticText(handle,textBox,isUpToDate)
% Updates data and dictTemplates static text
if ~isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data (Plot is NOT up to date with dictionary)');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Dictionary Templates (Plot is NOT up to date with data)');
    end
elseif isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data (Plot is up to date with dictionary)');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Dictionary Templates (Plot is up to date with data)');
    end
else
    errordlg('Error with updateStaticText: isUpToDate value');
end

end

