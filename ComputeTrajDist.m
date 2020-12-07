function [dist_go,dist_nogo] = ComputeTrajDist(Trajs,trialNum)
% Computes the distance traveled by the go and nogo trajectories. 
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
n_go_err = trialNum(1,2,2);
n_nogo_err = trialNum(1,1,2);
if n_go < n_nogo
    n_trials = n_go;
else
    n_trials = n_nogo;
end
for i = 1:n_trials
    com_bl_ng = mean(squeeze(Trajs(:,1:14,1,1,i)),2);
    com_bl_g = mean(squeeze(Trajs(:,1:14,2,1,i)),2);
    for j = 1:size(Trajs,2)
        tmp_ng = squeeze(Trajs(:,j,1,1,i));
        tmp_g = squeeze(Trajs(:,j,2,1,i));
        d_nogo = dist([tmp_ng com_bl_ng]);
        dist_nogo(i,j) = d_nogo(1,2);
        d_go = dist([tmp_g com_bl_g]);
        dist_go(i,j) = d_go(1,2);
    end
end