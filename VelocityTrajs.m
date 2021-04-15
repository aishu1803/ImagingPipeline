function [D_nogo,D_nogo_error,D_go,D_go_error,go_lvrpress,nogo_err_exit] =  VelocityTrajs(Trajs_taskonly,trialNum,trials,ind_ee)
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
for i = 1:n_nogo
    tmp = squeeze(Trajs_taskonly(1:3,:,1,1,i));
    for j = 1:size(tmp,2)-1
        G = tmp(:,j);
        G2 = tmp(:,j+1);
        D_nogo(i,j)  = sqrt(sum((G - G2) .^ 2));
    end
end
for i = 1:n_go
    tmp = squeeze(Trajs_taskonly(1:3,:,2,1,i));
    for j = 1:size(tmp,2)-1
        G = tmp(:,j);
        G2 = tmp(:,j+1);
        D_go(i,j)  = sqrt(sum((G - G2) .^ 2));
    end
end
for i = 1:n_nogo_error
    tmp = squeeze(Trajs_taskonly(1:3,:,1,2,i));
    for j = 1:size(tmp,2)-1
        G = tmp(:,j);
        G2 = tmp(:,j+1);
        D_nogo_error(i,j)  = sqrt(sum((G - G2) .^ 2));
    end
end
for i = 1:n_go_error
    tmp = squeeze(Trajs_taskonly(1:3,:,2,2,i));
    for j = 1:size(tmp,2)-1
        G = tmp(:,j);
        G2 = tmp(:,j+1);
        D_go_error(i,j)  = sqrt(sum((G - G2) .^ 2));
    end
end