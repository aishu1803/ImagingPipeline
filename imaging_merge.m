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

% Last Modified by GUIDE v2.5 22-Oct-2018 16:05:06

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
handles.N_neurons = size(handles.rawdata1.results.C_raw,1);
Cent_N = zeros(size(handles.rawdata1.results.C_raw,1),2);
A = reshape(full(handles.rawdata1.results.A)',handles.N_neurons,handles.rawdata1.results.options.d1,handles.rawdata1.results.options.d2);
for i = 1:handles.N_neurons
    [tmp_r,tmp_c] = find(squeeze(A(i,:,:)));
    Cent_N(i,:) =[mean(tmp_r) mean(tmp_c)];
end
C = handles.rawdata1.results.C_raw;
for i = 1:handles.N_neurons
    for j = 1:handles.N_neurons
        handles.pwdist(i,j) = sqrt((Cent_N(i,1) - Cent_N(j,1))^2 + (Cent_N(i,2) - Cent_N(j,2))^2);
       handles.crosscoef(i,j) = corr(C(i,:)',C(j,:)');
    end
end
handles.pwdist = tril(handles.pwdist);

[handles.r,handles.co] = find(handles.pwdist>0 & handles.pwdist < str2num(get(handles.dist,'String')) & handles.crosscoef>str2num(get(handles.corr,'String')));
plot(handles.ax1,C(handles.r(1),:),'-r');
hold(handles.ax1,'on')
plot(handles.ax1,C(handles.co(1),:),'-b');
hold(handles.ax1,'off')

str = sprintf('Cell 1 - %d \n Cell 2 - %d \n Dist b/w them - %0.2d Crosscorr - %0.2d', handles.r(1),handles.co(1),handles.pwdist(handles.r(1),handles.co(1)),handles.crosscoef(handles.r(1),handles.co(1)));
title(handles.ax1,str);
legend(handles.ax1,'Cell 1','Cell 2');
handles.currentcompare = 1;
[r1,c1] = find(squeeze(A(handles.r(1),:,:)));
[r2,c2] = find(squeeze(A(handles.co(1),:,:)));
imagesc(handles.rawdata1.results.Cn',[0 1]);
set(handles.ax2,'YDir','normal')
hold(handles.ax2,'on')
plot(handles.ax2,r1,c1,'.r')
plot(handles.ax2,r2,c2,'.b')
hold(handles.ax2,'off')
x_pixel =handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.ax2,[0 x_pixel])
ylim(handles.ax2,[0 y_pixel])
title(handles.ax2,'Spatial locations of the cells')
handles.updatedresults = handles.rawdata1.results.C_raw(setdiff(1:handles.N_neurons,unique([handles.r handles.co])),:);
handles.mergedcells = [];
size(handles.updatedresults)
guidata(hObject,handles);


% --- Executes on button press in pre.
function pre_Callback(hObject, eventdata, handles)
% hObject    handle to pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C = handles.rawdata1.results.C_raw;
if handles.currentcompare~=1
    k = handles.currentcompare-1;
    handles.currentcompare = k;
    plot(handles.ax1,C(handles.r(k),:),'-r');
hold(handles.ax1,'on')
plot(handles.ax1,C(handles.co(k),:),'-b');
hold(handles.ax1,'off')
str = sprintf('Cell 1 - %d \n Cell 2 - %d \n Dist b/w them - %0.2d Crosscorr - %0.2d', handles.r(k),handles.co(k),handles.pwdist(handles.r(k),handles.co(k)),handles.crosscoef(handles.r(k),handles.co(k)));
title(handles.ax1,str);
legend(handles.ax1,'Cell 1','Cell 2');
A = reshape(full(handles.rawdata1.results.A)',handles.N_neurons,handles.rawdata1.results.options.d1,handles.rawdata1.results.options.d2);
[r1,c1] = find(squeeze(A(handles.r(k),:,:)));
[r2,c2] = find(squeeze(A(handles.co(k),:,:)));
imagesc(handles.rawdata1.results.Cn',[0 1]);
set(handles.ax2,'YDir','normal')
hold(handles.ax2,'on')
plot(handles.ax2,r1,c1,'.r')
plot(handles.ax2,r2,c2,'.b')
hold(handles.ax2,'off')
x_pixel = handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.ax2,[0 x_pixel])
ylim(handles.ax2,[0 y_pixel])
title(handles.ax2,'Spatial locations of the cells')
end
guidata(hObject,handles)

    


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C = handles.rawdata1.results.C_raw;

if handles.currentcompare~=length(handles.r)
    k = handles.currentcompare+1;
    handles.currentcompare = k;
    plot(handles.ax1,C(handles.r(k),:),'-r');
hold(handles.ax1,'on')
plot(handles.ax1,C(handles.co(k),:),'-b');
hold(handles.ax1,'off')
str = sprintf('Cell 1 - %d \n Cell 2 - %d \n Dist b/w them - %0.2d Crosscorr - %0.2d', handles.r(k),handles.co(k),handles.pwdist(handles.r(k),handles.co(k)),handles.crosscoef(handles.r(k),handles.co(k)));
title(handles.ax1,str);
legend(handles.ax1,'Cell 1','Cell 2');
A = reshape(full(handles.rawdata1.results.A)',handles.N_neurons,handles.rawdata1.results.options.d1,handles.rawdata1.results.options.d2);
[r1,c1] = find(squeeze(A(handles.r(k),:,:)));
[r2,c2] = find(squeeze(A(handles.co(k),:,:)));
imagesc(handles.rawdata1.results.Cn',[0 1]);
set(handles.ax2,'YDir','normal')
hold(handles.ax2,'on')
plot(handles.ax2,r1,c1,'.r')
plot(handles.ax2,r2,c2,'.b')
hold(handles.ax2,'off')
x_pixel = handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.ax2,[0 x_pixel])
ylim(handles.ax2,[0 y_pixel])
title(handles.ax2,'Spatial locations of the cells')
end
guidata(hObject,handles)


% --- Executes on selection change in cell1.
function cell1_Callback(hObject, eventdata, handles)
% hObject    handle to cell1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cell1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cell1

set(handles.cell1,'String',unique([handles.r handles.co]));
guidata(hObject,handles);


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
set(handles.cell2,'String',unique([handles.r handles.co]));
guidata(hObject,handles)


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
C = handles.rawdata1.results.C_raw;
un_cells = unique([handles.r handles.co]);
cell_1 = un_cells(cell2mat(get(handles.cell1,'Value')));
cell_2 = un_cells(cell2mat(get(handles.cell2,'Value')));
if ~ismember(cell_1,handles.mergedcells) && ~ismember(cell_2,handles.mergedcells)
merge_signal = mean([C(cell_1,:);C(cell_2,:)]);
 handles.updatedresults = [handles.updatedresults;merge_signal];
 handles.mergedcells = [handles.mergedcells cell_1 cell_2];
 set(handles.message,'String','Merged!');
else
    set(handles.message,'String','Already merged!');
end
size(handles.updatedresults)
guidata(hObject,handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.updatedresults = [handles.updatedresults;handles.rawdata1.results.C_raw(setdiff(unique([handles.r handles.co]),handles.mergedcells),:)];
folder_name = uigetdir;
file_str = sprintf('%s\\updated_Craw.mat',folder_name);
C_raw = handles.updatedresults;
size(C_raw)
setdiff(unique([handles.r handles.co]),handles.mergedcells)
handles.mergedcells
size(handles.mergedcells)
save(file_str,'C_raw');
guidata(hObject,handles);






function dist_Callback(hObject, eventdata, handles)
% hObject    handle to dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dist as text
%        str2double(get(hObject,'String')) returns contents of dist as a double


% --- Executes during object creation, after setting all properties.
function dist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function corr_Callback(hObject, eventdata, handles)
% hObject    handle to corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of corr as text
%        str2double(get(hObject,'String')) returns contents of corr as a double


% --- Executes during object creation, after setting all properties.
function corr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to corr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
