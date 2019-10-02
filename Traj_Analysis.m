function [res,seqNogoEng,seqgoEng] = Traj_Analysis(trials)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Aishwarya Parthasarathy, last updated - 29/7/2019
% this code plots the neural trajectories for the calciumimaging data recorded during
% the go/No-go task. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs - 
% trials - a structure containing behavioral data and the calcium
% transients from every trial (correct and incorrect). The length of the
% trial denotes the nuber of trials the animal performed. The fields of the
% struct contain information about different behavioral (ex: nosepoke frame) and neural
% variables (calcium transients from a population). Load this from the
% folder.
% Outputs - 
% Running this code will bring up a figure with neural trajectories
% computed for each trial at different task epochs. The title of the figure
% will describe the task epoch. It should be noted that the state space or
% the 3 dimensions of these figures will also be the same for all the
% figures generated ny the code and will be defined by the data in line 25
count = 1;
%line 21-29 describes the data used the build the state space or the 3
%dimensions
for i = 1:length(trials)
    if trials(i).reward
    dat(count).trialId = trials(i).nogo;
    dat(count).y = trials(i).C_raw(:,trials(i).nosepokecueoffframe-22:trials(i).nosepokecueoffframe+15);
    dat(count).T = size(dat(count).y,2);
    count = count+1;
    end
end
rew  = [trials.reward;];
ind_reward = find(rew);
trials_corr = trials(ind_reward);
% lines 34- 41 get the indices of correct go and no-go trials
go=[];nogo=[];
for i = 1:length(trials_corr)
    if trials_corr(i).nogo 
        nogo=[nogo i];
    else
        go = [go i];
    end
end

figure
% Using the function neuralTraj from the factor analysis toolbox (Yu et al,
% 2009, J Neurophysiology), we built the state space onto which the neural trajectories were projected. res contains the coordinates of the state space
% (or the 3 dimensions) built from the correct go and no-go trials defined
% by the variable dat. 

%Change the name under quotes every run. Otherwise it will load the data
% res that is associated with that name
res = neuralTraj('rat3_newtrya2g',dat);

% Build datasets to project in the statespace defined by res
% Data around task disengagement and task engagement for no-go trials. This
% particular animals was recorded at 15fps 

%For task engagement - we are computing trajectories from data 1s before
%nosepoke entry to 1s after nosepoke entry.
for i = 1:length(nogo)
dat_nogo_eng(i).y = trials_corr(nogo(i)).C_raw(:,trials_corr(nogo(i)).nosepokeframe-14:trials_corr(nogo(i)).nosepokeframe+60);
dat_nogo_eng(i).trialId = trials_corr(nogo(i)).nogo;
dat_nogo_eng(i).T = size(dat_nogo_eng(i).y,2);
end

% Computing the trajectories using population calcium transients in nogo
% trials around task engagement (in variable dat_nogo_eng)
% and plotted it in the subspace (in variable res). The resulting
% trajectories are defined in seqNew.
seqNogoEng = getTrajNewTrials(res, dat_nogo_eng);

%For task disengagement - we are computing trajectories from data 1s before
%nosepoke exit to 1s after nosepoke exit.
for i = 1:length(nogo)
dat_nogo_diseng(i).y = trials_corr(nogo(i)).C_raw(:,trials_corr(nogo(i)).nosepokecueoffframe-14:trials_corr(nogo(i)).nosepokecueoffframe+15);
dat_nogo_diseng(i).trialId = 25;
dat_nogo_diseng(i).T = size(dat_nogo_diseng(i).y,2);
end

% Computing the trajectories using population calcium transients in nogo
% trials around task disengagement (in variable dat_nogo_diseng)
% and plotted it in the subspace (in variable res). The resulting
% trajectories are defined in seqNew.
seqNogodisEng = getTrajNewTrials(res, dat_nogo_diseng);

subplot(2,1,1)
plot3D(seqNogoEng, 'xorth', 'dimsToPlot', 1:3);
hold on
plot3D(seqNogodisEng, 'xorth', 'dimsToPlot', 1:3);
title ('Nogo Trials. Engagement - red and disengagement - blue')
set(gca,'Box','On','XGrid','On','YGrid','On','ZGrid','On')

% Build datasets to project in the statespace defined by res
% Data around task disengagement and task engagement for go trials. This
% particular animals was recorded at 15fps 

%For task engagement - we are computing trajectories from data 1s before
%nosepoke entry to 1s after nosepoke entry.
for i = 1:length(go)
dat_go_eng(i).y = trials_corr(go(i)).C_raw(:,trials_corr(go(i)).nosepokeframe-14:trials_corr(go(i)).nosepokeframe+45);
dat_go_eng(i).trialId = 1;
dat_go_eng(i).T = size(dat_go_eng(i).y,2);
end

% Computing the trajectories using population calcium transients in nogo
% trials around task engagement (in variable dat_nogo_eng)
% and plotted it in the subspace (in variable res). The resulting
% trajectories are defined in seqNew.
seqgoEng = getTrajNewTrials(res, dat_go_eng);

%For task disengagement - we are computing trajectories from data 1s before
%lever press to 1s after leverpress
for i = 1:length(go)
dat_go_diseng(i).y = trials_corr(go(i)).C_raw(:,trials_corr(go(i)).leverpressframe-14:trials_corr(go(i)).leverpressframe+15);
dat_go_diseng(i).trialId = 25;
dat_go_diseng(i).T = size(dat_go_diseng(i).y,2);
end

% Computing the trajectories using population calcium transients in nogo
% trials around task disengagement (in variable dat_nogo_diseng)
% and plotted it in the subspace (in variable res). The resulting
% trajectories are defined in seqNew.
seqgodisEng = getTrajNewTrials(res, dat_go_diseng);

subplot(2,1,2)
plot3D(seqgoEng, 'xorth', 'dimsToPlot', 1:3);
hold on
plot3D(seqgodisEng, 'xorth', 'dimsToPlot', 1:3);
title ('Go Trials. Engagement - red and disengagement - blue')
set(gca,'Box','On','XGrid','On','YGrid','On','ZGrid','On')

