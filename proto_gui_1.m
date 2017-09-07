function varargout = proto_gui_1(varargin)
% PROTO_GUI_1 MATLAB code for proto_gui_1.fig
%      PROTO_GUI_1, by itself, creates a new PROTO_GUI_1 or raises the existing
%      singleton*.
%
%      H = PROTO_GUI_1 returns the handle to a new PROTO_GUI_1 or the handle to
%      the existing singleton*.
%
%      PROTO_GUI_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTO_GUI_1.M with the given input arguments.
%
%      PROTO_GUI_1('Property','Value',...) creates a new PROTO_GUI_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before proto_gui_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to proto_gui_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help proto_gui_1

% Last Modified by GUIDE v2.5 05-Sep-2017 16:41:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @proto_gui_1_OpeningFcn, ...
    'gui_OutputFcn',  @proto_gui_1_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before proto_gui_1 is made visible.
function proto_gui_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to proto_gui_1 (see VARARGIN)

% Choose default command line output for proto_gui_1
handles.output = hObject;

% if true, then on button_plotDictNeighbors fetch indices for dict
handles.refreshDictNeighbors = 1;

% if 1, then apply to all templates, else apply to the i-1 template
handles.selectedTemplateIndex = 1;

% inf to display all neighbors for a template in template graph
handles.displayNumNeighbors = inf;

% if 1, then the data has labels
handles.dataHasLabels = 0;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes proto_gui_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = proto_gui_1_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in button_importData.
% Loads and plots data and regions
function button_importData_Callback(hObject, eventdata, handles)
% hObject    handle to button_importData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileName = uigetfile('.mat');
if fileName ~= 0
    matFile = load(fileName);
    if isfield(matFile,{'data','regions','regionLabels'});
        handles.data = matFile.data;
        handles.regions = matFile.regions;
        handles.regionLabels = matFile.regionLabels;
        handles.refreshDictNeighbors = 1;
        handles.dataHasLabels = 1;
        % save handles
        guidata(hObject,handles);
        
        % update static text data, dictTemplates to be outdated
        updateStaticText(handles,'data',false);
        updateStaticText(handles,'dictTemplate',false);
        updateStaticText(handles,'regionLabel',true);
        updatePlotNames(handles,'data',fileName);
        
        % Plot the data & region boundaries
        plotDataRegions(handles.graph_dictNeighbors,matFile.data,matFile.regions);
        
        % Plot the region labels
        plotRegionLabels(handles.graph_regionLabels,matFile.regions,matFile.regionLabels);
    elseif isfield(matFile, {'data'})
        % Need to implement data without labels
        handles.data = matFile.data;
        handles.refreshDictNeighbors = 1;
        handles.dataHasLabels = 0;
        handles.regions = [];
        handles.regionLabels = [];
        guidata(hObject,handles);
        
        updateStaticText(handles,'data',false);
        updateStaticText(handles,'dictTemplate',false);
        updateStaticText(handles,'regionLabel',false);
        updatePlotNames(handles,'data',fileName);
        
        plotDataRegions(handles.graph_dictNeighbors, matFile.data);
        cla(handles.graph_regionLabels);
        
    else
        errordlg('File needs fields "data","regions", and "regionLabels."');
    end
end


%% --- Executes on button press in button_plotDictNeighbors.
function button_plotDictNeighbors_Callback(hObject, eventdata, handles)
% hObject    handle to button_plotDictNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputHandles = guidata(hObject);
if ~all(isfield(inputHandles,{'data','regions','regionLabels'}))
    errordlg('Need to input data and parameters before creating dictionary.');
    return;
    
elseif ~isfield(inputHandles,{'dataDict'})
    errordlg('Need to have a dictionary before plotting.');
    return
