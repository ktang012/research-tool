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

% Last Modified by GUIDE v2.5 19-Aug-2017 21:11:04

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
        % save handles
        guidata(hObject,handles);

        % Plot the data
        cla(handles.graph_dictNeighbors,'reset');
        white = [1 1 1];
        for i=1:size(matFile.regions,1)
            area(handles.graph_dictNeighbors,...
                matFile.regions(i,:), [10 10], 'FaceColor', white, ...
                'LineStyle', ':');
            hold(handles.graph_dictNeighbors,'on');
        end
        plot(handles.graph_dictNeighbors,handles.data);

        % Plot the region labels
        cla(handles.graph_regionLabels,'reset');
        labelAnnotations = [];
        for i=1:length(handles.regionLabels)
            if handles.regionLabels(i) == 1
                l = ones(handles.regions(i,2)-handles.regions(i,1)+1,1);
                labelAnnotations = [labelAnnotations; l];
            else
                l = zeros(handles.regions(i,2)-handles.regions(i,1)+1,1);
                labelAnnotations = [labelAnnotations; l];
            end
        end
        plot(handles.graph_regionLabels, labelAnnotations);
    else
        errordlg('File has fields "data","regions", and "regionLabels."');
    end
end


%% --- Executes on button press in button_plotDictNeighbors.
function button_plotDictNeighbors_Callback(hObject, eventdata, handles)
% hObject    handle to button_plotDictNeighbors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputHandles = guidata(hObject);
if ~all(isfield(inputHandles,{'data','regions','regionLabels','startLength',...
        'stepLength','endLength','Fbeta','k','targetLabel'}))
    errordlg('Need to input data and parameters before creating dictionary.');
    return;
    
elseif ~isfield(inputHandles,{'dataDict'})
    errordlg('Need to have a dictionary before plotting.');
    return
else
    data = inputHandles.data;
    regions = inputHandles.regions;
    regionLabels = inputHandles.regionLabels;
    startLength = inputHandles.startLength;
    stepLength = inputHandles.stepLength;
    endLength = inputHandles.endLength;
    Fbeta = inputHandles.Fbeta;
    k = inputHandles.k;
    targetLabel = inputHandles.targetLabel;
    dataDict = inputHandles.dataDict;
    
    % Plot the data
    cla(handles.graph_dictNeighbors,'reset');
    white = [1 1 1];
    for i=1:size(regions,1)
        area(handles.graph_dictNeighbors,...
            regions(i,:), [10 10], 'FaceColor', white, ...
            'LineStyle', ':');
        hold(handles.graph_dictNeighbors,'on');
    end
    plot(handles.graph_dictNeighbors,handles.data);
    hold(handles.graph_dictNeighbors,'on');
    
    % ALSO NEED TO CHECK WHICH TEMPLATE IS BEING USED!!
    % if in order evaluation is checked
    if get(handles.checkbox_evalTemplatesInOrder,'Value') ~= 0
        for i=1:length(dataDict)
            for j=1:length(dataDict(i).tpIndices)
                % if displaying correct neighbors
                if get(handles.checkbox_displayCorrectNeighbors,'Value') ~= 0
                    plot(handles.graph_dictNeighbors,...
                        dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1, ...
                        data(dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1), ...
                        'LineWidth', 3);
                    hold(handles.graph_dictNeighbors,'on');
                end
            end
            for j=1:length(dataDict(i).fpIndices)
                % if displaying incorrect neighbors
                if get(handles.checkbox_displayIncorrectNeighbors,'Value') ~= 0
                    plot(handles.graph_dictNeighbors,...
                        dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1, ...
                        data(dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1), ...
                        'LineWidth', 3);
                    hold(handles.graph_dictNeighbors,'on');
                end
            end
        end
    else
        for i=1:length(dataDict)
            for j=1:length(dataDict(i).unorderTPIndices)
                % if displaying correct neighbors
                if get(handles.checkbox_displayCorrectNeighbors,'Value') ~= 0
                    plot(handles.graph_dictNeighbors,...
                        dataDict(i).unorderTPIndices(j):dataDict(i).unorderTPIndices(j)+dataDict(i).length-1, ...
                        data(dataDict(i).unorderTPIndices(j):dataDict(i).unorderTPIndices(j)+dataDict(i).length-1), ...
                        'LineWidth', 3);
                    hold(handles.graph_dictNeighbors,'on');
                end
            end
            for j=1:length(dataDict(i).fpIndices)
                % if displaying incorrect neighbors
                if get(handles.checkbox_displayIncorrectNeighbors,'Value') ~= 0
                    plot(handles.graph_dictNeighbors,...
                        dataDict(i).unorderFPIndices(j):dataDict(i).unorderFPIndices(j)+dataDict(i).length-1, ...
                        data(dataDict(i).unorderFPIndices(j):dataDict(i).unorderFPIndices(j)+dataDict(i).length-1), ...
                        'LineWidth', 3);
                    hold(handles.graph_dictNeighbors,'on');
                end
            end
        end
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
        [dataDict, Fscore] = learnDataDictionary(data,regions,regionLabels,...
            targetLabel,startLength,stepLength,endLength,Fbeta,k);
        
        % Save unorder TP,FP for each entry
        for i=1:length(dataDict)
            [unorderTPIndices,unorderFPIndices] = ...
                getClassifiedNeighbors2(data,dataDict(i),regions,regionLabels);
            dataDict(i).unorderTPIndices = unorderTPIndices;
            dataDict(i).unorderFPIndices = unorderFPIndices;
        end
        
        handles.dataDict = dataDict;
        handles.Fscore = Fscore;
        guidata(hObject,handles);
        
        % Plot neighbors -- NOTE: NEED TO DO IT ACCORDING TO CHECKBOXES
        cla(handles.graph_dictNeighbors,'reset');
        white = [1 1 1];
        for i=1:size(regions,1)
            area(handles.graph_dictNeighbors,...
                regions(i,:), [10 10], 'FaceColor', white, ...
                'LineStyle', ':');
            hold(handles.graph_dictNeighbors,'on');
        end
        plot(handles.graph_dictNeighbors,data);
        hold(handles.graph_dictNeighbors,'on');
        for i=1:length(dataDict)
            for j=1:length(dataDict(i).tpIndices)
                plot(handles.graph_dictNeighbors,...
                    dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1, ...
                    data(dataDict(i).tpIndices(j):dataDict(i).tpIndices(j)+dataDict(i).length-1), ...
                    'LineWidth', 3);
                hold(handles.graph_dictNeighbors,'on');
            end
            for j=1:length(dataDict(i).fpIndices)
                plot(handles.graph_dictNeighbors,...
                    dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1, ...
                    data(dataDict(i).fpIndices(j):dataDict(i).fpIndices(j)+dataDict(i).length-1), ...
                    'LineWidth', 3);
                hold(handles.graph_dictNeighbors,'on');
            end
        end
        hold(handles.graph_dictNeighbors,'off');
        
        % Plot dictionary templates
        cla(handles.graph_dictTemplates,'reset');
        for i=1:length(dataDict)
            plot(handles.graph_dictTemplates,...
                [1:length(dataDict(i).template)],dataDict(i).template);
            hold(handles.graph_dictTemplates,'on');
        end
        hold(handles.graph_dictTemplates,'off');
    end
