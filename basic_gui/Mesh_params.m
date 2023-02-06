function varargout = Mesh_params(varargin)
% MESH_PARAMS MATLAB code for Mesh_params.fig
%      MESH_PARAMS, by itself, creates a new MESH_PARAMS or raises the existing
%      singleton*.
%
%      H = MESH_PARAMS returns the handle to a new MESH_PARAMS or the handle to
%      the existing singleton*.
%
%      MESH_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MESH_PARAMS.M with the given input arguments.
%
%      MESH_PARAMS('Property','Value',...) creates a new MESH_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mesh_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mesh_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mesh_params

% Last Modified by GUIDE v2.5 06-Feb-2023 12:49:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mesh_params_OpeningFcn, ...
                   'gui_OutputFcn',  @Mesh_params_OutputFcn, ...
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


% --- Executes just before Mesh_params is made visible.
function Mesh_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mesh_params (see VARARGIN)

% Choose default command line output for Mesh_params
default_output.growth_rate = 1.5;
default_output.max_edge = -1;
default_output.min_edge = -1;
handles.output = default_output;
handles.apply_mesh = varargin{3};
handles.model = varargin{1};

% Update handles structure
guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Mesh_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.output.growth_rate = str2double(handles.growth_rate.String);
handles.output.max_edge = str2double(handles.max_edge.String);
handles.output.min_edge = str2double(handles.min_edge.String);

handles.apply_mesh(handles.model, handles.output);
guidata(hObject, handles);



function growth_rate_Callback(hObject, eventdata, handles)
% hObject    handle to growth_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of growth_rate as text
%        str2double(get(hObject,'String')) returns contents of growth_rate as a double


% --- Executes during object creation, after setting all properties.
function growth_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to growth_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_edge_Callback(hObject, eventdata, handles)
% hObject    handle to max_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_edge as text
%        str2double(get(hObject,'String')) returns contents of max_edge as a double


% --- Executes during object creation, after setting all properties.
function max_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function min_edge_Callback(hObject, eventdata, handles)
% hObject    handle to min_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_edge as text
%        str2double(get(hObject,'String')) returns contents of min_edge as a double


% --- Executes during object creation, after setting all properties.
function min_edge_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close mesh_params.
function mesh_params_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mesh_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.apply_mesh(handles.model, handles.output);
uiresume();


% --- Executes on button press in view_mesh.
function view_mesh_Callback(hObject, eventdata, handles)
% hObject    handle to view_mesh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Mesh_plot(handles.model)
