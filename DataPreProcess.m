function [dpca_data,firingRates,firingRatesAverage,trialNum,ind_ee] = DataPreProcess(trials,shuf,dpca)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code z-scores, baseline-subtractes and stretches or shrinks the go trials to match the length of the 
% nogo trial. 
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
%% Removing error trials where the animal did not hold his nose in the poke hole during error trials
ind_ee = [];
for i = 1:length(trials)
    if ~trials(i).nogo
        if (trials(i).nosepokecueoffframe - trials(i).nosepokeentryframe) < 6
            
            ind_ee = [ind_ee i];
        end
    else
        if (trials(i).nosepokecueoffframe - trials(i).nosepokeentryframe) < 25
            ind_ee = [ind_ee i];
        end
    
    end
    if isempty(trials(i).nosepokeentryframe)
        ind_ee = [ind_ee i];
    end
end
trials(ind_ee) = [];
%% Z-scores
if dpca
C_raw = [trials.Craw];
C = [trials.C];
for j = 1:length(trials)
    frameno(j) = size(trials(j).Craw,2);
end
frameno = cumsum(frameno);
for i = 1:size(C_raw,1)
    m = mean(C_raw(i,:));
    st = std(C_raw(i,:));
    m_c = mean(C(i,:));
    st_c = std(C(i,:));
    z_C_raw(i,:) = (C_raw(i,:) - repmat(m,1,length(C_raw(i,:))))./repmat(st,1,length(C_raw(i,:)));
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
% reward = [trials.reward;];
% ind_reward = find(reward);
% ind_reward_ss = ind_reward(randsample(length(ind_reward),50));
% for i = 1:length(ind_reward_ss)
for i = 1:length(trials)
    npentry = trials(i).nosepokeentryframe;
%      me = mean(trials(i).Craw(:,npentry - 14:npentry-7),2);
%      me_c = mean(trials(i).C(:,npentry - 14:npentry-7),2);
       me = mean(trials(i).Craw(:,1:30),2);
      me_c = mean(trials(i).C(:,1:30),2);

    trials(i).Craw = trials(i).Craw - repmat(me,1,size(trials(i).Craw,2));
    trials(i).C = trials(i).C - repmat(me_c,1,size(trials(i).C,2));
   
end
end
%%
for i = 1:length(trials)
    if dpca
        tmp = trials(i).C;
    else
        tmp = trials(i).C;
    end
    nogo = trials(i).nogo;
    rew = trials(i).reward;
   if ~nogo && rew
%         tim_interest = trials(i).leverpressframe - trials(i).nosepokeentryframe;
        %extrplt_tim = linspace(1,tim_interest,45);
        
        for j = 1:size(trials(i).Craw,1)
            tmp2 = tmp(j,:);
%             tmp_tt = timeseries(tmp2(trials(i).nosepokeentryframe:trials(i).leverpressframe));
%             tmp_tt2 = resample(tmp_tt,extrplt_tim);
%             dpca_data(i).C_raw(j,:) = [tmp2(trials(i).nosepokeentryframe-14:trials(i).nosepokeentryframe) squeeze(tmp_tt2.data)' tmp2(trials(i).leverpressframe+1:trials(i).leverpressframe+20)];
dpca_data(i).C_raw(j,:) = tmp2(trials(i).nosepokeentryframe-14:trials(i).nosepokeentryframe+50);
        end
    elseif nogo && ~rew
%         tim_interest = trials(i).nosepokecueoffframe - trials(i).nosepokeentryframe;
%         extrplt_tim = linspace(1,tim_interest,45);
        for j = 1:size(trials(i).Craw,1)
            tmp2 = tmp(j,:);
%             tmp_tt = timeseries(tmp2(trials(i).nosepokeentryframe:trials(i).nosepokecueoffframe));
%             tmp_tt2 = resample(tmp_tt,extrplt_tim);
%             dpca_data(i).C_raw(j,:) = [tmp2(trials(i).nosepokeentryframe-14:trials(i).nosepokeentryframe) squeeze(tmp_tt2.data)' tmp2(trials(i).nosepokecueoffframe+1:trials(i).nosepokecueoffframe+20)];
            dpca_data(i).C_raw(j,:) = tmp2(trials(i).nosepokeentryframe-14:trials(i).nosepokeentryframe+50);
        end
   else
       
        for j = 1:size(trials(i).Craw,1)
           tmp2 = tmp(j,:);
            dpca_data(i).C_raw(j,:) = tmp2(trials(i).nosepokeentryframe-14:trials(i).nosepokeentryframe+50);
            
        end
    end
end

for i = 1:length(dpca_data)
dpca_data(i).reward = trials(i).reward;
end
for i = 1:length(dpca_data)
dpca_data(i).nogo = trials(i).nogo;
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