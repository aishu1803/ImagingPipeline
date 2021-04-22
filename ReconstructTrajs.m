function [firingRates_taskonly,Trajs_taskonly,firingRates_timeonly,Trajs_timeonly] = ReconstructTrajs(firingRates,V,W,trialNum,whichMarg)
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
n_go_err = trialNum(1,2,2);
n_nogo_err = trialNum(1,1,2);
if n_go < n_nogo
    n_trials = n_go;
else
    n_trials = n_nogo;
end
if n_go_err < n_nogo_err
    n_trials_err = n_go_err;
else
    n_trials_err = n_nogo_err;
end
task_relatedcomptop3 = find(whichMarg==1 | whichMarg==4,3);
task_relatedcomp = find(whichMarg==4 | whichMarg==1);
time_relatedcomptop3 = find(whichMarg==3,3);
time_relatedcomp = find(whichMarg==3);
for i = 1:n_trials
    firingRates_taskonly(:,1,1,:,i) = squeeze(firingRates(:,1,1,:,i))'*V(:,task_relatedcomptop3)*W(:,task_relatedcomptop3)';
    firingRates_taskonly(:,2,1,:,i) = squeeze(firingRates(:,2,1,:,i))'*V(:,task_relatedcomptop3)*W(:,task_relatedcomptop3)';
    Trajs_taskonly(:,:,2,1,i) = (squeeze(firingRates(:,2,1,:,i))'*V(:,task_relatedcomp))';
    Trajs_taskonly(:,:,1,1,i) = (squeeze(firingRates(:,1,1,:,i))'*V(:,task_relatedcomp))';
end
firingRates_taskonly = permute(firingRates_taskonly,[4 2 3 1 5]);
firingRates_taskonly(:,1:2,2,:,:) = nan;
Trajs_taskonly(:,:,1:2,2,:) = nan;
for i = 1:n_trials
    firingRates_timeonly(:,1,1,:,i) = squeeze(firingRates(:,1,1,:,i))'*V(:,time_relatedcomptop3)*W(:,time_relatedcomptop3)';
    firingRates_timeonly(:,2,1,:,i) = squeeze(firingRates(:,2,1,:,i))'*V(:,time_relatedcomptop3)*W(:,time_relatedcomptop3)';
    Trajs_timeonly(:,:,2,1,i) = (squeeze(firingRates(:,2,1,:,i))'*V(:,time_relatedcomp))';
    Trajs_timeonly(:,:,1,1,i) = (squeeze(firingRates(:,1,1,:,i))'*V(:,time_relatedcomp))';
end
firingRates_timeonly = permute(firingRates_timeonly,[4 2 3 1 5]);
firingRates_timeonly(:,1:2,2,:,:) = nan;
Trajs_timeonly(:,:,1:2,2,:) = nan;
for k = 1:2
for i = 1:trialNum(1,k,2)
    firingRates_timeonly(:,k,2,:,i) = (squeeze(firingRates(:,k,2,:,i))'*V(:,time_relatedcomptop3)*W(:,time_relatedcomptop3)')';
    
    Trajs_timeonly(:,:,k,2,i) = (squeeze(firingRates(:,k,2,:,i))'*V(:,time_relatedcomp))';
    
    firingRates_taskonly(:,k,2,:,i) = (squeeze(firingRates(:,k,2,:,i))'*V(:,task_relatedcomptop3)*W(:,task_relatedcomptop3)')';
    
    Trajs_taskonly(:,:,k,2,i) = (squeeze(firingRates(:,k,2,:,i))'*V(:,task_relatedcomp))';
    
end
end