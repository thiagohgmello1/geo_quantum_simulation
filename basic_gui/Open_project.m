function varargout = Open_project(varargin)
% OPEN_PROJECT MATLAB code for Open_project.fig
%      OPEN_PROJECT, by itself, creates a new OPEN_PROJECT or raises the existing
%      singleton*.
%
%      H = OPEN_PROJECT returns the handle to a new OPEN_PROJECT or the handle to
%      the existing singleton*.
%
%      OPEN_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPEN_PROJECT.M with the given input arguments.
%
%      OPEN_PROJECT('Property','Value',...) creates a new OPEN_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Open_project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Open_project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Open_project

% Last Modified by GUIDE v2.5 29-Mar-2023 17:27:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Open_project_OpeningFcn, ...
                   'gui_OutputFcn',  @Open_project_OutputFcn, ...
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


% --- Executes just before Open_project is made visible.
function Open_project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Open_project (see VARARGIN)

% Choose default command line output for Open_project
handles.output = {};

% Update handles structure
guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Open_project_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes on button press in open_btn.
function open_btn_Callback(hObject, eventdata, handles)
% hObject    handle to open_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
default_path = 'D:\CEFET\Mestrado\quantum_model_matlab\inputs';
default_file = 'diode5.svg';
check_path = isfolder(default_path);
if check_path
    [file,path] = uigetfile(strjoin({default_path, default_file}, '\'),'*.svg');
else
    [file,path] = uigetfile('*.svg');
end
set(handles.select_project, 'string', [path, file]);



% --- Executes on button press in ok_btn.
function ok_btn_Callback(hObject, eventdata, handles)
% hObject    handle to ok_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
Open_project_CloseRequestFcn(hObject, eventdata, handles)


% --- Executes when user attempts to close Open_project.
function Open_project_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Open_project (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();
