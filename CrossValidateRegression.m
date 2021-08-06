function CrossValidateRegression(task_Event,firingRates,n_fold,trialNum)
CV0 = cvpartition(1:length(task_Event),'k',n_fold);
n_nogo = trialNum(1,1,1);
n_go = trialNum(1,2,1);
for i = 1:n_fold
    c(:,i) = test(CV0,i);
end
for n_neurons = 1:size(firingRates,1)
    cell_1 = [];
    cell_1 = squeeze(firingRates(n_neurons,1,1,:,1:n_nogo));
    cell_1 = [cell_1 squeeze(firingRates(n_neurons,2,1,:,1:n_go))];
    cell1=[];
    for i = 1:n_go+n_nogo
        cell1 = [cell1;cell_1(:,i)];
    end
    for i_fold = 1:n_fold
        test_trials = find(c(:,i_fold));
    end
end