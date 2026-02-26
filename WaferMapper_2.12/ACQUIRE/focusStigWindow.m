function varargout = focusStigWindow(varargin)
% FOCUSSTIGWINDOW MATLAB code for focusStigWindow.fig
%      FOCUSSTIGWINDOW, by itself, creates a new FOCUSSTIGWINDOW or raises the existing
%      singleton*.
%
%      H = FOCUSSTIGWINDOW returns the handle to a new FOCUSSTIGWINDOW or the handle to
%      the existing singleton*.
%
%      FOCUSSTIGWINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOCUSSTIGWINDOW.M with the given input arguments.
%
%      FOCUSSTIGWINDOW('Property','Value',...) creates a new FOCUSSTIGWINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before focusStigWindow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to focusStigWindow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help focusStigWindow

% Last Modified by GUIDE v2.5 23-Jul-2020 11:22:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @focusStigWindow_OpeningFcn, ...
                   'gui_OutputFcn',  @focusStigWindow_OutputFcn, ...
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


% --- Executes just before focusStigWindow is made visible.
function focusStigWindow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to focusStigWindow (see VARARGIN)

% Choose default command line output for focusStigWindow
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes focusStigWindow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global globFS GuiGlobalsStruct
globFS.sm =  GuiGlobalsStruct.MyCZEMAPIClass;

global GuiGlobalsStruct;
hObject.Color = GuiGlobalsStruct.BackgroundColorValue; %dark background option


% --- Outputs from this function are returned to the command line.
function varargout = focusStigWindow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_stigX_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stigX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stigX as text
%        str2double(get(hObject,'String')) returns contents of edit_stigX as a double


% --- Executes during object creation, after setting all properties.
function edit_stigX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stigX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global GuiGlobalsStruct globFS
sm = GuiGlobalsStruct.MyCZEMAPIClass;
globFS.startingStigX =sm.Get_ReturnTypeSingle('AP_STIG_X');
set(hObject,'String',num2str(globFS.startingStigX))


% --- Executes on button press in togglebutton_stigY.
function togglebutton_stigY_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_stigY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_stigY


% --- Executes on button press in pushbutton_autoStig.
function pushbutton_autoStig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_autoStig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_stigY_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stigY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_stigY as text
%        str2double(get(hObject,'String')) returns contents of edit_stigY as a double


% --- Executes during object creation, after setting all properties.
function edit_stigY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stigY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


global GuiGlobalsStruct globFS
sm = GuiGlobalsStruct.MyCZEMAPIClass;
globFS.startingStigY =sm.Get_ReturnTypeSingle('AP_STIG_Y');
set(hObject,'String',num2str(globFS.startingStigY))


% --- Executes on button press in togglebutton_stigX.
function togglebutton_stigX_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_stigX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_stigX



function edit_focus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_focus as text
%        str2double(get(hObject,'String')) returns contents of edit_focus as a double

global globFS

str = get(hObject,'String');

wd = str2num(str)/1000;
if ~isempty(wd)
globFS.sm.Set_PassedTypeSingle('AP_WD',wd);
else
    txt = sprintf('%s is invalid focus value',str);
    set(handles.textOut,'String',txt);
end

% --- Executes during object creation, after setting all properties.
function edit_focus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

global GuiGlobalsStruct globFS
sm = GuiGlobalsStruct.MyCZEMAPIClass;
globFS.startingWD =sm.Get_ReturnTypeSingle('AP_WD');
set(hObject,'String',num2str(globFS.startingWD*1000))


% --- Executes on button press in togglebutton_scrollFocus.
function togglebutton_scrollFocus_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_scrollFocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_scrollFocus

global globFS


set(handles.figure1,'windowscrollWheelFcn', {@scrollWD});

function scrollWD(object,eventdata)
global globFS
d = eventdata.VerticalScrollCount;

globFS.focMag = .001;
wd =globFS.sm.Get_ReturnTypeSingle('AP_WD');
wd = wd + globFS.focMag * d;
globFS.sm.Set_PassedTypeSingle('AP_WD',wd);
set(hObject,'String',num2str(globFS.startingWD*1000))

% --- Executes on button press in pushbutton_autoFocus.
function pushbutton_autoFocus_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_autoFocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_FOV.
function togglebutton_FOV_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_FOV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_FOV



function edit_fov_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fov as text
%        str2double(get(hObject,'String')) returns contents of edit_fov as a double


% --- Executes during object creation, after setting all properties.
function edit_fov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton_fov.
function togglebutton_fov_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_fov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_fov


% --- Executes on button press in togglebutton_scan.
function togglebutton_scan_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton_scan



function edit_size_Callback(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_size as text
%        str2double(get(hObject,'String')) returns contents of edit_size as a double


% --- Executes during object creation, after setting all properties.
function edit_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_dwellTime_Callback(hObject, eventdata, handles)
% hObject    handle to edit_dwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_dwellTime as text
%        str2double(get(hObject,'String')) returns contents of edit_dwellTime as a double


% --- Executes during object creation, after setting all properties.
function edit_dwellTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_dwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_fileName_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fileName as text
%        str2double(get(hObject,'String')) returns contents of edit_fileName as a double


% --- Executes during object creation, after setting all properties.
function edit_fileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_acquire.
function pushbutton_acquire_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_acquire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_imageDir.
function pushbutton_imageDir_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_imageDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_pixelSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixelSize as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelSize as a double


% --- Executes during object creation, after setting all properties.
function edit_pixelSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function textOut_Callback(hObject, eventdata, handles)
% hObject    handle to textOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of textOut as text
%        str2double(get(hObject,'String')) returns contents of textOut as a double


% --- Executes during object creation, after setting all properties.
function textOut_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textOut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_panN.
function pushbutton_panN_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_panN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_panS.
function pushbutton_panS_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_panS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_panE.
function pushbutton_panE_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_panE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_panW.
function pushbutton_panW_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_panW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_panT.
function pushbutton_panT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_panT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
