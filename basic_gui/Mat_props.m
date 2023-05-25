function varargout = Mat_props(varargin)
% MAT_PROPS MATLAB code for Mat_props.fig
%      MAT_PROPS, by itself, creates a new MAT_PROPS or raises the existing
%      singleton*.
%
%      H = MAT_PROPS returns the handle to a new MAT_PROPS or the handle to
%      the existing singleton*.
%
%      MAT_PROPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAT_PROPS.M with the given input arguments.
%
%      MAT_PROPS('Property','Value',...) creates a new MAT_PROPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mat_props_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mat_props_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mat_props

% Last Modified by GUIDE v2.5 29-Mar-2023 16:02:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mat_props_OpeningFcn, ...
                   'gui_OutputFcn',  @Mat_props_OutputFcn, ...
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


% --- Executes just before Mat_props is made visible.
function Mat_props_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mat_props (see VARARGIN)

% Choose default command line output for Mat_props
handles.output.eq_fermi = 0.1;
handles.output.temp = 300;
handles.output.hoppings = -2.8;
handles.output.onsite = 0;
handles.output.n_sides = 6;
handles.output.lattice_len = 1.42e-10;

guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Mat_props_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


function eq_fermi_Callback(hObject, eventdata, handles)
% hObject    handle to eq_fermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eq_fermi as text
%        str2double(get(hObject,'String')) returns contents of eq_fermi as a double


% --- Executes during object creation, after setting all properties.
function eq_fermi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eq_fermi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function temp_Callback(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of temp as text
%        str2double(get(hObject,'String')) returns contents of temp as a double


% --- Executes during object creation, after setting all properties.
function temp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to temp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hoppings_Callback(hObject, eventdata, handles)
% hObject    handle to hoppings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hoppings as text
%        str2double(get(hObject,'String')) returns contents of hoppings as a double


% --- Executes during object creation, after setting all properties.
function hoppings_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hoppings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onsite_Callback(hObject, eventdata, handles)
% hObject    handle to onsite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onsite as text
%        str2double(get(hObject,'String')) returns contents of onsite as a double


% --- Executes during object creation, after setting all properties.
function onsite_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onsite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_sides_Callback(hObject, eventdata, handles)
% hObject    handle to n_sides (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_sides as text
%        str2double(get(hObject,'String')) returns contents of n_sides as a double


% --- Executes during object creation, after setting all properties.
function n_sides_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_sides (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lattice_len_Callback(hObject, eventdata, handles)
% hObject    handle to lattice_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lattice_len as text
%        str2double(get(hObject,'String')) returns contents of lattice_len as a double


% --- Executes during object creation, after setting all properties.
function lattice_len_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lattice_len (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply_btn.
function apply_btn_Callback(hObject, eventdata, handles)
% hObject    handle to apply_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.eq_fermi = str2double(handles.eq_fermi.String);
handles.output.temp = str2double(handles.temp.String);
handles.output.hoppings = str2double(handles.hoppings.String);
handles.output.onsite = str2double(handles.onsite.String);
handles.output.n_sides = str2double(handles.n_sides.String);
handles.output.lattice_len = str2double(handles.lattice_len.String);
guidata(hObject, handles);
mat_prop_CloseRequestFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close mat_prop.
function mat_prop_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mat_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();
