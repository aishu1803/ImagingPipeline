<<<<<<< HEAD
function [go_reward,go_punishment] =  BehavioralAnalysis(filename)
=======
function [reward_corr,punish_corr] =  BehavioralAnalysis(filename)
<<<<<<< HEAD
[A,D,E] =  ProcessMedPC(filename); % Get all A's,'D's and E's from medpc file
n_trials = find(E==4 | E==5); % 4/5 
=======
>>>>>>> 3750c46d3a9bc5fa29ec6ea572d27bf5b979fc6a
[A,D,E] =  ProcessMedPC(filename);
n_trials = find(E==4 | E==5);
>>>>>>> 8bf0d2f61682d4276f18201c36e58fba930ce27e
n_trialstart = find(E==1);
<<<<<<< HEAD
go_reward = 0; go_punishment = 0;n_reward =0;n_punishment = 0;
% go_correct = 0;go_incorrect = 0;nogo_correct=0;nogo_incorrect=0;go_punishcorr=0;nogo_punishcorr=0;go_punisherr=0;nogo_punisherr=0;
=======
reward_corr = 0;punish_corr = 0;
>>>>>>> 3750c46d3a9bc5fa29ec6ea572d27bf5b979fc6a
for i = 1:length(n_trials)
    if i ==length(n_trials)
        tmp = E(n_trials(i):end);
    else
        tmp = E(n_trials(i):n_trialstart(i+1));
    end
<<<<<<< HEAD
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
=======
    if length(find(tmp==4)) + length(find(tmp==3))==2
        reward_corr = reward_corr+1; 
    elseif length(find(tmp==5)) + length(find(tmp==28))==2
        punish_corr = punish_corr+1;
>>>>>>> 3750c46d3a9bc5fa29ec6ea572d27bf5b979fc6a
%     elseif length(find(tmp==19)) + length(find(tmp==17))==2
%         go_incorrect = go_incorrect+1;
%     elseif length(find(tmp==20 )) + length(find(tmp==3))==2
%         nogo_correct = nogo_correct+1;
%     elseif length(find(tmp==20))+length(find(tmp==21))==2
%          nogo_incorrect = nogo_incorrect+1;
<<<<<<< HEAD
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
=======
    end
end
n_re_trials = length(find(E==4));
n_pu_trials = length(find(E==5));
reward_corr = reward_corr/n_re_trials;
punish_corr = punish_corr/n_pu_trials;
>>>>>>> 3750c46d3a9bc5fa29ec6ea572d27bf5b979fc6a

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
        
        tmp = strsplit(tmp{2},'I:');
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