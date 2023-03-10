function varargout = Mesh_plot(varargin)
% MESH_PLOT MATLAB code for Mesh_plot.fig
%      MESH_PLOT, by itself, creates a new MESH_PLOT or raises the existing
%      singleton*.
%
%      H = MESH_PLOT returns the handle to a new MESH_PLOT or the handle to
%      the existing singleton*.
%
%      MESH_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MESH_PLOT.M with the given input arguments.
%
%      MESH_PLOT('Property','Value',...) creates a new MESH_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Mesh_plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Mesh_plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Mesh_plot

% Last Modified by GUIDE v2.5 06-Feb-2023 12:51:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Mesh_plot_OpeningFcn, ...
                   'gui_OutputFcn',  @Mesh_plot_OutputFcn, ...
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


% --- Executes just before Mesh_plot is made visible.
function Mesh_plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Mesh_plot (see VARARGIN)

handles.output = true;

if ~isempty(varargin)
    pdeplot(varargin{1});
end

guidata(hObject, handles);
uiwait();


% --- Outputs from this function are returned to the command line.
function varargout = Mesh_plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(hObject);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume();
