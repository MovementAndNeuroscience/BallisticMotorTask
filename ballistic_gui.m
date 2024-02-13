function varargout = ballistic_gui(varargin)
% ballistic_gui MATLAB code for ballistic_gui.fig
%      ballistic_gui, by itself, creates a new ballistic_gui or raises the existing
%      singleton*.
%
%      H = ballistic_gui returns the handle to a new ballistic_gui or the handle to
%      the existing singleton*.
%
%      ballistic_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ballistic_gui.M with the given input arguments.
%
%      ballistic_gui('Property','Value',...) creates a new ballistic_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ballistic_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ballistic_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ballistic_gui

% Last Modified by GUIDE v2.5 26-Sep-2013 15:41:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ballistic_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ballistic_gui_OutputFcn, ...
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


% --- Executes just before ballistic_gui is made visible.
function ballistic_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ballistic_gui (see VARARGIN)

% Choose default command line output for ballistic_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ballistic_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ballistic_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startButton.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to startButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function maskTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to maskTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskTimeBox as text
%        str2double(get(hObject,'String')) returns contents of maskTimeBox as a double


% --- Executes during object creation, after setting all properties.
function maskTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxValueBox_Callback(hObject, eventdata, handles)
% hObject    handle to maxValueBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxValueBox as text
%        str2double(get(hObject,'String')) returns contents of maxValueBox as a double


% --- Executes during object creation, after setting all properties.
function maxValueBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxValueBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function postFBTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to postFBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of postFBTimeBox as text
%        str2double(get(hObject,'String')) returns contents of postFBTimeBox as a double


% --- Executes during object creation, after setting all properties.
function postFBTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postFBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FBTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to FBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FBTimeBox as text
%        str2double(get(hObject,'String')) returns contents of FBTimeBox as a double


% --- Executes during object creation, after setting all properties.
function FBTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function preFBTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to preFBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of preFBTimeBox as text
%        str2double(get(hObject,'String')) returns contents of preFBTimeBox as a double


% --- Executes during object creation, after setting all properties.
function preFBTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to preFBTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialTimeBox_Callback(hObject, eventdata, handles)
% hObject    handle to trialTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialTimeBox as text
%        str2double(get(hObject,'String')) returns contents of trialTimeBox as a double


% --- Executes during object creation, after setting all properties.
function trialTimeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialTimeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trialsBox_Callback(hObject, eventdata, handles)
% hObject    handle to trialsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trialsBox as text
%        str2double(get(hObject,'String')) returns contents of trialsBox as a double


% --- Executes during object creation, after setting all properties.
function trialsBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trialsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bckgrndRBox_Callback(hObject, eventdata, handles)
% hObject    handle to bckgrndRBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bckgrndRBox as text
%        str2double(get(hObject,'String')) returns contents of bckgrndRBox as a double


% --- Executes during object creation, after setting all properties.
function bckgrndRBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bckgrndRBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bckgrndGBox_Callback(hObject, eventdata, handles)
% hObject    handle to bckgrndGBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bckgrndGBox as text
%        str2double(get(hObject,'String')) returns contents of bckgrndGBox as a double


% --- Executes during object creation, after setting all properties.
function bckgrndGBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bckgrndGBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bckgrndBBox_Callback(hObject, eventdata, handles)
% hObject    handle to bckgrndBBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bckgrndBBox as text
%        str2double(get(hObject,'String')) returns contents of bckgrndBBox as a double


% --- Executes during object creation, after setting all properties.
function bckgrndBBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bckgrndBBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FBRBox_Callback(hObject, eventdata, handles)
% hObject    handle to FBRBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FBRBox as text
%        str2double(get(hObject,'String')) returns contents of FBRBox as a double


% --- Executes during object creation, after setting all properties.
function FBRBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBRBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FBGBox_Callback(hObject, eventdata, handles)
% hObject    handle to FBGBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FBGBox as text
%        str2double(get(hObject,'String')) returns contents of FBGBox as a double


% --- Executes during object creation, after setting all properties.
function FBGBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBGBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FBBBox_Callback(hObject, eventdata, handles)
% hObject    handle to FBBBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FBBBox as text
%        str2double(get(hObject,'String')) returns contents of FBBBox as a double


