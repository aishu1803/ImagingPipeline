function GoNogoSelectivity(firingRates,n_cells,trialNum)
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
for i = n_cells
    tmp_go = squeeze(firingRates(i,2,1,:,1:n_go));
    tmp_nogo = squeeze(firingRates(i,1,1,:,1:n_nogo));
    
end