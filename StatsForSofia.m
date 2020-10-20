function n_cells = StatsForSofia(dat, baseline,period_interest)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes which cells show activity that is significantly
% different from baseline. 
% Input variables:
% dat - 3d matrix of size ncells x ntrials x nframes. This is the data on
% which you want to compute significant activity on. eg: cell_go_leverpress
% baseline - define the windows that constitute baseline activity, eg: 1:15
% period_interest - define the time windows that consitute the period of interest.
% eg: 16:30

dat_baseline = squeeze(mean(dat(:,:,baseline),3));
dat_period_interest = squeeze(mean(dat(:,:,period_interest),3));
n_cells=[];
for i = 1:size(dat,1)
    [~,p(i),~] = ttest(dat_period_interest(i,:),dat_baseline(i,:));
    if p(i)<0.05
        n_cells = [n_cells i];
    end
end
    
