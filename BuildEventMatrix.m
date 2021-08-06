function [task_Event] =  BuildEventMatrix(trials,eve)
task_events = {'npentry','tone_go_on','tone_nogo_on','reward','lp'};
task_events(eve) = [];
% Identifying correct trials
rew = [trials.reward;];
ind_rew = find(rew);
trials_corre = trials(ind_rew);
nogo = [trials_corre.nogo;];
ind_nogo = find(nogo==0);
ind_go = setdiff(1:length(ind_rew),ind_nogo);
trials_nogo = trials_corre(ind_nogo);
trials_go = trials_corre(ind_go);
trials_corr = [trials_nogo trials_go];
% Define lags to be built into the task events
lags.npentry = [-7 7];
lags.npexit = [-7 7];
lags.tone_go_on = [0 7];
lags.tone_nogo_on = [0 7];
lags.reward = [0 7];
lags.lp = [-7 7];
% Identifying frames when the events mentioned in task_Events occur
npentry = ones(length(trials_corr),1)*30;
npexit = [trials_corr.nosepokeexitframe;] - [trials_corr.nosepokeentryframe;] +29;
reward = [trials_corr.rewardframe;] - [trials_corr.nosepokeentryframe;] + 29;
tone_go_on = nan(length(trials_corr),1);
lp = nan(length(trials_corr),1);
tone_nogo_on = nan(length(trials_corr),1);
nogo = [trials_corr.nogo;];
ind_nogo = find(nogo);
ind_go = setdiff(1:length(trials_corr),ind_nogo);
for i = ind_go
    tone_go_on(i) = 37;
    lp(i) = trials_corr(i).rewardframe - trials_corr(i).nosepokeentryframe + 30;
end
for i = ind_nogo
    tone_nogo_on(i) = 37;
end
for n_trials = 1:length(trials_corr)
    tmp = [];
    for i_event = 1:length(task_events)
        str = sprintf('%s(n_trials)',task_events{i_event});
        tmp_val = eval(str);
        if isnan(tmp_val) 
            tmp_taskmat = zeros(90,90);
            tmp = [tmp tmp_taskmat];
        else
            tmp_lag  = getfield(lags,task_events{i_event});
            tmp_taskmat = zeros(90,90);
            
            for j_lag = tmp_val+tmp_lag(1):tmp_val+tmp_lag(2)
                tmp_taskmat(j_lag,j_lag) = 1;
            end
            if tmp_val + tmp_lag(2) > 90
                break
            end
            tmp = [tmp tmp_taskmat];
        end
    end
    task_Event(n_trials).val = tmp';
end