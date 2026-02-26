function varargout = ManualFocusStigGUI(varargin)
% MANUALFOCUSSTIGGUI MATLAB code for ManualFocusStigGUI.fig
%      MANUALFOCUSSTIGGUI, by itself, creates a new MANUALFOCUSSTIGGUI or raises the existing
%      singleton*.
%
%      H = MANUALFOCUSSTIGGUI returns the handle to a new MANUALFOCUSSTIGGUI or the handle to
%      the existing singleton*.
%
%      MANUALFOCUSSTIGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALFOCUSSTIGGUI.M with the given input arguments.
%
%      MANUALFOCUSSTIGGUI('Property','Value',...) creates a new MANUALFOCUSSTIGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ManualFocusStigGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ManualFocusStigGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ManualFocusStigGUI

% Last Modified by GUIDE v2.5 11-Feb-2021 18:08:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ManualFocusStigGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ManualFocusStigGUI_OutputFcn, ...
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


% --- Executes just before ManualFocusStigGUI is made visible.
function ManualFocusStigGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ManualFocusStigGUI (see VARARGIN)

% Choose default command line output for ManualFocusStigGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ManualFocusStigGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global GuiGlobalsStruct;
hObject.Color = GuiGlobalsStruct.BackgroundColorValue; %dark background option


% --- Outputs from this function are returned to the command line.
function varargout = ManualFocusStigGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in scan_togglebutton.
function scan_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to scan_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan_togglebutton

global globFSG

val = get(hObject,'Value')
while val
    
    
    
end


% --- Executes on button press in StiigYDown_pushbutton.
function StiigYDown_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StiigYDown_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StigYUp_pushbutton.
function StigYUp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StigYUp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function StigY_edit_Callback(hObject, eventdata, handles)
% hObject    handle to StigY_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StigY_edit as text
%        str2double(get(hObject,'String')) returns contents of StigY_edit as a double


% --- Executes during object creation, after setting all properties.
function StigY_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StigY_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StigXDown_pushbutton.
function StigXDown_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StigXDown_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StigXUp_pushbutton.
function StigXUp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StigXUp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function StigX_edit_Callback(hObject, eventdata, handles)
% hObject    handle to StigX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StigX_edit as text
%        str2double(get(hObject,'String')) returns contents of StigX_edit as a double


% --- Executes during object creation, after setting all properties.
function StigX_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StigX_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in StigMagDown_pushbutton.
function StigMagDown_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StigMagDown_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StigMagUp_pushbutton.
function StigMagUp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to StigMagUp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function StigMag_edit_Callback(hObject, eventdata, handles)
% hObject    handle to StigMag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StigMag_edit as text
%        str2double(get(hObject,'String')) returns contents of StigMag_edit as a double


% --- Executes during object creation, after setting all properties.
function StigMag_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StigMag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Focus_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Focus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Focus_edit as text
%        str2double(get(hObject,'String')) returns contents of Focus_edit as a double


% --- Executes during object creation, after setting all properties.
function Focus_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Focus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FocusMagDown_pushbutton.
function FocusMagDown_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FocusMagDown_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FocusMagUp_pushbutton.
function FocusMagUp_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to FocusMagUp_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function FocusMag_edit_Callback(hObject, eventdata, handles)
% hObject    handle to FocusMag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FocusMag_edit as text
%        str2double(get(hObject,'String')) returns contents of FocusMag_edit as a double


% --- Executes during object creation, after setting all properties.
function FocusMag_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FocusMag_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
