function trials = BuildTrials(result,filename,medpcfilename,fps)
% filename - path to the folder where all the avi files are stored.
%result - result.mat from cnmf-e
% medpcfilename - medpcfilename for the session recorded
% fps  - frames per second used in the recording
frameno = CountFrames(filename); %This line will count the number of frames in each of the avi files you concatenated
frameno = cumsum(frameno) %cummulative sum of the framenumbers
[~,D,E] =  ProcessMedPC(medpcfilename); %gets the Events vector 'E' and the time of events vector 'D'
for i = 1:length(frameno) % Separating 1 long C_raw into separate trials
    if i==1
        trials(i).C_raw = result.C_raw(:,1:frameno(i));
    else
        trials(i).C_raw = result.C_raw(:,frameno(i-1):frameno(i));
    end
end
for i = 1:length(trials)
    
end
ind_miniscope = find(E==22);
ind_miniscopeoff = find(E==23);
% Separate the events per trial
for i = 1:length(trials)
    trials(i).events = E(ind_miniscope(i)-1:ind_miniscopeoff(i));
end
%Get the timing of each event.
for i = 1:length(trials)
    trials(i).timing = D(ind_miniscope(i)-1:ind_miniscopeoff(i));
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==9))
        tmp = find(trials(i).events==7);
        ind = find(trials(i).events(tmp:end)==9,1,'first')+tmp - 1;
        tim_nosepoke = (trials(i).timing(ind) - trials(i).timing(2))/100 ;
        trials(i).nosepokeframe = round(tim_nosepoke*fps);
    end
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==9))
        ind = find(trials(i).events==9,1,'last');
        tim_nosepokecueoff = (trials(i).timing(ind) - trials(i).timing(2))/100;
        trials(i).nosepokecueoffframe = round(tim_nosepokecueoff*fps);
    end
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==3))
        ind = find(trials(i).events==3);
        tim_reward = (trials(i).timing(ind) - trials(i).timing(2))/100;
        trials(i).rewardframe = round(tim_reward*fps);
    end
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==18))
        ind = find(trials(i).events==18);
        tim_leverpress = (trials(i).timing(ind) - trials(i).timing(2))/100;
        trials(i).leverpressframe = round(tim_leverpress*fps);
    end
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==19))
        trials(i).nogo = 0;
    else
        trials(i).nogo = 1;
    end
end
for i = 1:length(trials)
    if ~isempty(find(trials(i).events==3))
        trials(i).reward = 1;
    else
        trials(i).reward = 0;
    end
end
end
function fno = CountFrames(foldername)
f = dir(foldername);
% tt = [];
% for i = 1:82
% tt = [tt; f(i).date];
% end
% [A,ind]=sortrows(tt);
% ind = [5; ind(6:end)];

count = 1;
for i = 1:length(f)
    if length(f(i).name)>2 && f(i).isdir
        str = sprintf('%s\\%s',foldername,f(i).name);
        cd(str);
        f1 = dir(str);
        if  length(f1)==5
            if f1(5).bytes>500
                data = readtable('timestamp.dat');
                fno(count) = size(data,1)-2;
                count = count +1;
            end
        end
        
    end
end
end
function [A,D,E] =  ProcessMedPC(filename)


fileID = fopen(filename,'r');

%READ IN EVERY LETTER THAT"S IMPORTANT
C = fscanf(fileID,'%s');
tmp = strsplit(C,'A:');
Intro = tmp{1}; %NOT SO IMPORTANT
tmp = strsplit(tmp{2},'B:');

A = tmp{1};%Save A
tmp = strsplit(tmp{2},'D:');
B = tmp{1}; %Save B

tmp = strsplit(tmp{2},'E:');
D = tmp{1}; %Save c

tmp = strsplit(tmp{2},'S:');
E = tmp{1}; %save D



fclose(fileID)

%WRite all variables to numbers
VariablesOfInterest = {'A','D','E'};
for idx = 1:length(VariablesOfInterest)
    delimeter = ':';
    eval(['findcolumnend = strfind(' VariablesOfInterest{idx} ',''' delimeter ''');'])
    delimeter = '.000';
    eval(['findnewnumber = strfind(' VariablesOfInterest{idx} ',''' delimeter ''');'])
    findnewnumber = findnewnumber+4; %Don't count the delimiter
    findnewnumber = [1 findnewnumber]; % add 1
    removeidx = [];
    for iidx = 1:length(findcolumnend)
        tmp = findnewnumber-findcolumnend(iidx);
        findcolumnstart(iidx) = find(abs(tmp)==min(abs(tmp)) & tmp<0);
        removeidx = [removeidx findnewnumber(findcolumnstart(iidx)):findcolumnend(iidx)];
    end
    eval([VariablesOfInterest{idx} '(removeidx) = [];'])
    delimeter = '.000';
    eval(['[tmp,matches] = strsplit(' VariablesOfInterest{idx} ',''' delimeter ''');'])
    tmp(cellfun(@isempty,tmp)) = [];
    eval([VariablesOfInterest{idx} '=cellfun(@str2num,tmp);'])
end
end