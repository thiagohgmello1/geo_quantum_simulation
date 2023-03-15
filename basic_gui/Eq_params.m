function varargout = Eq_params(varargin)
% EQ_PARAMS MATLAB code for Eq_params.fig
%      EQ_PARAMS, by itself, creates a new EQ_PARAMS or raises the existing
%      singleton*.
%
%      H = EQ_PARAMS returns the handle to a new EQ_PARAMS or the handle to
%      the existing singleton*.
%
%      EQ_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EQ_PARAMS.M with the given input arguments.
%
%      EQ_PARAMS('Property','Value',...) creates a new EQ_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Eq_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Eq_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Eq_params

% Last Modified by GUIDE v2.5 03-Feb-2023 15:22:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Eq_params_OpeningFcn, ...
                   'gui_OutputFcn',  @Eq_params_OutputFcn, ...
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


% --- Executes just before Eq_params is made visible.
function Eq_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Eq_params (see VARARGIN)

% Choose default command line output for Eq_params
handles.output.m = 0;
handles.output.d = 0;
handles.output.c = 0;
handles.output.a = 0;
handles.output.f = 0;

handles.laxis = axes('parent',hObject,'units','normalized','position',[0 0 1 1],'visible','off');
% Find all static text UICONTROLS whose 'Tag' starts with latex_
lbls = findobj(hObject,'-regexp','tag','latex_*');
for i=1:length(lbls)
      l = lbls(i);
      % Get current text, position and tag
      set(l,'units','normalized');
      s = get(l,'string');
      p = get(l,'position');
      t = get(l,'tag');
      % Remove the UICONTROL
      delete(l);
      % Replace it with a TEXT object 
      handles.(t) = text(p(1),p(2),s,'interpreter','latex');
end

% Update handles structure
guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Eq_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);



function m_param_Callback(hObject, eventdata, handles)
% hObject    handle to m_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m_param as text
%        str2double(get(hObject,'String')) returns contents of m_param as a double


% --- Executes during object creation, after setting all properties.
function m_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a_param_Callback(hObject, eventdata, handles)
% hObject    handle to a_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a_param as text
%        str2double(get(hObject,'String')) returns contents of a_param as a double


% --- Executes during object creation, after setting all properties.
function a_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function d_param_Callback(hObject, eventdata, handles)
% hObject    handle to d_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of d_param as text
%        str2double(get(hObject,'String')) returns contents of d_param as a double


% --- Executes during object creation, after setting all properties.
function d_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to d_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_param_Callback(hObject, eventdata, handles)
% hObject    handle to f_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_param as text
%        str2double(get(hObject,'String')) returns contents of f_param as a double


% --- Executes during object creation, after setting all properties.
function f_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function c_param_Callback(hObject, eventdata, handles)
% hObject    handle to c_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_param as text
%        str2double(get(hObject,'String')) returns contents of c_param as a double


% --- Executes during object creation, after setting all properties.
function c_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_param (see GCBO)
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
handles.output.m = str2double(handles.m_param.String);
handles.output.d = str2double(handles.d_param.String);
handles.output.c = str2double(handles.c_param.String);
handles.output.a = str2double(handles.a_param.String);
handles.output.f = str2double(handles.f_param.String);
guidata(hObject, handles);
eq_param_CloseRequestFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close eq_param.
function eq_param_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to eq_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();
