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

% Last Modified by GUIDE v2.5 18-Aug-2017 21:00:01

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
        guidata(hObject,handles);

        % Plot the data
        cla(handles.graph_dictNeighbors,'reset');
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


%% --- Executes on button press in button_learnNewDict.
function button_learnNewDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_learnNewDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputHandles = guidata(hObject);
if ~isfield(inputHandles,{'data','regions','regionLabels','startLength',...
        'stepLength','endLength','Fbeta','k','targetLabel'})
    errordlg('Need to input data and parameters before creating dictionary.');
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
elseif isempty(startLength) || isempty(stepLength) ...
        || isempty(endLength) || isempty(Fbeta) || isempty(k)
    errordlg('Need to input parameters before creating dictionary.');
else
    
    [dataDict, Fscore] = learnDataDictionary(data,regions,regionLabels,...
        targetLabel,startLength,stepLength,endLength,Fbeta,k);
    
    
    handles.dataDict = dataDict;
    handles.Fscore = Fscore;
    guidata(hObject,handles);
    
    % Plot neighbors
    cla(handles.graph_dictNeighbors,'reset');
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
    
    disp('DONE LEARNING');
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
       handles.dataDict = matFile;
       
       % Reload graph_dictNeighbors to get rid of highlighted neighbors
       if ~isempty(handles.graph_dictNeighbors)
           cla(handles.graph_dictNeighbors,'reset');
           plot(handles.graph_dictNeighbors,handles.data);
       end
       
       % Plot dictionary templates
       cla(handles.graph_dictTemplates,'reset');
       for i=1:length(handles.dataDict)
           plot(handles.graph_dictTemplates,...
               [1:length(handles.dataDict(i).template)],handles.dataDict(i).template);
           hold on;
       end
   else
       errordlg('Dictionary has fields "template","length", and "threshold."');
   end
    
end




% --- Executes on button press in button_exportDict.
function button_exportDict_Callback(hObject, eventdata, handles)
% hObject    handle to button_exportDict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.dataDict)
    filename = uiputfile('.mat','Save dictionary name.');
    if ~isempty(filename)
        save(filename,handles.dataDict);
    else
        errordlg('Invalid dictionary name'); 
    end
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
