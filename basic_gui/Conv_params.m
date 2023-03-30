function varargout = Conv_params(varargin)
% CONV_PARAMS MATLAB code for Conv_params.fig
%      CONV_PARAMS, by itself, creates a new CONV_PARAMS or raises the existing
%      singleton*.
%
%      H = CONV_PARAMS returns the handle to a new CONV_PARAMS or the handle to
%      the existing singleton*.
%
%      CONV_PARAMS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONV_PARAMS.M with the given input arguments.
%
%      CONV_PARAMS('Property','Value',...) creates a new CONV_PARAMS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Conv_params_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Conv_params_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Conv_params

% Last Modified by GUIDE v2.5 29-Mar-2023 16:45:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Conv_params_OpeningFcn, ...
                   'gui_OutputFcn',  @Conv_params_OutputFcn, ...
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


% --- Executes just before Conv_params is made visible.
function Conv_params_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Conv_params (see VARARGIN)

% Choose default command line output for Conv_params
handles.output.eta = 10e-3;
handles.output.self_e_conv = 1e-4;
handles.output.max_iter = 10;
handles.output.delta_U = 1e-4;

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
function varargout = Conv_params_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes when user attempts to close Conv_params.
function Conv_params_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Conv_params (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();


% --- Executes on button press in apply_btn.
function apply_btn_Callback(hObject, eventdata, handles)
% hObject    handle to apply_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output.eta = str2double(handles.eta.String);
handles.output.self_e_conv = str2double(handles.self_e_conv.String);
handles.output.max_iter = str2double(handles.max_iter.String);
handles.output.delta_U = str2double(handles.delta_U.String);
guidata(hObject, handles);
Conv_params_CloseRequestFcn(hObject, eventdata, handles)


function eta_Callback(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta as text
%        str2double(get(hObject,'String')) returns contents of eta as a double


% --- Executes during object creation, after setting all properties.
function eta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function self_e_conv_Callback(hObject, eventdata, handles)
% hObject    handle to self_e_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of self_e_conv as text
%        str2double(get(hObject,'String')) returns contents of self_e_conv as a double


% --- Executes during object creation, after setting all properties.
function self_e_conv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to self_e_conv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_iter_Callback(hObject, eventdata, handles)
% hObject    handle to max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_iter as text
%        str2double(get(hObject,'String')) returns contents of max_iter as a double


% --- Executes during object creation, after setting all properties.
function max_iter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_iter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_U_Callback(hObject, eventdata, handles)
% hObject    handle to delta_U (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_U as text
%        str2double(get(hObject,'String')) returns contents of delta_U as a double


% --- Executes during object creation, after setting all properties.
function delta_U_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_U (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