% --- Executes during object creation, after setting all properties.
function FBBBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBBBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FBSizeBox_Callback(hObject, eventdata, handles)
% hObject    handle to FBSizeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FBSizeBox as text
%        str2double(get(hObject,'String')) returns contents of FBSizeBox as a double


% --- Executes during object creation, after setting all properties.
function FBSizeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBSizeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minBox_Callback(hObject, eventdata, handles)
% hObject    handle to minBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minBox as text
%        str2double(get(hObject,'String')) returns contents of minBox as a double


% --- Executes during object creation, after setting all properties.
function minBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxBox_Callback(hObject, eventdata, handles)
% hObject    handle to maxBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxBox as text
%        str2double(get(hObject,'String')) returns contents of maxBox as a double


% --- Executes during object creation, after setting all properties.
function maxBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in feebackChk.
function feebackChk_Callback(hObject, eventdata, handles)
% hObject    handle to feebackChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of feebackChk


% --- Executes on button press in blindChk.
function blindChk_Callback(hObject, eventdata, handles)
% hObject    handle to blindChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blindChk


% --- Executes on button press in soundChk.
function soundChk_Callback(hObject, eventdata, handles)
% hObject    handle to soundChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of soundChk


% --- Executes on selection change in FBTypePop.
function FBTypePop_Callback(hObject, eventdata, handles)
% hObject    handle to FBTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FBTypePop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FBTypePop


% --- Executes during object creation, after setting all properties.
function FBTypePop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FBTypePop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in INTypeBox.
function INTypeBox_Callback(hObject, eventdata, handles)
% hObject    handle to INTypeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns INTypeBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from INTypeBox


% --- Executes during object creation, after setting all properties.
function INTypeBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INTypeBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in verticalChk.
function verticalChk_Callback(hObject, eventdata, handles)
% hObject    handle to verticalChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of verticalChk


% --- Executes on button press in clockAppear.
function clockAppear_Callback(hObject, eventdata, handles)
% hObject    handle to clockAppear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of clockAppear


% --- Executes on button press in randFBChk.
function randFBChk_Callback(hObject, eventdata, handles)
% hObject    handle to randFBChk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of randFBChk



function digitClrR_Callback(hObject, eventdata, handles)
% hObject    handle to digitClrR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitClrR as text
%        str2double(get(hObject,'String')) returns contents of digitClrR as a double


% --- Executes during object creation, after setting all properties.
function digitClrR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitClrR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digitClrG_Callback(hObject, eventdata, handles)
% hObject    handle to digitClrG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitClrG as text
%        str2double(get(hObject,'String')) returns contents of digitClrG as a double


% --- Executes during object creation, after setting all properties.
function digitClrG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitClrG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function digitClrB_Callback(hObject, eventdata, handles)
% hObject    handle to digitClrB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of digitClrB as text
%        str2double(get(hObject,'String')) returns contents of digitClrB as a double


% --- Executes during object creation, after setting all properties.
function digitClrB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitClrB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskClrR_Callback(hObject, eventdata, handles)
% hObject    handle to maskClrR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskClrR as text
%        str2double(get(hObject,'String')) returns contents of maskClrR as a double


% --- Executes during object creation, after setting all properties.
function maskClrR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskClrR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskClrG_Callback(hObject, eventdata, handles)
% hObject    handle to maskClrG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskClrG as text
%        str2double(get(hObject,'String')) returns contents of maskClrG as a double


% --- Executes during object creation, after setting all properties.
function maskClrG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskClrG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskClrB_Callback(hObject, eventdata, handles)
% hObject    handle to maskClrB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskClrB as text
%        str2double(get(hObject,'String')) returns contents of maskClrB as a double


% --- Executes during object creation, after setting all properties.
function maskClrB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskClrB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in subjRealFB.
function subjRealFB_Callback(hObject, eventdata, handles)
% hObject    handle to subjRealFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of subjRealFB


% --- Executes on button press in copySubjFB.
function copySubjFB_Callback(hObject, eventdata, handles)
% hObject    handle to copySubjFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of copySubjFB



function inOffsetBox_Callback(hObject, eventdata, handles)
% hObject    handle to inOffsetBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inOffsetBox as text
%        str2double(get(hObject,'String')) returns contents of inOffsetBox as a double


% --- Executes during object creation, after setting all properties.
function inOffsetBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inOffsetBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
