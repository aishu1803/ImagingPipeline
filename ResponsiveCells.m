function [n_respcells,p] = ResponsiveCells(firingRates,trialNum,baseline,poi,n_consecutive)
n_cells = size(firingRates,1);
firingRates_corr = squeeze(firingRates(:,:,1,:,:));
n_go = trialNum(1,2,1);
n_nogo = trialNum(1,1,1);
if n_go < n_nogo
    n_trials = n_go;
else
    n_trials = n_nogo;
end
n_respcells = [];
for i = 1:n_cells
  tmp  = squeeze(cat(2,squeeze(firingRates_corr(i,1,:,1:n_trials)), squeeze(firingRates_corr(i,2,:,1:n_trials))));
  baseline_dat = mean(tmp(baseline,:),1);
  %baseline_dat = baseline_dat(:);
  for j = 1:size(tmp,1)
      [~,p(i,j)] = ttest2(tmp(j,:)',baseline_dat');
  end
  t = find(p(i,:)<0.05);
  N = n_consecutive; % Required number of consecutive numbers following a first one
 x = diff(t)==1;
 f = find([false,x]~=[x,false]);
 g = find(f(2:2:end)-f(1:2:end-1)>=N,1,'first');
 first_t = t(f(2*g-1)); % First t followed by >=N consecutive numbers
 if ~isempty(first_t)
     n_respcells = [n_respcells i];
 end
end
other = setdiff(1:n_cells,n_respcells);
p(other,:) = 1;
