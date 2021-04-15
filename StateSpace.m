function [nogo_corr_SS,nogo_err_SS,go_corr_SS,go_err_SS,go_corr_SS2,nogo_err_SS2,inter,intra] =  StateSpace(Trajs_taskonly,trialNum,trials,ind_ee,inte)
n_nogo = size(Trajs_taskonly,5);
n_go = size(Trajs_taskonly,5);
n_nogo_error = trialNum(1,1,2);
n_go_error = trialNum(1,2,2);
trials(ind_ee) = [];
reward = [trials.reward;];
ind_reward = find(reward);
trials_corr = trials(ind_reward);
nogo = [trials_corr.nogo;];
ind_nogo = find(nogo);
trials_nogo_corr = trials_corr(ind_nogo);
ind_go = setdiff(1:length(trials_corr),ind_nogo);
trials_go_corr = trials_corr(ind_go);
ind_err = setdiff(1:length(trials),ind_reward);
trials_err = trials(ind_err);
nogo_err = [trials_err.nogo;];
ind_nogo_err = find(nogo_err);
trials_nogo_err = trials_err(ind_nogo_err);
ind_go_err = setdiff(1:length(trials_err),ind_nogo_err);
trials_go_err = trials_err(ind_go_err);
go_lvrpress = [trials_go_corr.leverpressframe;] - [trials_go_corr.nosepokecueoffframe;] + 14;
nogo_err_exit = [trials_nogo_err.nosepokecueoffframe;] - [trials_nogo_err.nosepokeentryframe;] + 14;
nogo_corr_SS = squeeze(mean(Trajs_taskonly(1:3,inte,1,1,:),2));
go_corr_SS = squeeze(mean(Trajs_taskonly(1:3,inte,2,1,:),2));
go_err_SS = squeeze(mean(Trajs_taskonly(1:3,inte,2,2,1:n_go_error),2));
nogo_err_SS = squeeze(mean(Trajs_taskonly(1:3,inte,1,2,1:n_nogo_error),2));
for i = 1:n_nogo_error
    nogo_err_SS2(:,i) = squeeze(mean(Trajs_taskonly(1:3,nogo_err_exit(i)-15:nogo_err_exit(i)-7,1,2,i),2));
end
for i = 1:n_go
    go_corr_SS2(:,i) = squeeze(mean(Trajs_taskonly(1:3,go_lvrpress(i)-15:go_lvrpress(i)-15,2,1,i),2));
end
% Inter Cluster Distance
for i = 1:1000
    if n_nogo_error < n_go_error
        n_trials = n_nogo_error;
    else
        n_trials = n_go_error;
    end
    n_trials_nogo_corr = nogo_corr_SS(:,randsample(n_nogo,n_trials));
    n_trials_go_corr = go_corr_SS(:,randsample(n_go,n_trials));
    n_trials_nogo_err = nogo_err_SS(:,randsample(n_nogo_error,n_trials));
    n_trials_go_err = go_err_SS(:,randsample(n_go_error,n_trials));
%     inter.gcorrngcorr(i)  = sqrt(sum((mean(n_trials_nogo_corr,2) - mean(n_trials_go_corr,2)) .^ 2));
%     inter.gcorrgerr(i)  = sqrt(sum((mean(n_trials_go_corr,2) - mean(n_trials_go_err,2)) .^ 2));
%     inter.ngcorrngerr(i)  = sqrt(sum((mean(n_trials_nogo_corr,2) - mean(n_trials_nogo_err,2)) .^ 2));
%     inter.gcorrngerr(i)  = sqrt(sum((mean(n_trials_go_corr,2) - mean(n_trials_nogo_err,2)) .^ 2));
%     inter.ngcorrgerr(i)  = sqrt(sum((mean(n_trials_nogo_corr,2) - mean(n_trials_go_err,2)) .^ 2));
    %Intra cluster distance
    count = 1;
    for j = 1:n_trials
        
        inter.gcorrgerr(i,count) = sqrt(sum((mean(n_trials_go_corr,2) - n_trials_go_err(:,j)) .^ 2));
        inter.gcorrngerr(i,count) = sqrt(sum((mean(n_trials_go_corr,2) - n_trials_nogo_err(:,j)) .^ 2));
        inter.ngcorrgerr(i,count) = sqrt(sum((mean(n_trials_nogo_corr,2) - n_trials_go_err(:,j)) .^ 2));
        inter.ngcorrngerr(i,count) = sqrt(sum((mean(n_trials_nogo_corr,2) - n_trials_nogo_err(:,j)) .^ 2));
        intra.gcorr(i,count) = sqrt(sum((mean(n_trials_go_corr,2) - n_trials_go_corr(:,j)) .^ 2));
        intra.ngcorr(i,count) = sqrt(sum((mean(n_trials_nogo_corr,2) - n_trials_nogo_corr(:,j)) .^ 2));
        count = count +1;
        
    end
end
