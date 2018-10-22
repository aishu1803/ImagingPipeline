function varargout = imaging_merge(varargin)
% IMAGING_MERGE MATLAB code for imaging_merge.fig
%      IMAGING_MERGE, by itself, creates a new IMAGING_MERGE or raises the existing
%      singleton*.
%
%      H = IMAGING_MERGE returns the handle to a new IMAGING_MERGE or the handle to
%      the existing singleton*.
%
%      IMAGING_MERGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGING_MERGE.M with the given input arguments.
%
%      IMAGING_MERGE('Property','Value',...) creates a new IMAGING_MERGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imaging_merge_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imaging_merge_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imaging_merge

% Last Modified by GUIDE v2.5 21-Oct-2018 21:37:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imaging_merge_OpeningFcn, ...
                   'gui_OutputFcn',  @imaging_merge_OutputFcn, ...
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


% --- Executes just before imaging_merge is made visible.
function imaging_merge_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imaging_merge (see VARARGIN)

% Choose default command line output for imaging_merge
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imaging_merge wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imaging_merge_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadFile.
function LoadFile_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename1,filepath1]=uigetfile({'*.*','All Files'},...
  'Select Data File 1');
handles.rawdata1=load([filepath1 filename1]);
n_cells = size(handles.rawdata1.C_raw,1);


% --- Executes on button press in pre.
function pre_Callback(hObject, eventdata, handles)
% hObject    handle to pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in cell1.
function cell1_Callback(hObject, eventdata, handles)
% hObject    handle to cell1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cell1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cell1


% --- Executes during object creation, after setting all properties.
function cell1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cell2.
function cell2_Callback(hObject, eventdata, handles)
% hObject    handle to cell2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cell2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cell2


% --- Executes during object creation, after setting all properties.
function cell2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in merge.
function merge_Callback(hObject, eventdata, handles)
% hObject    handle to merge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
