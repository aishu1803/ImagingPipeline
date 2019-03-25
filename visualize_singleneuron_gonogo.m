function varargout = visualize_singleneuron_gonogo(varargin)
% VISUALIZE_SINGLENEURON_GONOGO MATLAB code for visualize_singleneuron_gonogo.fig
%      VISUALIZE_SINGLENEURON_GONOGO, by itself, creates a new VISUALIZE_SINGLENEURON_GONOGO or raises the existing
%      singleton*.
%
%      H = VISUALIZE_SINGLENEURON_GONOGO returns the handle to a new VISUALIZE_SINGLENEURON_GONOGO or the handle to
%      the existing singleton*.
%
%      VISUALIZE_SINGLENEURON_GONOGO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VISUALIZE_SINGLENEURON_GONOGO.M with the given input arguments.
%
%      VISUALIZE_SINGLENEURON_GONOGO('Property','Value',...) creates a new VISUALIZE_SINGLENEURON_GONOGO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before visualize_singleneuron_gonogo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to visualize_singleneuron_gonogo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help visualize_singleneuron_gonogo

% Last Modified by GUIDE v2.5 19-Feb-2019 11:04:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_singleneuron_gonogo_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_singleneuron_gonogo_OutputFcn, ...
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


% --- Executes just before visualize_singleneuron_gonogo is made visible.
function visualize_singleneuron_gonogo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to visualize_singleneuron_gonogo (see VARARGIN)

% Choose default command line output for visualize_singleneuron_gonogo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes visualize_singleneuron_gonogo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = visualize_singleneuron_gonogo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ldresults.
function ldresults_Callback(hObject, eventdata, handles)
% hObject    handle to ldresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename1,filepath1]=uigetfile({'*.*','All Files'},...
  'Select Data File 1');
handles.rawdata1=load([filepath1 filename1]);
guidata(hObject,handles)


% --- Executes on button press in ldtrials.
function ldtrials_Callback(hObject, eventdata, handles)
% hObject    handle to ldtrials (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename1,filepath1]=uigetfile({'*.*','All Files'},...
  'Select Data File 1');
handles.tr=load([filepath1 filename1]);
handles.indnogoreward = find([handles.tr.trials.reward;]&[handles.tr.trials.nogo;]);
handles.indgoreward = find([handles.tr.trials.reward;]&~[handles.tr.trials.nogo;]);
handles.indreward = find([handles.tr.trials.reward;]);
handles.indleverpress = find([handles.tr.trials.leverpressframe;]);
guidata(hObject,handles)



% --- Executes on button press in pre.
function pre_Callback(hObject, eventdata, handles)
% hObject    handle to pre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.currentcell~=1
    k = handles.currentcell-1;
    tmp_nosepokenogo=[];
    handles.currentcell = k;
tmp_nosepokenogo=[];
tmp_nosepokego=[];
tmp_reward = [];
tmp_leverpress=[];nogo=[];go=[];
for i = 1:length(handles.indnogoreward)
    tmp_nosepokenogo = [tmp_nosepokenogo; handles.tr.trials(handles.indnogoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)+90)];
end
for i = 1:length(handles.indgoreward)
    tmp_nosepokego = [tmp_nosepokego; handles.tr.trials(handles.indgoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)+60)];
end
for i = 1:length(handles.indreward)
    tmp_reward = [tmp_reward; handles.tr.trials(handles.indreward(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indreward(i)).rewardframe-15:handles.tr.trials(handles.indreward(i)).rewardframe+30)];
    if handles.tr.trials(handles.indreward(i)).nogo
        nogo = [nogo i];
    else
        go = [go i];
    end
end
for i = 1:length(handles.indleverpress)
    tmp_leverpress = [tmp_leverpress; handles.tr.trials(handles.indleverpress(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indleverpress(i)).leverpressframe-15:handles.tr.trials(handles.indleverpress(i)).leverpressframe+30)];
