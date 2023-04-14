function varargout = Boundaries_values(varargin)
% BOUNDARIES_VALUES MATLAB code for Boundaries_values.fig
%      BOUNDARIES_VALUES, by itself, creates a new BOUNDARIES_VALUES or raises the existing
%      singleton*.
%
%      H = BOUNDARIES_VALUES returns the handle to a new BOUNDARIES_VALUES or the handle to
%      the existing singleton*.
%
%      BOUNDARIES_VALUES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOUNDARIES_VALUES.M with the given input arguments.
%
%      BOUNDARIES_VALUES('Property','Value',...) creates a new BOUNDARIES_VALUES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Boundaries_values_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Boundaries_values_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Boundaries_values

% Last Modified by GUIDE v2.5 13-Apr-2023 14:25:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Boundaries_values_OpeningFcn, ...
                   'gui_OutputFcn',  @Boundaries_values_OutputFcn, ...
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


% --- Executes just before Boundaries_values is made visible.
function Boundaries_values_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Boundaries_values (see VARARGIN)
dir_eq = 'hu=r';
neu_eq = 'n*c*grad(u)+q*u=g';

if  ~isempty(varargin) && varargin{1} == 1
    handles.bound = 'dir';
    handles.bound_values.Title = 'Dirichlet';
    set(handles.q_entry, 'enable', 'off');
    set(handles.g_entry, 'enable', 'off');
    set(handles.eq_string, 'String', dir_eq);
else
    handles.bound = 'neu';
    handles.bound_values.Title = 'Neumann';
    set(handles.h_entry, 'enable', 'off');
    set(handles.r_entry, 'enable', 'off');
    set(handles.eq_string, 'String', neu_eq);
    set(handles.lead_eq, 'enable', 'off');
    set(handles.trans_dir, 'enable', 'off');
end

default_bounds.h = [];
default_bounds.r = [];
default_bounds.q = [];
default_bounds.g = [];
default_contact_eq = str2func('@(x, y) 1');
default_trans_dir = [1, 0];

% Choose default command line output for Boundaries_values
handles.output = default_bounds;
handles.output.lead_eq = default_contact_eq;
handles.output.trans_dir = default_trans_dir;
handles.output.status = false;
% Update handles structure
guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Boundaries_values_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);



function h_entry_Callback(hObject, eventdata, handles)
% hObject    handle to h_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h_entry as text
%        str2double(get(hObject,'String')) returns contents of h_entry as a double


% --- Executes during object creation, after setting all properties.
function h_entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function r_entry_Callback(hObject, eventdata, handles)
% hObject    handle to r_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_entry as text
%        str2double(get(hObject,'String')) returns contents of r_entry as a double


% --- Executes during object creation, after setting all properties.
function r_entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function q_entry_Callback(hObject, eventdata, handles)
% hObject    handle to q_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of q_entry as text
%        str2double(get(hObject,'String')) returns contents of q_entry as a double


% --- Executes during object creation, after setting all properties.
function q_entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to q_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g_entry_Callback(hObject, eventdata, handles)
% hObject    handle to g_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g_entry as text
%        str2double(get(hObject,'String')) returns contents of g_entry as a double


% --- Executes during object creation, after setting all properties.
function g_entry_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g_entry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in apply.
function apply_Callback(hObject, eventdata, handles)
% hObject    handle to apply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(handles.bound, 'dir')
    handles.output.h = str2double(handles.h_entry.String);
    handles.output.r = str2double(handles.r_entry.String);
    lead_eq = str2func(['@(x, y)' handles.lead_eq.String]);
    handles.output.lead_eq = lead_eq;
    handles.output.trans_dir = str2num(handles.trans_dir.String);
else
    handles.output.q = str2double(handles.q_entry.String);
    handles.output.g = str2double(handles.g_entry.String);
end
handles.output.status = true;
guidata(hObject, handles);
bound_params_CloseRequestFcn(hObject, eventdata, handles)


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.h = [];
handles.output.r = [];
handles.output.q = [];
handles.output.g = [];
handles.output.status = false;
guidata(hObject, handles);
bound_params_CloseRequestFcn(hObject, eventdata, handles);


% --- Executes when user attempts to close bound_params.
function bound_params_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to bound_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();



function lead_eq_Callback(hObject, eventdata, handles)
% hObject    handle to lead_eq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lead_eq as text
%        str2double(get(hObject,'String')) returns contents of lead_eq as a double


% --- Executes during object creation, after setting all properties.
function lead_eq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lead_eq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function trans_dir_Callback(hObject, eventdata, handles)
% hObject    handle to trans_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trans_dir as text
%        str2double(get(hObject,'String')) returns contents of trans_dir as a double


% --- Executes during object creation, after setting all properties.
function trans_dir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trans_dir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
