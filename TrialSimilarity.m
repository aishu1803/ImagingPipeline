function [cosi_ntrials] = TrialSimilarity(firingRates,trialNum,poi)
firingRates_corr = squeeze(firingRates(:,:,1,:,:));
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
if n_go < n_nogo
    n_trials = n_go;
else
    n_trials = n_nogo;
end
popn_firingRates = cat(3,squeeze(firingRates_corr(:,1,:,1:n_trials)),squeeze(firingRates(:,2,1,:,1:n_trials)));
m_popn_firingRates = squeeze(mean(popn_firingRates(:,poi,:),2));
for i = 1:size(m_popn_firingRates,2)
    for j = 1:size(m_popn_firingRates,2)
        tmp1 = m_popn_firingRates(:,i);
        tmp2 = m_popn_firingRates(:,j);
        cosi_ntrials(i,j) = dot(tmp1,tmp2)/(sqrt(tmp1'*tmp1)*sqrt(tmp2'*tmp2));
    end
end