end
axes(handles.nphold)
plot(handles.nphold,-15:1:90,mean(tmp_nosepokenogo),'-r')
hold(handles.nphold,'on')
plot(handles.nphold,-15:1:60,mean(tmp_nosepokego),'LineStyle','-','color',[0 0.8 0])
xdata_nogo = [-15:1:90 90:-1:-15];
xdata_go = [-15:1:60 60:-1:-15];
sem_nogo = std(tmp_nosepokenogo)/sqrt(size(tmp_nosepokenogo,1));
sem_go = std(tmp_nosepokego)/sqrt(size(tmp_nosepokego,1));
ydata_nogo = [mean(tmp_nosepokenogo)-sem_nogo fliplr(mean(tmp_nosepokenogo)+sem_nogo)];
ydata_go = [mean(tmp_nosepokego)-sem_go fliplr(mean(tmp_nosepokego)+sem_go)];
patch(xdata_nogo,ydata_nogo,'r','FaceAlpha','0.2','EdgeColor','none');
patch(xdata_go,ydata_go,[0 0.8 0],'FaceAlpha','0.2','EdgeColor','none');
set(handles.nphold,'Box','off')
% 
yy = get(handles.nphold,'YLim');
line(handles.nphold,[0 0],yy,'color','black','LineStyle',':')
line(handles.nphold,[15 15],yy,'color',[0 0.8 0],'LineStyle',':')
line(handles.nphold,[75 75],yy,'color',[1 0 0],'LineStyle',':')
legend(handles.nphold,'nogo','go')
 hold(handles.nphold,'off')

 str = sprintf('Cell No : %d',k);
 set(handles.text2,'String',str);
 axes(handles.spatialcell);
imshow(handles.rawdata1.results.Cn',[0 1]);
hold(handles.spatialcell,'on')
thr = 0.8;
img = handles.rawdata1.results.Cn;
ind = handles.currentcell;
% thr =  str2num(get(handles.thr,'String'));
with_label = false;
Coor = get_contours(handles,thr,ind,0);
handles.Coor = Coor;
d1 = handles.rawdata1.results.options.d1;
d2 = handles.rawdata1.results.options.d2;

plot_contours(handles.rawdata1.results.A(:, ind),d1,d2, img, thr,with_label, [], handles.Coor, 2);
colormap gray;
hold(handles.spatialcell,'off')
x_pixel = handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.spatialcell,[0 x_pixel])
ylim(handles.spatialcell,[0 y_pixel])
title(handles.spatialcell,'Spatial locations of the cells');
axes(handles.reward)
plot(handles.reward,-15:1:30,mean(tmp_reward(nogo,:)),'-r')
hold(handles.reward,'on')
plot(handles.reward,-15:1:30,mean(tmp_reward(go,:)),'-','color',[0 0.8 0])
title('Rewarded Trials')
line(handles.reward,[0 0],ylim,'color','black','LineStyle',':')
hold(handles.reward,'off')
axes(handles.leverpress)
plot(handles.leverpress,-15:1:30,mean(tmp_leverpress),'LineStyle','-','color',[0 0.8 0])
title('Go trials aligned to lever press')
line(handles.leverpress,[0 0],ylim,'color','black','LineStyle',':')
end
guidata(hObject,handles)
    


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.currentcell~=size(handles.tr.trials(1).C_raw,1)
    k = handles.currentcell+1;
    tmp_nosepokenogo=[];
    handles.currentcell = k;
tmp_nosepokenogo=[];
tmp_nosepokego=[];
tmp_reward = [];
tmp_leverpress=[];
nogo=[];go=[];
for i = 1:length(handles.indnogoreward)
    tmp_nosepokenogo = [tmp_nosepokenogo; handles.tr.trials(handles.indnogoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)+90)];
end
for i = 1:length(handles.indgoreward)
    tmp_nosepokego = [tmp_nosepokego; handles.tr.trials(handles.indgoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)+60)];