end



%% --- Executes on button press in button_importDict.
% Imports a dictionary and updates graph_dictTemplates
function button_importDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_importDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileName = uigetfile('.mat');
if fileName ~= 0
   matFile = load(fileName);
   if isfield(matFile, {'template','length','threshold'})
       dataDict = matFile;
       
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
           data = inputHandles.data;
           regions = inputHandles.regions;
           regionLabels = inputHandles.regionLabels;
           [~,~,~,~,sortedTPIndices,sortedFPIndices] = ...
               getClassifiedNeighbors2(data,dataDict,regions,regionLabels);
           for i=1:length(dataDict)
               dataDict(i).tpIndices = sortedTPIndices{i};
               dataDict(i).fpIndices = sortedFPIndices{i};
               [unorderTPIndices,unorderFPIndices] = ...
                   getClassifiedNeighbors2(data,dataDict(i),regions,regionLabels);
               dataDict(i).unorderTPIndices = unorderTPIndices;
               dataDict(i).unorderFPIndices = unorderFPIndices;
           end
       else
           for i=1:length(dataDict)
               dataDict(i).tpIndices = [];
               dataDict(i).fpIndices = [];
               dataDict(i).unorderTPIndices = [];
               dataDict(i).unorderFPIndices = [];
           end
       end
       handles.dataDict = dataDict;
       guidata(hObject,handles);
       
       % Plot dictionary templates
       cla(handles.graph_dictTemplates,'reset');
       for i=1:length(handles.dataDict)
           plot(handles.graph_dictTemplates,...
               [1:length(handles.dataDict(i).template)],handles.dataDict(i).template);
           hold(handles.graph_dictTemplates,'on');
       end
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
    filename = uiputfile('.mat','Save current dictionary.');
    if ~isempty(filename)
        % clear indices before saving
        for i=1:length(inputHandles.dataDict)
            inputHandles.dataDict(i).tpIndices = [];
            inputHandles.dataDict(i).fpIndices = [];
            inputHandles.dataDict(i).unorderTPIndices = [];
            inputHandles.dataDict(i).unorderFPIndices = [];
        end
        save(filename,inputHandles.dataDict);
    else
        errordlg('Invalid dictionary name.');
    end
else
    errordlg('Could not find dictionary to save');
end


% --- Executes on button press in button_inspectDictTemplates.
function button_inspectDictTemplates_Callback(hObject, eventdata, handles)
% hObject    handle to button_inspectDictTemplates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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

% Find index of item selected, plot the template depending on the index
% Note: if selectedIndex == 1, then display all templates
% The function should also display the template's corresponding TP and FP
% depending on the TP/FP checkboxes AND the in order checkbox
% Each entry should have (for a particular data set) a list of in order TPs
% and FPs and a list of non in order TPs and FPs
% The checkboxes should also extend the the button/graph plotDictNeighbors
selectedIndex = get(hObject,'Value');
handles.selectedIndex = selectedIndex;
guidata(hObject,handles);

% if selectedIndex > 1
% plot template bolded in dictTemplates
% if in order checked
% --- if tp checked -- plot tp_in_order in dictTemplates and dictNeighbors
% --- if fp checked -- plot fp_in_order in dictTemplates and dictNeighbors
% --- 
% else
% --- if tp checked -- plot tp in dictTemplates and dictNeighbors
% --- if fp checked -- plot fp in dictTemplates and dictNeighbors
% else
% plot all templates




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


% --- Executes on button press in checkbox_evalTemplatesInOrder.
function checkbox_evalTemplatesInOrder_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_evalTemplatesInOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_evalTemplatesInOrder


% --- Executes on button press in button_evalTemplate.
function button_evalTemplate_Callback(hObject, eventdata, handles)
% hObject    handle to button_evalTemplate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
