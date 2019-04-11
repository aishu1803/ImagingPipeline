function [go_reward,go_punishment] =  BehavioralAnalysis(filename)
[A,D,E] =  ProcessMedPC(filename);
n_trials = find(E==2);
n_trialstart = find(E==1);
go_reward = 0; go_punishment = 0;n_reward =0;n_punishment = 0;
% go_correct = 0;go_incorrect = 0;nogo_correct=0;nogo_incorrect=0;go_punishcorr=0;nogo_punishcorr=0;go_punisherr=0;nogo_punisherr=0;
for i = 1:length(n_trials)
    if i ==length(n_trials)
        tmp = E(n_trials(i):end);
    else
        tmp = E(n_trials(i):n_trialstart(i+1));
    end
        if  length(find(tmp==3))==1
        go_reward = go_reward +1; 
    elseif  length(find(tmp==4))==1
        go_punishment = go_punishment+1;
        elseif length(find(tmp==14))==1
        end
%     if length(find(tmp==19)) + length(find(tmp==3))==2
%         go_correct = go_correct +1; 
%     elseif length(find(tmp==19)) + length(find(tmp==5))==2
%         go_incorrect = go_incorrect+1;
%     elseif length(find(tmp==19)) + length(find(tmp==17))==2
%         go_incorrect = go_incorrect+1;
%     elseif length(find(tmp==20 )) + length(find(tmp==3))==2
%         nogo_correct = nogo_correct+1;
%     elseif length(find(tmp==20))+length(find(tmp==21))==2
%          nogo_incorrect = nogo_incorrect+1;
%      
%     end

end
% n_corrtrials = length(find(E==3));
% n_corrgo = length(find(E==19));
% n_corrnogo = length(find(E==20));
% go_correct = go_correct/n_corrgo;
% nogo_correct = nogo_correct/n_corrnogo;
n_reward = length(find(E==19));
n_punishment = length(find(E==20));
go_reward = go_reward/n_reward;
go_punishment = go_punishment/n_punishment;

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