end
for i = 1:length(handles.indreward)
    tmp_reward = [tmp_reward; handles.tr.trials(handles.indreward(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indreward(i)).rewardframe-15:handles.tr.trials(handles.indreward(i)).rewardframe+30)];
    if handles.tr.trials(handles.indreward(i)).nogo
        nogo = [nogo i];
    else
        go = [go i];
    end
end
for i = 1:length(handles.indleverpress)
    tmp_leverpress = [tmp_leverpress; handles.tr.trials(handles.indleverpress(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indleverpress(i)).leverpressframe-15:handles.tr.trials(handles.indleverpress(i)).leverpressframe+30)];
end
axes(handles.nphold)
plot(handles.nphold,-15:1:90,mean(tmp_nosepokenogo),'-r')
hold(handles.nphold,'on')
plot(handles.nphold,-15:1:60,mean(tmp_nosepokego),'LineStyle','-','color',[0 0.8 0])
xdata_nogo = [-15:1:90 90:-1:-15];
xdata_go = [-15:1:60 60:-1:-15];
sem_nogo = std(tmp_nosepokenogo)/sqrt(size(tmp_nosepokenogo,1));
sem_go = std(tmp_nosepokego)/sqrt(size(tmp_nosepokego,1));
ydata_nogo = [mean(tmp_nosepokenogo)-sem_nogo fliplr(mean(tmp_nosepokenogo)+sem_nogo)];
ydata_go = [mean(tmp_nosepokego)-sem_go fliplr(mean(tmp_nosepokego)+sem_go)];
patch(xdata_nogo,ydata_nogo,'r','FaceAlpha','0.2','EdgeColor','none');
patch(xdata_go,ydata_go,[0 0.8 0],'FaceAlpha','0.2','EdgeColor','none');
set(handles.nphold,'Box','off')
% 
yy = get(handles.nphold,'YLim');
line(handles.nphold,[0 0],yy,'color','black','LineStyle',':')

line(handles.nphold,[15 15],yy,'color',[0 0.8 0],'LineStyle',':')
line(handles.nphold,[75 75],yy,'color',[1 0 0],'LineStyle',':')
legend(handles.nphold,'nogo','go')
 hold(handles.nphold,'off')

 str = sprintf('Cell No : %d',k);
 set(handles.text2,'String',str);
 axes(handles.spatialcell);
imshow(handles.rawdata1.results.Cn',[0 1]);
hold(handles.spatialcell,'on')
thr = 0.8;
img = handles.rawdata1.results.Cn;
ind = handles.currentcell;
% thr =  str2num(get(handles.thr,'String'));
with_label = false;
Coor = get_contours(handles,thr,ind,0);
handles.Coor = Coor;
d1 = handles.rawdata1.results.options.d1;
d2 = handles.rawdata1.results.options.d2;

plot_contours(handles.rawdata1.results.A(:, ind),d1,d2, img, thr,with_label, [], handles.Coor, 2);
colormap gray;
hold(handles.spatialcell,'off')
x_pixel = handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.spatialcell,[0 x_pixel])
ylim(handles.spatialcell,[0 y_pixel])
title(handles.spatialcell,'Spatial locations of the cells');
axes(handles.reward)
plot(handles.reward,-15:1:30,mean(tmp_reward(nogo,:)),'-r')
hold(handles.reward,'on')
plot(handles.reward,-15:1:30,mean(tmp_reward(go,:)),'-','color',[0 0.8 0])
title('Rewarded Trials')
line(handles.reward,[0 0],ylim,'color','black','LineStyle',':')
hold(handles.reward,'off')
axes(handles.leverpress)
plot(handles.leverpress,-15:1:30,mean(tmp_leverpress),'LineStyle','-','color',[0 0.8 0])
title('Go trials aligned to lever press')
line(handles.leverpress,[0 0],ylim,'color','black','LineStyle',':')
end
guidata(hObject,handles)


