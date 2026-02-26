function varargout = YoloTrainParameters(varargin)
% YOLOTRAINPARAMETERS MATLAB code for YoloTrainParameters.fig
%      YOLOTRAINPARAMETERS, by itself, creates a new YOLOTRAINPARAMETERS or raises the existing
%      singleton*.
%
%      H = YOLOTRAINPARAMETERS returns the handle to a new YOLOTRAINPARAMETERS or the handle to
%      the existing singleton*.
%
%      YOLOTRAINPARAMETERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in YOLOTRAINPARAMETERS.M with the given input arguments.
%
%      YOLOTRAINPARAMETERS('Property','Value',...) creates a new YOLOTRAINPARAMETERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before YoloTrainParameters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to YoloTrainParameters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help YoloTrainParameters

% Last Modified by GUIDE v2.5 04-Feb-2022 16:02:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @YoloTrainParameters_OpeningFcn, ...
                   'gui_OutputFcn',  @YoloTrainParameters_OutputFcn, ...
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


% --- Executes just before YoloTrainParameters is made visible.
function YoloTrainParameters_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to YoloTrainParameters (see VARARGIN)

% Choose default command line output for YoloTrainParameters
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes YoloTrainParameters wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global GuiGlobalsStruct;
hObject.Color = GuiGlobalsStruct.BackgroundColorValue; %dark background option



% --- Outputs from this function are returned to the command line.
function varargout = YoloTrainParameters_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function NumEpochs_Callback(hObject, eventdata, handles)
% hObject    handle to NumEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumEpochs as text
%        str2double(get(hObject,'String')) returns contents of NumEpochs as a double
NumEpochs = str2num(get(handles.NumEpochs,'String'));
setappdata(0,'NumEpochs',NumEpochs); 

% --- Executes during object creation, after setting all properties.
function NumEpochs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumEpochs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MiniBatchSize_Callback(hObject, eventdata, handles)
% hObject    handle to MiniBatchSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MiniBatchSize as text
%        str2double(get(hObject,'String')) returns contents of MiniBatchSize as a double
MiniBatchSize = str2num(get(handles.MiniBatchSize,'String'));
setappdata(0,'MiniBatchSize',MiniBatchSize); 

% --- Executes during object creation, after setting all properties.
function MiniBatchSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MiniBatchSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function WarmupPeriod_Callback(hObject, eventdata, handles)
% hObject    handle to WarmupPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WarmupPeriod as text
%        str2double(get(hObject,'String')) returns contents of WarmupPeriod as a double
WarmupPeriod = str2num(get(handles.WarmupPeriod,'String'));
setappdata(0,'WarmupPeriod',WarmupPeriod); 

% --- Executes during object creation, after setting all properties.
function WarmupPeriod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WarmupPeriod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function L2Regularization_Callback(hObject, eventdata, handles)
% hObject    handle to L2Regularization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of L2Regularization as text
%        str2double(get(hObject,'String')) returns contents of L2Regularization as a double
l2Regularization = str2double(get(handles.L2Regularization,'String'));
setappdata(0,'l2Regularization',l2Regularization); 

% --- Executes during object creation, after setting all properties.
function L2Regularization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to L2Regularization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PenaltyThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to PenaltyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PenaltyThreshold as text
%        str2double(get(hObject,'String')) returns contents of PenaltyThreshold as a double
PenaltyThreshold = str2double(get(handles.PenaltyThreshold,'String'));
setappdata(0,'PenaltyThreshold',PenaltyThreshold); 

% --- Executes during object creation, after setting all properties.
function PenaltyThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PenaltyThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Velocity_Callback(hObject, eventdata, handles)
% hObject    handle to Velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Velocity as text
%        str2double(get(hObject,'String')) returns contents of Velocity as a double
Velocity = get(handles.Velocity,'String');
setappdata(0,'Velocity',Velocity); 

% --- Executes during object creation, after setting all properties.
function Velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setDefaultValues.
function setDefaultValues_Callback(hObject, eventdata, handles)
% hObject    handle to setDefaultValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumEpochs = findobj(0, 'tag', 'NumEpochs');set(NumEpochs, 'string', '70');
MiniBatchSize = findobj(0, 'tag', 'MiniBatchSize');set(MiniBatchSize, 'string', '8');
WarmupPeriod = findobj(0, 'tag', 'WarmupPeriod');set(WarmupPeriod, 'string', '1000');
L2Regularization = findobj(0, 'tag', 'L2Regularization');set(L2Regularization, 'string', '0.0005');
PenaltyThreshold = findobj(0, 'tag', 'PenaltyThreshold');set(PenaltyThreshold, 'string', '0.5');
% Velocity = findobj(0, 'tag', 'Velocity');set(Velocity, 'string', '');
LearningRate = findobj(0, 'tag', 'LearningRate');set(LearningRate, 'string', '0.001');



function LearningRate_Callback(hObject, eventdata, handles)
% hObject    handle to LearningRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LearningRate as text
%        str2double(get(hObject,'String')) returns contents of LearningRate as a double
LearningRate = get(handles.LearningRate,'String');
setappdata(0,'LearningRate',LearningRate); 

% --- Executes during object creation, after setting all properties.
function LearningRate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LearningRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global GuiGlobalsStruct;
MiniBatchSize = findobj(0, 'tag', 'MiniBatchSize');
GuiGlobalsStruct.YoloParameters.MiniBatchSize = str2num(get(MiniBatchSize,'String'));
NumEpochs = findobj(0, 'tag', 'NumEpochs');
GuiGlobalsStruct.YoloParameters.numEpochs = str2num(get(NumEpochs,'String'));
LearningRate = findobj(0, 'tag', 'LearningRate');
GuiGlobalsStruct.YoloParameters.learningRate = str2double(get(LearningRate,'String'));
WarmupPeriod = findobj(0, 'tag', 'WarmupPeriod');
GuiGlobalsStruct.YoloParameters.warmupPeriod = str2num(get(WarmupPeriod,'String'));
L2Regularization = findobj(0, 'tag', 'L2Regularization');
GuiGlobalsStruct.YoloParameters.l2Regularization = str2double(get(L2Regularization,'String'));
PenaltyThreshold = findobj(0, 'tag', 'PenaltyThreshold');
GuiGlobalsStruct.YoloParameters.penaltyThreshold = str2double(get(PenaltyThreshold,'String'));
% Velocity = findobj(0, 'tag', 'Velocity');
% GuiGlobalsStruct.YoloParameters.velocity = get(Velocity,'String');
MyStr = 'It is saved.';
uiwait(msgbox(MyStr));