else
    data = inputHandles.data;
    regions = inputHandles.regions;
    regionLabels = inputHandles.regionLabels;
    dataHasLabels = inputHandles.dataHasLabels;
    
    dataDict = inputHandles.dataDict;
    if ~assertDictFields(dataDict)
        errordlg('Error with dictionary fields.');
        return;
    end;
    
    selectedTemplateIndex = inputHandles.selectedTemplateIndex;
    refreshDictNeighbors = inputHandles.refreshDictNeighbors;
    
    % Plot the data
    
    if dataHasLabels
        plotDataRegions(handles.graph_dictNeighbors,data,regions);
    else
        plotDataRegions(handles.graph_dictNeighbors,data,regions);
    end
    
    hold(handles.graph_dictNeighbors,'on');
    
    if refreshDictNeighbors
        if dataHasLabels
            dataDict = updateDictIndices(data,dataDict,regions,regionLabels);
        else
            dataDict = updateDictIndices(data,dataDict);
        end
        refreshDictNeighbors = 0;
        handles.refreshDictNeighbors = refreshDictNeighbors;
        handles.dataDict = dataDict;
        guidata(hObject,handles);
    end
    
    updateStaticText(handles,'data',true);
    updateStaticText(handles,'dictTemplate',true);
    
    flags = [-1 -1 -1];
    flags(1) = get(handles.checkbox_evalTemplatesInOrder,'Value');
    flags(2) = get(handles.checkbox_displayCorrectNeighbors,'Value');
    flags(3) = get(handles.checkbox_displayIncorrectNeighbors,'Value');
    if selectedTemplateIndex == 1
        plotDictNeighbors(handles.graph_dictNeighbors,flags,...
            data,dataDict,dataHasLabels);
    elseif selectedTemplateIndex > 1 && selectedTemplateIndex <= length(dataDict) + 1
        plotDictNeighbors(handles.graph_dictNeighbors,flags,data,...
            dataDict(selectedTemplateIndex-1), dataHasLabels);
    else
        errordlg('Error with graph_dictNeighbors: selectedTemplateIndex.');
    end
    hold(handles.graph_dictNeighbors,'off');
end


%% --- Executes on button press in button_learnNewDict.
function button_learnNewDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_learnNewDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load guidata as inputHandles
inputHandles = guidata(hObject);

if ~all(isfield(inputHandles,{'data','regions','regionLabels','startLength',...
        'stepLength','endLength','Fbeta','k','targetLabel'}))
    errordlg('Need to input data and parameters before creating dictionary.');
    return;
else
    if ~handles.dataHasLabels
        errordlg('Cannot learn from an unlabeled data set');
        return;
    end
    
    data = inputHandles.data;
    regions = inputHandles.regions;
    regionLabels = inputHandles.regionLabels;
    startLength = inputHandles.startLength;
    stepLength = inputHandles.stepLength;
    endLength = inputHandles.endLength;
    Fbeta = inputHandles.Fbeta;
    k = inputHandles.k;
    targetLabel = inputHandles.targetLabel;
    
    if isempty(data) || isempty (regions) || isempty(regionLabels)
        errordlg('Need to import data before creating dictionary.');
        return;
    elseif isempty(startLength) || isempty(stepLength) ...
            || isempty(endLength) || isempty(Fbeta) || isempty(k)
        errordlg('Need to input parameters before creating dictionary.');
        return;
    else
        if get(handles.checkbox_useSimplicityBias,'Value')
            AV_type = 'simple';
        else
            AV_type = '';
        end
        [dataDict, Fscore] = learnDataDictionary(data,regions,regionLabels,...
            targetLabel,startLength,stepLength,endLength,Fbeta,k,AV_type);
        
        % Save unorder TP,FP for each entry
        for i=1:length(dataDict)
            [unorderTPIndices,unorderFPIndices] = ...
                getClassifiedNeighbors2(data,dataDict(i),regions,regionLabels);
            dataDict(i).unorderTPIndices = unorderTPIndices;
            dataDict(i).unorderFPIndices = unorderFPIndices;
        end
        
        handles.dataDict = dataDict;
        handles.Fscore = Fscore;
        handles.refreshDictNeighbors = 0;
        guidata(hObject,handles);
        
        updateStaticText(handles,'data',true);
        updateStaticText(handles,'dictTemplate',true);
        updatePlotNames(handles,'dict');
        
        % Plot neighbors for all templates, defaults to 'All' in listbox
        plotDataRegions(handles.graph_dictNeighbors,data,regions);
        hold(handles.graph_dictNeighbors,'on');
        
        for i=1:length(dataDict)
            plotNeighbors(handles.graph_dictNeighbors,data,...
                dataDict(i).tpIndices,dataDict(i).length);
            hold(handles.graph_dictNeighbors,'on');
            plotNeighbors(handles.graph_dictNeighbors,data,...
                dataDict(i).fpIndices,dataDict(i).length);
            hold(handles.graph_dictNeighbors,'on');
        end
        hold(handles.graph_dictNeighbors,'off');
        
        updateListboxTemplates(handles.listbox_dictTemplates,dataDict);
        
        % Plot dictionary templates
        plotDictTemplates(handles.graph_dictTemplates,dataDict);
    end
end



