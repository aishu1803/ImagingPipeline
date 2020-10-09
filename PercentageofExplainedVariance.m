function pev = PercentageofExplainedVariance(firingRates,trialNum,shuf)
n_trials_nogo = trialNum(1,1,1);
n_trials_go = trialNum(1,2,1);
group = [ones(1,n_trials_nogo) 2*ones(1,n_trials_go)];
for i  = 1:size(firingRates,1)
    for j = 1:size(firingRates,4)
        tmp1 = squeeze(firingRates(i,1,1,j,1:n_trials_nogo));
        tmp2 = squeeze(firingRates(i,2,1,j,1:n_trials_go));
        dat  = [tmp1' tmp2'];
        if shuf 
            dat = dat(randperm(length(dat)));
        end
        [~,tbl] = anova1(dat,group,'off');
        pev(i,j) = (tbl{2,2} - tbl{3,4})/(tbl{4,2}+tbl{3,4});
    end
end