function varargout = tohelp(varargin)
% TOHELP MATLAB code for tohelp.fig
%      TOHELP, by itself, creates a new TOHELP or raises the existing
%      singleton*.
%
%      H = TOHELP returns the handle to a new TOHELP or the handle to
%      the existing singleton*.
%
%      TOHELP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOHELP.M with the given input arguments.
%
%      TOHELP('Property','Value',...) creates a new TOHELP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tohelp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tohelp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tohelp

% Last Modified by GUIDE v2.5 06-Dec-2013 11:29:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tohelp_OpeningFcn, ...
                   'gui_OutputFcn',  @tohelp_OutputFcn, ...
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


% --- Executes just before tohelp is made visible.
function tohelp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tohelp (see VARARGIN)

% Choose default command line output for tohelp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tohelp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tohelp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