%% --- Executes on button press in button_importDict.
% Imports a dictionary and updates graph_dictTemplates
function button_importDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_importDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileName = uigetfile({'*.mat' ; '*.txt'});
if fileName ~= 0
    try
        myFile = load(fileName);
    catch
        errordlg('Error converting dictionary text file to mat file');
    end
    
    % If it is a matfile, it will have this variable
    if isfield(myFile,'dataDict')
        dataDict = myFile.dataDict;
    else
        try
            dataDict = dictMatrix2dictStruct(myFile);
        catch
            errordlg('Error converting dictionary text file to mat file');
            return;
        end
    end
    
    if assertDictFields(dataDict);
        % Copy templates to queries subfield -- old code requires queries
        % subfield...
        for i=1:length(dataDict)
            dataDict(i).query = dataDict(i).template;
        end
        
        % Clear highlighted neighbors if applicable
        inputHandles = guidata(hObject);
        if all(isfield(inputHandles,{'data','regions'}))
            cla(handles.graph_dictNeighbors,'reset');
            white = [1 1 1];
            for i=1:size(inputHandles.regions,1)
                area(handles.graph_dictNeighbors,...
                    inputHandles.regions(i,:), [10 10], 'FaceColor', white, ...
                    'LineStyle', ':');
                hold(handles.graph_dictNeighbors,'on');
            end
            plot(handles.graph_dictNeighbors,handles.data);
        end
        
        % fill in indices if there is data else empty indices
        inputHandles = guidata(hObject);
        if all(isfield(inputHandles,{'data','regions','regionLabels'}))
            if inputHandles.dataHasLabels
                data = inputHandles.data;
                regions = inputHandles.regions;
                regionLabels = inputHandles.regionLabels;
                dataDict = updateDictIndices(data,dataDict,regions,regionLabels);
                handles.refreshDictNeighbors = 0;
            else
                data = inputHandles.data;
                dataDict = updateDictIndices(data,dataDict)
                handles.refreshDictNeighbors = 0;
            end
        else
            for i=1:length(dataDict)
                dataDict(i).tpIndices = [];
                dataDict(i).fpIndices = [];
                dataDict(i).unorderTPIndices = [];
                dataDict(i).unorderFPIndices = [];
            end
            handles.refreshDictNeighbors = 1;
        end
        updateStaticText(handles,'data',false);
        updateStaticText(handles,'dictTemplate',false);
        updatePlotNames(handles,'dict',fileName);
        handles.dataDict = dataDict;
        guidata(hObject,handles);
        
        % Load templates to listbox
        updateListboxTemplates(handles.listbox_dictTemplates,dataDict);
        
        % Plot all dictionary templates
        plotDictTemplates(handles.graph_dictTemplates,dataDict);
        hold(handles.graph_dictTemplates,'off');
    else
        errordlg('Dictionary needs fields "template","length", and "threshold."');
    end
    
end




% --- Executes on button press in button_exportDict.
function button_exportDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_exportDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputHandles = guidata(hObject);
if isfield(inputHandles,'dataDict')
    if ~assertDictFields(inputHandles.dataDict)
        errordlg('Error with dictionary fields.');
        return;
    end
    
    exportAsMAT = get(handles.checkbox_exportAsMAT,'Value');
    
    if exportAsMAT
        fileName = uiputfile('.mat','Save current dictionary.');
        if ischar(fileName)
            dataDict = inputHandles.dataDict;
            dataDict = rmfield(dataDict,{'query','tpIndices','fpIndices',...
                'unorderTPIndices','unorderFPIndices', 'queryIndices', ...
                'indices', 'unorderIndices'});
            
            updatePlotNames(handles,'dict',fileName);
            
            save(fileName,'dataDict');
        else
            errordlg('Invalid dictionary name.');
        end
    else
        fileName = uiputfile('.txt', 'Save current dictionary.');
        if ischar(fileName)
            dataDict = inputHandles.dataDict;
            dictMatrix = dictStruct2dictMatrix(dataDict);
            
            updatePlotNames(handles,'dict',fileName);
            
            dlmwrite(fileName,dictMatrix,'precision',32);
        else
            errordlg('Invalid dictionary name.');
        end
    end
else
    errordlg('Could not find a dictionary to save');
end





function input_startLength_Callback(hObject, eventdata, handles)
% hObject    handle to input_startLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_startLength as text
%        str2double(get(hObject,'String')) returns contents of input_startLength as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || input <= 0 || ~rem(input,1)==0
    errordlg('Start Length must be a positive integer.');
