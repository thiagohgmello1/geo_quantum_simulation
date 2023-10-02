function varargout = Boundaries(varargin)
% BOUNDARIES MATLAB code for Boundaries.fig
%      BOUNDARIES, by itself, creates a new BOUNDARIES or raises the existing
%      singleton*.
%
%      H = BOUNDARIES returns the handle to a new BOUNDARIES or the handle to
%      the existing singleton*.
%
%      BOUNDARIES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOUNDARIES.M with the given input arguments.
%
%      BOUNDARIES('Property','Value',...) creates a new BOUNDARIES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Boundaries_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Boundaries_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Boundaries

% Last Modified by GUIDE v2.5 28-Sep-2023 09:53:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Boundaries_OpeningFcn, ...
                   'gui_OutputFcn',  @Boundaries_OutputFcn, ...
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


% --- Executes just before Boundaries is made visible.
function Boundaries_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Boundaries (see VARARGIN)

if ~isempty(varargin)
    handles.model = varargin{1};
    handles.geometry = varargin{2};
    handles.G = varargin{3};
    handles.map_edges = map_edges(handles.G, handles.geometry);
    pdegplot(varargin{1},'EdgeLabels','on');
    axis padded;
end

% Choose default command line output for Boundaries
default_eq_params.m = 0;
default_eq_params.d = 0;
default_eq_params.c = 1;
default_eq_params.a = 0;
default_eq_params.f = 0;

default_bound_conds.dir = [];
default_bound_conds.neu = [];

handles.output.boundaries = default_bound_conds;
handles.output.params = default_eq_params;

% Update handles structure
guidata(hObject, handles);
uiwait();



% --- Executes when user attempts to close boundaries_cond.
function boundaries_cond_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to boundaries_cond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume();



% --- Outputs from this function are returned to the command line.
function varargout = Boundaries_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in Dirichlet_bound.
function Dirichlet_bound_Callback(hObject, eventdata, handles)
% hObject    handle to Dirichlet_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bound.params = Boundaries_values(1);
if bound.params.status == true
    bound.edges = read_edit_text(gcbo, handles.diric.String);
    bound.nodes = handles.nodes;
    if ~isempty(bound.edges)
        handles.output.boundaries.dir = [handles.output.boundaries.dir, bound];
        set(handles.diric, 'string', '');
    end
end
guidata(hObject, handles);



% --- Executes on button press in Neumann_bound.
function Neumann_bound_Callback(hObject, eventdata, handles)
% hObject    handle to Neumann_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bound.params = Boundaries_values(0);
if bound.params.status == true
    bound.edges = read_edit_text(gcbo, handles.newm.String);
    if ~isempty(bound.edges)
        handles.output.boundaries.neu = [handles.output.boundaries.neu, bound];
        set(handles.newm, 'string', '');
    end
end
guidata(hObject, handles);



% --- Executes on button press in Export_bound.
function Export_bound_Callback(hObject, eventdata, handles)
% hObject    handle to Export_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

apply_bounds(handles.model, handles.output.boundaries);
apply_params(handles.model, handles.output.params);
handles.output.mesh = Mesh_params(handles.model, handles.output, @apply_mesh);
guidata(hObject, handles);



function diric_Callback(hObject, eventdata, handles)
% hObject    handle to diric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diric as text
%        str2double(get(hObject,'String')) returns contents of diric as a double



% --- Executes during object creation, after setting all properties.
function diric_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diric (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function newm_Callback(hObject, eventdata, handles)
% hObject    handle to newm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of newm as text
%        str2double(get(hObject,'String')) returns contents of newm as a double



% --- Executes during object creation, after setting all properties.
function newm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to newm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function PDE_eq_Callback(hObject, eventdata, handles)
% hObject    handle to PDE_eq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Eq_params_Callback(hObject, eventdata, handles)
% hObject    handle to Eq_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.params = Eq_params;
guidata(hObject, handles);


% --------------------------------------------------------------------
function def_bound_params_Callback(hObject, eventdata, handles)
% hObject    handle to def_bound_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in draw_roi_dir.
function draw_roi_dir_Callback(hObject, eventdata, handles)
% hObject    handle to draw_roi_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dir_roi = drawpolygon;

edges = get_edges(handles.geometry, dir_roi);
already_edges = read_edit_text(gcbo, handles.diric.String, false);
if edges
    edges = sort(unique([already_edges edges]));
    edges = cell2mat(join(arrayfun(@num2str, edges, 'UniformOutput', false), ','));
    handles.nodes = get_nodes(handles.map_edges, edges);
    set(handles.diric, 'string', edges);
end

delete(dir_roi);
guidata(hObject, handles);
uiwait();


% --- Executes on button press in draw_roi_neu.
function draw_roi_neu_Callback(hObject, eventdata, handles)
% hObject    handle to draw_roi_neu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
neu_roi = drawpolygon;

edges = get_edges(handles.geometry, neu_roi);
already_edges = read_edit_text(gcbo, handles.newm.String, false);
if edges
    edges = sort(unique([already_edges edges]));
    edges = cell2mat(join(arrayfun(@num2str, edges, 'UniformOutput', false), ','));
    set(handles.newm, 'string', edges);
end

delete(neu_roi);
guidata(hObject, handles);
uiwait();


% --- Executes on button press in show_bounds.
function show_bounds_Callback(hObject, eventdata, handles)
% hObject    handle to show_bounds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_bounds
bound_status = get(hObject,'Value');
if bound_status == true
    bound_status = 'on';
else
    bound_status = 'off';
end
pdegplot(handles.geometry,'EdgeLabels',bound_status);
axis padded;


% --------------------------------------------------------------------
function open_file_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.file_name = Open_project;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate graph


% --- Executes on mouse press over axes background.
function graph_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
