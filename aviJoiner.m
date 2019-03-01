
function bindingFile=aviJoiner(aviFiles, vfname, varargin)
% default configuration
PathName='';
cfg.compression='wmv3';
cfg.fps=10;
cfg.quality=90;
if nargin<1
    [FileName, PathName] = uigetfile({'*.avi'},'Select avi files','MultiSelect','on');
    if ~isa(FileName, 'cell')
        warndlg('Please choose more than one avi files');
        return;
    end
    n=length(FileName);
    for k=1:n
        aviFiles{k}=[PathName FileName{k}];
    end
end
if nargin<2
    [FileName, PathName] = uiputfile({'binder.avi'},'Binding avi file',PathName);
    vfname=[PathName FileName];
end
args = varargin;
for i=1:2:length(args)
    switch lower(args{i})
        case 'compression', cfg.compression = args{i+1};
        case 'fps', cfg.fps = args{i+1};
        case 'quality', cfg.quality = args{i+1};
        case 'configuration', cfg=args{i+1};
        otherwise, error(['unrecognized argument ' args{i}])
    end
end
warning off
clear mex;
movout=avifile(vfname,'compression',cfg.compression,'fps',cfg.fps, 'quality', cfg.quality);
n=length(aviFiles);
totalFrames=0;
for k=1:n
    fileinfo=aviinfo(aviFiles{k});
    totalFrames=totalFrames+fileinfo.NumFrames;
end
finishedFrames=0;
h = waitbar(0,'Please wait...','Name', vfname);
for k=1:n
    fileinfo=aviinfo(aviFiles{k});
    for m=1:fileinfo.NumFrames
        finishedFrames=finishedFrames+1;
        progress=finishedFrames/totalFrames;
        waitbar(progress,h,sprintf('Binding avi file......Finish %d%%.', round(progress*100)));
        movin=aviread(aviFiles{k},m);
        movout=addframe(movout,movin);
    end
end
close(h);
movout=close(movout);
if nargout > 0
    bindingFile=vfname;
end
warning on
return