else
    handles.startLength = input;
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function input_startLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_startLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_Fbeta_Callback(hObject, eventdata, handles)
% hObject    handle to input_Fbeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_Fbeta as text
%        str2double(get(hObject,'String')) returns contents of input_Fbeta as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || input <= 0
    errordlg('F_beta must be a positive number.');
else
    handles.Fbeta = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_Fbeta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_Fbeta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_stepLength_Callback(hObject, eventdata, handles)
% hObject    handle to input_stepLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_stepLength as text
%        str2double(get(hObject,'String')) returns contents of input_stepLength as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || input <= 0 || ~rem(input,1)==0
    errordlg('Step Length must be a positive integer.');
else
    handles.stepLength = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_stepLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_stepLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_endLength_Callback(hObject, eventdata, handles)
% hObject    handle to input_endLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_endLength as text
%        str2double(get(hObject,'String')) returns contents of input_endLength as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || input <= 0 || ~rem(input,1)==0
    errordlg('End Length must be a positive integer.');
else
    handles.endLength = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_endLength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_endLength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_K_Callback(hObject, eventdata, handles)
% hObject    handle to input_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_K as text
%        str2double(get(hObject,'String')) returns contents of input_K as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || input <= 0 || ~rem(input,1)==0
    errordlg('k must be a positive integer.');
