function [cosi_ntrials,go_prctile_dtprod,nogo_prctile_dtprod,ngo_prctile_dtprod,cosi_ntrials_err,cosi_ntrials_all] = TrialSimilarity(firingRates,trialNum,poi)
firingRates_corr = squeeze(firingRates(:,:,1,:,:));
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
if n_go < n_nogo
    n_trials = n_go;
else
    n_trials = n_nogo;
end
popn_firingRates = cat(3,squeeze(firingRates_corr(:,1,:,1:n_trials)),squeeze(firingRates_corr(:,2,:,1:n_trials)));
m_popn_firingRates = squeeze(popn_firingRates(:,poi,:));
for i = 1:size(m_popn_firingRates,2)
    for j = 1:size(m_popn_firingRates,2)
        tmp1 = m_popn_firingRates(:,i);
        tmp2 = m_popn_firingRates(:,j);
        cosi_ntrials(i,j) = dot(tmp1,tmp2)/(sqrt(tmp1'*tmp1)*sqrt(tmp2'*tmp2));
    end
end

off_cosi_ntrials_nogo = tril(cosi_ntrials(1:n_trials,1:n_trials),-1);
off_cosi_ntrials_go = tril(cosi_ntrials(n_trials+1:size(cosi_ntrials,1),n_trials+1:size(cosi_ntrials,1)),-1);
off_cosi_ntrials_ngo = cosi_ntrials(1:n_trials,n_trials+1:size(cosi_ntrials,1));
[ind_i_go,ind_j_go] = find(off_cosi_ntrials_go);
off_cosi_ntrials_go = off_cosi_ntrials_go(ind_i_go,ind_j_go);
t = off_cosi_ntrials_go(:,1);
go_prctile_dtprod = prctile(t,[10 90]);
[ind_i_nogo,ind_j_nogo] = find(off_cosi_ntrials_nogo);
off_cosi_ntrials_nogo = off_cosi_ntrials_nogo(ind_i_nogo,ind_j_nogo);
t_nogo = off_cosi_ntrials_nogo(:,1);
t_ngo = off_cosi_ntrials_ngo(:);
nogo_prctile_dtprod = prctile(t_nogo,[10 90]);
ngo_prctile_dtprod = prctile(t_ngo,[10 90]);

firingRates_err = squeeze(firingRates(:,:,2,:,:));
n_go_err = trialNum(1,2,2);
n_nogo_err = trialNum(1,1,2);
total_trials = n_go_err + n_nogo_err;
popn_firingRates = cat(3,squeeze(firingRates_err(:,1,:,1:n_nogo_err)),squeeze(firingRates_err(:,2,:,1:n_go_err)));
m_popn_firingRates = squeeze(popn_firingRates(:,poi,:));
for i = 1:size(m_popn_firingRates,2)
    for j = 1:size(m_popn_firingRates,2)
        tmp1 = m_popn_firingRates(:,i);
        tmp2 = m_popn_firingRates(:,j);
        cosi_ntrials_err(i,j) = dot(tmp1,tmp2)/(sqrt(tmp1'*tmp1)*sqrt(tmp2'*tmp2));
    end
end
popn_firingRates = cat(3,squeeze(firingRates_corr(:,1,:,1:n_trials)),squeeze(firingRates_corr(:,2,:,1:n_trials)),squeeze(firingRates_err(:,1,:,1:n_nogo_err)),squeeze(firingRates_err(:,2,:,1:n_go_err)));
m_popn_firingRates = squeeze(popn_firingRates(:,poi,:));
for i = 1:size(m_popn_firingRates,2)
    for j = 1:size(m_popn_firingRates,2)
        tmp1 = m_popn_firingRates(:,i);
        tmp2 = m_popn_firingRates(:,j);
        cosi_ntrials_all(i,j) = dot(tmp1,tmp2)/(sqrt(tmp1'*tmp1)*sqrt(tmp2'*tmp2));
    end
end
% off_cosi_ntrials_nogo = tril(cosi_ntrials(1:n_trials,1:n_trials),-1);
% off_cosi_ntrials_go = tril(cosi_ntrials(n_trials+1:size(cosi_ntrials,1),n_trials+1:size(cosi_ntrials,1)),-1);
% off_cosi_ntrials_ngo = cosi_ntrials(1:n_trials,n_trials+1:size(cosi_ntrials,1));
% [ind_i_go,ind_j_go] = find(off_cosi_ntrials_go);
% off_cosi_ntrials_go = off_cosi_ntrials_go(ind_i_go,ind_j_go);
% t = off_cosi_ntrials_go(:,1);
% go_prctile_dtprod = prctile(t,[10 90]);
% [ind_i_nogo,ind_j_nogo] = find(off_cosi_ntrials_nogo);
% off_cosi_ntrials_nogo = off_cosi_ntrials_nogo(ind_i_nogo,ind_j_nogo);
% t_nogo = off_cosi_ntrials_nogo(:,1);
% t_ngo = off_cosi_ntrials_ngo(:);
% nogo_prctile_dtprod = prctile(t_nogo,[10 90]);
% ngo_prctile_dtprod = prctile(t_ngo,[10 90]);