% --- Executes on button press in update.
function update_Callback(hObject, eventdata, handles)
% hObject    handle to update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currentcell = 1;
k = handles.currentcell;
tmp_nosepokenogo=[];
tmp_nosepokego=[];
tmp_reward = [];
tmp_leverpress = [];nogo=[];go=[];
for i = 1:length(handles.indnogoreward)
    tmp_nosepokenogo = [tmp_nosepokenogo; handles.tr.trials(handles.indnogoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indnogoreward(i)).nosepokeframe)+90)];
end
for i = 1:length(handles.indgoreward)
    tmp_nosepokego = [tmp_nosepokego; handles.tr.trials(handles.indgoreward(i)).C_raw(handles.currentcell,round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)-15:round(handles.tr.trials(handles.indgoreward(i)).nosepokeframe)+60)];
end
for i = 1:length(handles.indreward)
    tmp_reward = [tmp_reward; handles.tr.trials(handles.indreward(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indreward(i)).rewardframe-15:handles.tr.trials(handles.indreward(i)).rewardframe+30)];
    if handles.tr.trials(handles.indreward(i)).nogo
        nogo = [nogo i];
    else
        go = [go i];
    end
end
for i = 1:length(handles.indleverpress)
    tmp_leverpress = [tmp_leverpress; handles.tr.trials(handles.indleverpress(i)).C_raw(handles.currentcell,handles.tr.trials(handles.indleverpress(i)).leverpressframe-15:handles.tr.trials(handles.indleverpress(i)).leverpressframe+30)];
end

axes(handles.nphold)
plot(handles.nphold,-15:1:90,mean(tmp_nosepokenogo),'-r')

hold(handles.nphold,'on')

plot(handles.nphold,-15:1:60,mean(tmp_nosepokego),'LineStyle','-','color',[0 0.8 0])
xdata_nogo = [-15:1:90 90:-1:-15];
xdata_go = [-15:1:60 60:-1:-15];
sem_nogo = std(tmp_nosepokenogo)/sqrt(size(tmp_nosepokenogo,1));
sem_go = std(tmp_nosepokego)/sqrt(size(tmp_nosepokego,1));
ydata_nogo = [mean(tmp_nosepokenogo)-sem_nogo fliplr(mean(tmp_nosepokenogo)+sem_nogo)];
ydata_go = [mean(tmp_nosepokego)-sem_go fliplr(mean(tmp_nosepokego)+sem_go)];
patch(xdata_nogo,ydata_nogo,'r','FaceAlpha','0.2','EdgeColor','none');
patch(xdata_go,ydata_go,[0 0.8 0],'FaceAlpha','0.2','EdgeColor','none');
set(handles.nphold,'Box','off')
% 

yy = get(handles.nphold,'YLim');
line(handles.nphold,[0 0],yy,'color','black','LineStyle',':')
line(handles.nphold,[15 15],yy,'color',[0 0.8 0],'LineStyle',':')
line(handles.nphold,[75 75],yy,'color',[1 0 0],'LineStyle',':')
legend(handles.nphold,'nogo','go')
 hold(handles.nphold,'off')

 str = sprintf('Cell No : %d',k);
 set(handles.text2,'String',str);
 axes(handles.spatialcell);
