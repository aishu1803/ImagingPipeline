function [reward_corr,punish_corr,n_errs] =  BehavioralAnalysis(filename)
[A,D,E] =  ProcessMedPC(filename); % Get all A's,'D's and E's from medpc file
n_trials = find(E==4 | E==5); % 4/5 
n_trialstart = find(E==1);
reward_corr = 0;punish_corr = 0;
for i = 1:length(n_trials)
    if i ==length(n_trials)
        tmp = E(n_trials(i):end);
    else
        tmp = E(n_trials(i):n_trialstart(i+1));
    end
    if length(find(tmp==4)) + length(find(tmp==3)) + length(find(tmp==4))==1
        reward_corr = reward_corr+1; 
    elseif length(find(tmp==5)) + length(find(tmp==28))==2
        punish_corr = punish_corr+1;
%     elseif length(find(tmp==19)) + length(find(tmp==17))==2
%         go_incorrect = go_incorrect+1;
%     elseif length(find(tmp==20 )) + length(find(tmp==3))==2
%         nogo_correct = nogo_correct+1;
%     elseif length(find(tmp==20))+length(find(tmp==21))==2
%          nogo_incorrect = nogo_incorrect+1;
    end
    if length(find(tmp==4))==1
        if length(find(E==LNP)) + 
            ommissions_rew = om
        end
       
    elseif
        if 
           ommissions_pun = ommis
        end
    end
end
n_re_trials = length(find(E==4));
n_pu_trials = length(find(E==5));
reward_corr = reward_corr/n_re_trials;
punish_corr = punish_corr/n_pu_trials;

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