else
    handles.k = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_K_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_K (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function input_targetLabel_Callback(hObject, eventdata, handles)
% hObject    handle to input_targetLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_targetLabel as text
%        str2double(get(hObject,'String')) returns contents of input_targetLabel as a double
input = get(hObject,'String');
input = str2num(input);
if isnan(input) || ~rem(input,1)==0
    errordlg('Target Label must be an integer.');
else
    handles.targetLabel = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_targetLabel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_targetLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_dictTemplates.
function listbox_dictTemplates_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_dictTemplates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_dictTemplates contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_dictTemplates

% Value of selectedTemplateIndex <= length(dataDict) + 1
selectedTemplateIndex = get(hObject,'Value');
handles.selectedTemplateIndex = selectedTemplateIndex;
guidata(hObject,handles);

inputHandles = guidata(hObject);
if all(isfield(inputHandles,{'dataDict','refreshDictNeighbors','selectedTemplateIndex'}))
    dataDict = inputHandles.dataDict;
    refreshDictNeighbors = inputHandles.refreshDictNeighbors;
    selectedTemplateIndex = inputHandles.selectedTemplateIndex;
    dataHasLabels = inputHandles.dataHasLabels;
    if assertDictFields(dataDict)
        precisionStringVal = 'Precision: --';
        numTPStringVal = 'True positives: --';
        numFPStringVal = 'False positives: --';
        numNeighborsStringVal = 'Neighbors: --';
        if refreshDictNeighbors == 0
            updateMetaDataText(handles,selectedTemplateIndex,dataDict,dataHasLabels);
        else
            set(handles.staticText_precision,'String',precisionStringVal);
            set(handles.staticText_numTP,'String',numTPStringVal);
            set(handles.staticText_numFP,'String',numFPStringVal);
            set(handles.staticText_numNeighbors,'String',numNeighborsStringVal);
        end
    else
        errordlg('Error with displaying dictionary precision');
        return;
    end
end





% --- Executes during object creation, after setting all properties.
function listbox_dictTemplates_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_dictTemplates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_displayCorrectNeighbors.
function checkbox_displayCorrectNeighbors_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayCorrectNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayCorrectNeighbors


% --- Executes on button press in checkbox_displayIncorrectNeighbors.
function checkbox_displayIncorrectNeighbors_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayIncorrectNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_displayIncorrectNeighbors

% --- Executes on button press in checkbox_evalTemplatesInOrder
function checkbox_evalTemplatesInOrder_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_displayIncorrectNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_evalTemplatesInOrder


function input_numNeighbors_Callback(hObject, eventdata, handles)
% hObject    handle to input_numNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_numNeighbors as text
%        str2double(get(hObject,'String')) returns contents of input_numNeighbors as a double
input = get(hObject,'String');
input = str2num(input);
if isempty(input)
    handles.displayNumNeighbors = inf; % Display all option
    guidata(hObject,handles);
elseif isnan(input) || ~rem(input,1)==0
    errordlg('# of Neighbors must be a positive integer.');
else
    handles.displayNumNeighbors = input;
    guidata(hObject,handles);
end

% --- Executes during object creation, after setting all properties.
function input_numNeighbors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_numNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_plotTemplate.
function button_plotTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to button_plotTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Need to implement close in view of a template vs TPs/FPs
inputHandles = guidata(hObject);
if inputHandles.selectedTemplateIndex == 1 & isfield(inputHandles,'dataDict') & ...
        assertDictFields(inputHandles.dataDict)
    plotDictTemplates(handles.graph_dictTemplates,inputHandles.dataDict);
    hold(handles.graph_dictTemplates,'off');
elseif inputHandles.selectedTemplateIndex > 1 && all(isfield(inputHandles,{'dataDict',...
        'refreshDictNeighbors','data','regions','regionLabels','displayNumNeighbors'}))
    dataDict = inputHandles.dataDict;
    data = inputHandles.data;
    dataHasLabels = inputHandles.dataHasLabels;
    
    if dataHasLabels
        regions = inputHandles.regions;
        regionLabels = inputHandles.regionLabels;
    end
    
    selectedTemplateIndex = inputHandles.selectedTemplateIndex;
    displayNumNeighbors = inputHandles.displayNumNeighbors;
    refreshDictNeighbors = handles.refreshDictNeighbors;
    
    if refreshDictNeighbors
       if dataHasLabels
           dataDict = updateDictIndices(data,dataDict,regions,regionLabels);
       else
           dataDict = updateDictIndices(data,dataDict);
       end
       refreshDictNeighbors = 0;
       handles.refreshDictNeighbors = refreshDictNeighbors;
       handles.dataDict = dataDict;
       guidata(hObject,handles);
       updateStaticText(handles,'data',true);
       updateStaticText(handles,'dictTemplate',true);
    end
    
    flags = [-1 -1 -1];
    flags(1) = get(handles.checkbox_evalTemplatesInOrder,'Value');
    flags(2) = get(handles.checkbox_displayCorrectNeighbors,'Value');
    flags(3) = get(handles.checkbox_displayIncorrectNeighbors,'Value');
    plotTemplateNeighbors(handles.graph_dictTemplates,flags,data,...
        dataDict(selectedTemplateIndex-1),displayNumNeighbors,dataHasLabels);
    hold(handles.graph_dictTemplates,'off');
else
    errordlg('Error with graphing templates.');
end


% --- Executes on button press in checkbox_useSimplicityBias.
function checkbox_useSimplicityBias_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_useSimplicityBias (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_useSimplicityBias


% --- Executes on button press in button_exportIndices.
function button_exportIndices_Callback(hObject, eventdata, handles)
% hObject    handle to button_exportIndices (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exports the first displayNumNeighbors indices depending on the checkboxes
% and selected template to a file
inputHandles = guidata(hObject);
if all(isfield(inputHandles,{'dataDict',...
        'refreshDictNeighbors','data','regions','regionLabels','displayNumNeighbors'}))
    dataDict = inputHandles.dataDict;
    data = inputHandles.data;
    dataHasLabels = inputHandles.dataHasLabels;
    
    if dataHasLabels
        regions = inputHandles.regions;
        regionLabels = inputHandles.regionLabels;
    end
    
    selectedTemplateIndex = inputHandles.selectedTemplateIndex;
    refreshDictNeighbors = handles.refreshDictNeighbors;
    dataHasLabels = inputHandles.dataHasLabels;
    
    if refreshDictNeighbors
        if dataHasLabels
            dataDict = updateDictIndices(data,dataDict,regions,regionLabels);
        else
            dataDict = updateDictIndices(data,dataDict);
        end
        refreshDictNeighbors = 0;
        handles.refreshDictNeighbors = refreshDictNeighbors;
        handles.dataDict = dataDict;
        guidata(hObject,handles);
        updateStaticText(handles,'data',true);
        updateStaticText(handles,'dictTemplate',true);
    end
    
    flags = [-1 -1 -1];
    flags(1) = get(handles.checkbox_evalTemplatesInOrder,'Value');
    flags(2) = get(handles.checkbox_displayCorrectNeighbors,'Value');
    flags(3) = get(handles.checkbox_displayIncorrectNeighbors,'Value');
    
    indices = prepExportIndices(dataDict, selectedTemplateIndex, flags, dataHasLabels);
    
    fileName = uiputfile('.txt','Save exported indices.');
    if ischar(fileName)
        dlmwrite(fileName,indices);
    else
        errordlg('Invalid file name.');
    end    
else
    errordlg('Error exporting indices');
end


% --- Executes on button press in checkbox_exportAsMAT.
function checkbox_exportAsMAT_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_exportAsMAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_exportAsMAT