imshow(handles.rawdata1.results.Cn',[0 1]);
hold(handles.spatialcell,'on')
thr = 0.8;
img = handles.rawdata1.results.Cn;
ind = handles.currentcell;
% thr =  str2num(get(handles.thr,'String'));
with_label = false;
Coor = get_contours(handles,thr,ind,0);
handles.Coor = Coor;
d1 = handles.rawdata1.results.options.d1;
d2 = handles.rawdata1.results.options.d2;

plot_contours(handles.rawdata1.results.A(:, ind),d1,d2, img, thr,with_label, [], handles.Coor, 2);
colormap gray;
hold(handles.spatialcell,'off')
x_pixel = handles.rawdata1.results.options.d1;
y_pixel = handles.rawdata1.results.options.d2;
xlim(handles.spatialcell,[0 x_pixel])
ylim(handles.spatialcell,[0 y_pixel])
title(handles.spatialcell,'Spatial locations of the cells');
axes(handles.reward)
plot(handles.reward,-15:1:30,mean(tmp_reward(nogo,:)),'-r')
hold(handles.reward,'on')
plot(handles.reward,-15:1:30,mean(tmp_reward(go,:)),'-','color',[0 0.8 0])
title('Rewarded Trials')
line(handles.reward,[0 0],ylim,'color','black','LineStyle',':')
hold(handles.reward,'off')
axes(handles.leverpress)
plot(handles.leverpress,-15:1:30,mean(tmp_leverpress),'LineStyle','-','color',[0 0.8 0])
title('Go trials aligned to lever press')
line(handles.leverpress,[0 0],ylim,'color','black','LineStyle',':')
guidata(hObject,handles)

function [CC,jsf] = plot_contours(Aor,d1,d2,Cn,thr,display_numbers,max_number,Coor, ln_wd, ln_col)

% save and plot the contour traces of the found spatial components againsts
% specified background image. The contour is drawn around the value above
% which a specified fraction of energy is explained (default 99%)

if nargin < 5 || isempty(max_number)
   max_number = size(Aor,2);
else
   max_number = min(max_number,size(Aor,2));
end
if nargin < 4 || isempty(display_numbers)
   display_numbers = 0;
end
if nargin < 3 || isempty(thr)
   thr = 0.995;
end
if ~exist('ln_wd', 'var') || isempty(ln_wd)
   ln_wd = 1; % linewidth;
end
units = 'centimeters';
fontname = 'helvetica';

%fig3 = figure;
%     set(gcf, 'PaperUnits', units,'Units', units)
%     set(gcf, 'PaperPosition',[5, 5, 12, 12])
%     set(gcf, 'Position',3*[5, 5, 12, 12])

%set(gca,'XTick',[],'YTick',[]);
posA = get(gca,'position');
set(gca,'position',posA);
%cbar = colorbar('south','TickDirection','out');
if (0)
   cbar = colorbar('TickDirection','out');
   cpos = get(cbar,'position');
   %cpos = [posA(1),posA(2)-cpos(4)-0.01,posA(3),cpos(4)];
   ylabel(cbar,'Average neighbor correlation');
   set(cbar,'position',cpos,'TickDirection','in');
   set(cbar,'fontweight','bold','fontsize',14,'fontname',fontname);
end
%hold on; scatter(cm(:,2),cm(:,1),'ko'); hold off;
%v = axis;
%handle = title('Correlation image and identified spatial footprints','fontweight','bold','fontsize',14,'fontname',fontname);
hold on;
if ~exist('cmap', 'var') || isempty(cmap)
cmap = hot(3*size(Aor,2));
else
   cmap = repmat(reshape(ln_col, 1, []), size(Aor,2), 1);
end
if ~(nargin < 6 || isempty(Coor))
   CC = Coor;
   for i = 1:size(Aor,2)
%         cont = medfilt1(Coor{i}')';
       cont = Coor{i};
       if size(cont,2) > 1
           plot(cont(1,1:end),cont(2,1:end),'Color',cmap(i+size(Aor,2),:), 'linewidth', ln_wd); hold on;
       end
   end
else
   CC = cell(size(Aor,2),1);
   CR = cell(size(Aor,2),2);
   for i = 1:size(Aor,2)
       A_temp = full(reshape(Aor(:,i),d1,d2));
       A_temp = medfilt2(A_temp,[3,3]);
       A_temp = A_temp(:);
       [temp,ind] = sort(A_temp(:).^2,'ascend');
       temp =  cumsum(temp);
       ff = find(temp > (1-thr)*temp(end),1,'first');
       if ~isempty(ff)
           CC{i} = contour(reshape(A_temp,d1,d2),[0,0]+A_temp(ind(ff)),'LineColor',cmap(i+size(Aor,2),:), 'linewidth', ln_wd);
           fp = find(A_temp >= A_temp(ind(ff)));
           [ii,jj] = ind2sub([d1,d2],fp);
           CR{i,1} = [ii,jj]';
           CR{i,2} = A_temp(fp)';
       end
       hold on;
   end
end

if display_numbers
    cm = com(Aor(:,1:end),d1,d2);
   lbl = strtrim(cellstr(num2str((1:size(Aor,2))')));
   text((cm(1:max_number,2)),(cm(1:max_number,1)),lbl(1:max_number),'color',[0,0,0],'fontsize',16,'fontname',fontname,'fontweight','bold');
end
axis off;
if ~(nargin < 6 || isempty(Coor))
   jsf = [];
else
   for i = 1:size(Aor,2);
       if ~isempty(CR{i,1})
           jsf(i) = struct('id',i,...
               'coordinates',CR{i,1}',...
               'values',CR{i,2},...
               'bbox',[min(CR{i,1}(1,:)),max(CR{i,1}(1,:)),min(CR{i,1}(2,:)),max(CR{i,1}(2,:))],...
               'centroid',cm(i,:));
       end
       if i == 1
           jsf = repmat(jsf,size(Aor,2),1);
       end
   end
end

function Coor = get_contours(h2, thr, ind,updated)
     if updated
         A_ = h2.updatedA;
         A_ = A_(:,ind);
     else
           A_ = h2.rawdata1.results.A;
        
               A_ = A_(:, ind);
     end
          
          
           num_neuron = size(A_,2);
           if num_neuron==0
               Coor ={};
               return;
           else
               Coor = cell(num_neuron,1);
           end
           d1 = h2.rawdata1.results.options.d1,1;
           d2 = h2.rawdata1.results.options.d2,2;
           %             tmp_kernel = strel('square', 3);
           for m=1:num_neuron
               % smooth the image with median filter
               A_temp = reshape(full(A_(:, m)),d1,d2);
               % find the threshold for detecting nonzero pixels

               A_temp = A_temp(:);
               [temp,ind] = sort(A_temp(:).^2,'ascend');
               temp =  cumsum(temp);
               ff = find(temp > (1-thr)*temp(end),1,'first');
               thr_a = A_temp(ind(ff));
               A_temp = reshape(A_temp,d1,d2);

               % crop a small region for computing contours
               [tmp1, tmp2, ~] = find(A_temp);
               if isempty(tmp1)
                   Coor{m} = zeros(2,1);
                   continue;
               end
               rmin = max(1, min(tmp1)-3);
               rmax = min(d1, max(tmp1)+3);
               cmin = max(1, min(tmp2)-3);
               cmax = min(d2, max(tmp2)+3);
               A_temp = A_temp(rmin:rmax, cmin:cmax);

               if nnz(A_temp)>36
                   l = bwlabel(medfilt2(A_temp>thr_a));
               else
                   l = bwlabel(A_temp>=thr_a);
               end
               l_most = mode(l(l>0));
               if isnan(l_most)
                   Coor{m} = zeros(2, 1);
                   continue;
               end
               ind = (l==l_most);
               A_temp(ind) =  max(A_temp(ind), thr_a);
               A_temp(~ind) = min(A_temp(~ind), thr_a*0.99);

               pvpairs = { 'LevelList' , thr_a, 'ZData', A_temp};
               h = matlab.graphics.chart.primitive.Contour(pvpairs{:});
               temp = h.ContourMatrix;
               if isempty(temp)
                   temp = get_contours(hObject,(thr+1)/2, ind_show(m));
                   Coor{m} = temp{1};
                   continue;
               else
                   temp(:, 1) = temp(:, 2);
                   temp = medfilt1(temp')';
                   temp(:, 1) = temp(:, end);
                   Coor{m} = bsxfun(@plus, temp, [cmin-1; rmin-1]);
               end

           end
