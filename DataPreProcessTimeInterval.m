function [dpca_data,firingRates,firingRatesAverage,trialNum] = DataPreProcessTimeInterval(trials,shuf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code z-scores, baseline-subtractes and stretches or shrinks the 3s trials to match the length of the 
% 8s trials. 
% Input - 
% 1) trials - the structure that is of size Ntrials and has fields that
% correspond to different behavioral paramenters.
% 2) shuf - if we want the trial label shuffled. 1 = yes and 0 = no
% Output -
% 1) dpca_data - representation of trials with z-scored, baseline-substracted and streched /shrunk data
% 2) firingRates - Output that dpca needs. 5-d matrix : Ncells x Ncond x
% Noutcome x Nbins x Ntrials. If there are unequal number of trials in
% different conditions, the size of this matrix is the max no of trials
% found in any of the condition. If a condition has lesser number of
% trials, it is padded with NaNs. 
% 3) firingRatesAverage - trial averaged firingRates. Therefor 4d matrix. 
% 4) trialNum - 3d matrix showing the number of trials for each neuron and
% each condition. Size - Ncells x Ncond x Noutcome.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Craw = [trials.Craw];
C = [trials.C];
for j = 1:length(trials)
    frameno(j) = size(trials(j).Craw,2);
end
frameno = cumsum(frameno);
for i = 1:size(Craw,1)
    m = mean(Craw(i,:));
    st = std(Craw(i,:));
    m_c = mean(C(i,:));
    st_c = std(C(i,:));
    z_C_raw(i,:) = (Craw(i,:) - repmat(m,1,length(Craw(i,:))))./repmat(st,1,length(Craw(i,:)));
    z_C(i,:) = (C(i,:) - repmat(m_c,1,length(C(i,:))))./repmat(st_c,1,length(C(i,:)));
end
for i  = 1:length(trials)
    if i == 1
        trials(i).Craw = z_C_raw(:,1:frameno(i));
        trials(i).C = z_C(:,1:frameno(i));
    else
        trials(i).Craw = z_C_raw(:,frameno(i-1)+1:frameno(i));
        trials(i).C = z_C(:,frameno(i-1)+1:frameno(i));
    end
end
%% Baseline subtracted

for i = 1:length(trials)
    
    me = mean(trials(i).Craw(:,1:30),2);
    me_c = mean(trials(i).C(:,1:30),2);
    trials(i).Craw = trials(i).Craw - repmat(me,1,size(trials(i).Craw,2));
    trials(i).C = trials(i).C - repmat(me_c,1,size(trials(i).C,2));
   
end
for i = 1:length(trials)
    
        tmp = trials(i).C;
    
    nogo = trials(i).si;
    rew = trials(i).reward;
   if nogo
       tim_interest = 75-31;
        extrplt_tim = linspace(1,tim_interest,120);
        
        for j = 1:size(trials(i).Craw,1)
            tmp2 = tmp(j,:);
            tmp_tt = timeseries(tmp2(31:75));
            tmp_tt2 = resample(tmp_tt,extrplt_tim);
            dpca_data(i).C_raw(j,:) = [tmp2(1:30) squeeze(tmp_tt2.data)' tmp2(76:105)];
        end
   else
       dpca_data(i).C_raw = tmp(:,1:180);
   end
  
end
for i = 1:length(dpca_data)
dpca_data(i).reward = trials(i).reward;
end
for i = 1:length(dpca_data)
dpca_data(i).nogo = trials(i).si;
end
ind_reward = [dpca_data.reward;];
correct_trials = find(ind_reward);
error_trials = setdiff(1:length(dpca_data),correct_trials);
ind_nogo = [dpca_data.nogo;];
nogo_trials = find(ind_nogo);
go_trials = setdiff(1:length(dpca_data),nogo_trials);
max_trials_condition = max([length(nogo_trials),length(go_trials)]);
max_trials_decision = max([length(correct_trials),length(error_trials)]);
max_trial_num = max([max_trials_condition max_trials_decision]);
n_neurons = size(trials(1).Craw,1);
firingRates = nan(n_neurons,2,2,size(dpca_data(1).C_raw,2),max_trials_condition);
count = ones(1,4);
id=[1 1;2 1;1 2;2 2];
dpca_data2 = dpca_data;
if shuf
    new_order = randperm(length(dpca_data));
    
    for f = 1:length(dpca_data)
        dpca_data(f).C_raw = dpca_data2(new_order(f)).C_raw;
    end
end
for i = 1:length(dpca_data)
    if dpca_data(i).reward && dpca_data(i).nogo
        firingRates(:,id(1,1),id(1,2),:,count(1)) = dpca_data(i).C_raw;
        count(1) = count(1)+1;
    elseif dpca_data(i).reward && ~dpca_data(i).nogo
        firingRates(:,id(2,1),id(2,2),:,count(2)) = dpca_data(i).C_raw;
      count(2) = count(2)+1;
    elseif ~dpca_data(i).reward && dpca_data(i).nogo
        firingRates(:,id(3,1),id(3,2),:,count(3)) = dpca_data(i).C_raw;
      count(3) = count(3)+1;
    else
        firingRates(:,id(4,1),id(4,2),:,count(4)) = dpca_data(i).C_raw;
        count(4) = count(4) + 1;
    end
end

trialNum(1:n_neurons,1,1) = count(1)-1;
trialNum(1:n_neurons,1,2) = count(3)-1;
trialNum(1:n_neurons,2,2) = count(4)-1;
trialNum(1:n_neurons,2,1) = count(2)-1;
firingRatesAverage = nanmean(firingRates,5);
