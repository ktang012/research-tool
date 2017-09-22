function [] = updateStaticText(handle,textBox,isUpToDate)
% Updates data and dictTemplates static text
if ~isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Templates');
    end
    if strcmp(textBox, 'regionLabel')
        set(handle.staticText_regionLabels,'String','Region Labels (no labels)');
    end
    if strcmp(textBox, 'learning')
        set(handle.staticText_GUIState,'String','');
    end
    if strcmp(textBox, 'plottingData')
        set(handle.staticText_GUIState,'String','');
    end
elseif isUpToDate
    if strcmp(textBox,'data')
        set(handle.staticText_data,'String','Data (Updated)');
    end
    if strcmp(textBox,'dictTemplate')
        set(handle.staticText_dictTemplates,'String','Templates (Updated)');
    end
    if strcmp(textBox,'regionLabel')
        set(handle.staticText_regionLabels,'String','Region Labels');
    end
    if strcmp(textBox, 'learning')
        set(handle.staticText_GUIState,'String','Learning in Progress...');
    end
    if strcmp(textBox, 'plottingData')
        set(handle.staticText_GUIState,'String','Plotting Data...'); 
    end
else
    errordlg('Error with updateStaticText: isUpToDate value');
end

end

