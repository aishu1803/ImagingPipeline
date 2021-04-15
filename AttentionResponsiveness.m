function p = AttentionResponsiveness(firingRates,tim,trialNum,trials,Exit,Shuf)
n_cells = size(firingRates,1);
reward = [trials.reward;];
ind_corr = find(reward);
trials_corr = trials(ind_corr);
nogo = [trials_corr.nogo;];
trials_corr_nogo = trials_corr(find(nogo));
trials_corr_go = trials_corr(setdiff(1:length(nogo),find(nogo)));
trials_err = trials(setdiff(1:length(reward),ind_corr));
nogo_err = [trials_err.nogo;];
trials_err_nogo = trials_err(find(nogo_err));
trials_err_go = trials_err(setdiff(1:length(nogo_err),find(nogo_err)));
tmp_npexit = [([trials_corr_go.nosepokecueoffframe;]-[trials_corr_go.nosepokeentryframe;]+14) ([trials_corr_nogo.nosepokecueoffframe;]-[trials_corr_nogo.nosepokeentryframe;]+14) ([trials_err_go.nosepokecueoffframe;]-[trials_err_go.nosepokeentryframe;]+14) ([trials_err_nogo.nosepokecueoffframe;]-[trials_err_nogo.nosepokeentryframe;]+14)];
if ~Shuf
    if ~Exit
        for i = 1:n_cells
            tmp_ng = squeeze(firingRates(i,1,1,tim,1:trialNum(1,1,1)));
            tmp_g = squeeze(firingRates(i,2,1,tim,1:trialNum(1,2,1)));
            tmp_ge = squeeze(firingRates(i,2,2,tim,1:trialNum(1,2,2)));
            tmp_nge = squeeze(firingRates(i,1,2,tim,1:trialNum(1,1,2)));
            tmp = [mean(tmp_g) mean(tmp_ng) mean(tmp_ge) mean(tmp_nge)];
            p(i,:) = anovan(tmp,{[repmat(1,1,trialNum(1,1,1) + trialNum(1,2,1)) repmat(2,1,trialNum(1,1,2) + trialNum(1,2,2))],[repmat(1,1,trialNum(1,2,1)) repmat(2,1,trialNum(1,1,1)),repmat(1,1,trialNum(1,2,2)),repmat(2,1,trialNum(1,1,2))]},'display','off');
        end
    else
        for i = 1:n_cells
            tmp_ng = squeeze(firingRates(i,1,1,:,1:trialNum(1,1,1)));
            tmp_g = squeeze(firingRates(i,2,1,:,1:trialNum(1,2,1)));
            tmp_ge = squeeze(firingRates(i,2,2,:,1:trialNum(1,2,2)));
            tmp_nge = squeeze(firingRates(i,1,2,:,1:trialNum(1,1,2)));
            tmp_act = [tmp_g tmp_ng tmp_ge tmp_nge];
            for j = 1:size(tmp_act,2)
                tmp(j) = mean(tmp_act(tmp_npexit(j)-tim(1):tmp_npexit(j)-tim(2),j));
            end
            p(i,:) = anovan(tmp,{[repmat(1,1,trialNum(1,1,1) + trialNum(1,2,1)) repmat(2,1,trialNum(1,1,2) + trialNum(1,2,2))],[repmat(1,1,trialNum(1,2,1)) repmat(2,1,trialNum(1,1,1)),repmat(1,1,trialNum(1,2,2)),repmat(2,1,trialNum(1,1,2))]},'model','interaction','display','off');
        end
    end
else
    if ~Exit
        for i = 1:n_cells
            tmp_ng = squeeze(firingRates(i,1,1,tim,1:trialNum(1,1,1)));
            tmp_g = squeeze(firingRates(i,2,1,tim,1:trialNum(1,2,1)));
            tmp_ge = squeeze(firingRates(i,2,2,tim,1:trialNum(1,2,2)));
            tmp_nge = squeeze(firingRates(i,1,2,tim,1:trialNum(1,1,2)));
            tmp = [mean(tmp_g) mean(tmp_ng) mean(tmp_ge) mean(tmp_nge)];
            p(i,:) = anovan(tmp(randperm(length(tmp))),{[repmat(1,1,trialNum(1,1,1) + trialNum(1,2,1)) repmat(2,1,trialNum(1,1,2) + trialNum(1,2,2))],[repmat(1,1,trialNum(1,2,1)) repmat(2,1,trialNum(1,1,1)),repmat(1,1,trialNum(1,2,2)),repmat(2,1,trialNum(1,1,2))]},'display','off');
        end
    else
        for i = 1:n_cells
            tmp_ng = squeeze(firingRates(i,1,1,:,1:trialNum(1,1,1)));
            tmp_g = squeeze(firingRates(i,2,1,:,1:trialNum(1,2,1)));
            tmp_ge = squeeze(firingRates(i,2,2,:,1:trialNum(1,2,2)));
            tmp_nge = squeeze(firingRates(i,1,2,:,1:trialNum(1,1,2)));
            tmp_act = [tmp_g tmp_ng tmp_ge tmp_nge];
            for j = 1:size(tmp_act,2)
                tmp(j) = mean(tmp_act(tmp_npexit(j)-tim(1):tmp_npexit(j)-tim(2),j));
            end
            p(i,:) = anovan(tmp(randperm(length(tmp))),{[repmat(1,1,trialNum(1,1,1) + trialNum(1,2,1)) repmat(2,1,trialNum(1,1,2) + trialNum(1,2,2))],[repmat(1,1,trialNum(1,2,1)) repmat(2,1,trialNum(1,1,1)),repmat(1,1,trialNum(1,2,2)),repmat(2,1,trialNum(1,1,2))]},'model','interaction','display','off');
        end
    end
end
