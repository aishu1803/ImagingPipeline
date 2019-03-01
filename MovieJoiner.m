function varargout = MovieJoiner(varargin)
% MOVIEJOINER M-file for MovieJoiner.fig
%      MOVIEJOINER, by itself, creates a new MOVIEJOINER or raises the existing
%      singleton*.
%
%      H = MOVIEJOINER returns the handle to a new MOVIEJOINER or the handle to
%      the existing singleton*.
%
%      MOVIEJOINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIEJOINER.M with the given input arguments.
%
%      MOVIEJOINER('Property','Value',...) creates a new MOVIEJOINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MovieJoiner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MovieJoiner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Edit the above text to modify the response to help MovieJoiner
% Last Modified by GUIDE v2.5 06-Feb-2008 14:00:25
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MovieJoiner_OpeningFcn, ...
                   'gui_OutputFcn',  @MovieJoiner_OutputFcn, ...
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
% --- Executes just before MovieJoiner is made visible.
function MovieJoiner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MovieJoiner (see VARARGIN)
% Choose default command line output for MovieJoiner
handles.output = hObject;
handles.aviFiles={};
handles.FileNumber=0;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes MovieJoiner wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% --- Outputs from this function are returned to the command line.
function varargout = MovieJoiner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on selection change in FileList.
function FileList_Callback(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns FileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileList
% --- Executes during object creation, after setting all properties.
function FileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in addFiles.
function addFiles_Callback(hObject, eventdata, handles)
% hObject    handle to addFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uigetfile({'*.avi'},'Select avi files','MultiSelect','on');
if isa(FileName, 'cell')==0
    FileName = {FileName};
end
n=length(FileName);
for k=1:n
    handles.aviFiles{handles.FileNumber+k}=[PathName FileName{k}];
end
handles.FileNumber=handles.FileNumber+n;
set(handles.FileList,'String',handles.aviFiles(1,1:handles.FileNumber), 'Value', handles.FileNumber);
guidata(hObject, handles);
% --- Executes on button press in removeFiles.
function removeFiles_Callback(hObject, eventdata, handles)
% hObject    handle to removeFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
removeIdx=get(handles.FileList,'Value');
idx=true(1,handles.FileNumber);
idx(removeIdx)=false;
handles.aviFiles=handles.aviFiles(1,idx);
handles.FileNumber=length(handles.aviFiles);
set(handles.FileList,'String',handles.aviFiles(1,1:handles.FileNumber),'Value', 1);
guidata(hObject, handles);
% --- Executes on button press in moveUpFiles.
function moveUpFiles_Callback(hObject, eventdata, handles)
% hObject    handle to moveUpFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.FileList,'Value');
for k=idx
    if k>1
        tmp=handles.aviFiles(1,k-1);
        handles.aviFiles(1,k-1)=handles.aviFiles(1,k);
        handles.aviFiles(1,k)=tmp;
    else
        idx(1)=2;
    end
end
set(handles.FileList,'String',handles.aviFiles(1,1:handles.FileNumber),'Value', idx-1);
guidata(hObject, handles);
% --- Executes on button press in moveDownFiles.
function moveDownFiles_Callback(hObject, eventdata, handles)
% hObject    handle to moveDownFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx=get(handles.FileList,'Value');
for k=idx
    if k<handles.FileNumber
        tmp=handles.aviFiles(1,k+1);
        handles.aviFiles(1,k+1)=handles.aviFiles(1,k);
        handles.aviFiles(1,k)=tmp;
    else
        idx(end)=handles.FileNumber-1;
    end
end
set(handles.FileList,'String',handles.aviFiles(1,1:handles.FileNumber),'Value', idx+1);
guidata(hObject, handles);
% --- Executes on selection change in compMethod.
function compMethod_Callback(hObject, eventdata, handles)
% hObject    handle to compMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns compMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from compMethod
% --- Executes during object creation, after setting all properties.
function compMethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in compQuality.
function compQuality_Callback(hObject, eventdata, handles)
% hObject    handle to compQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns compQuality contents as cell array
%        contents{get(hObject,'Value')} returns selected item from compQuality
% --- Executes during object creation, after setting all properties.
function compQuality_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compQuality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on selection change in FPS.
function FPS_Callback(hObject, eventdata, handles)
% hObject    handle to FPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = get(hObject,'String') returns FPS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FPS
% --- Executes during object creation, after setting all properties.
function FPS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FPS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on button press in joinFiles.
function joinFiles_Callback(hObject, eventdata, handles)
% hObject    handle to joinFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName, PathName] = uiputfile({'binder.avi'},'Binding avi file');
vfname=[PathName FileName];
items=get(handles.compMethod, 'String');
idx=get(handles.compMethod, 'Value');
cfg.compression=items{idx};
items=get(handles.FPS, 'String');
idx=get(handles.FPS, 'Value');
cfg.fps=str2double(items{idx});
items=get(handles.compQuality, 'String');
idx=get(handles.compQuality, 'Value');
cfg.quality=str2double(items{idx});
handles.bindingFile=aviJoiner(handles.aviFiles,vfname,'configuration', cfg);
guidata(hObject, handles);
