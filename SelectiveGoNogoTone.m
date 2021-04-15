function p = SelectiveGoNogoTone(toneon_go,toneon_nogo,n_cells_go,n_cells_nogo)
n_cells = unique([n_cells_go n_cells_nogo]);
n_trials = 48;
for i = 1:length(n_cells)
    tmp_go = squeeze(toneon_go(n_cells(i),:,1:n_trials))';
    tmp_nogo = squeeze(toneon_nogo(n_cells(i),:,1:n_trials))';
    tmp = [tmp_go;tmp_nogo];
    gr = [repmat(1,n_trials,1);repmat(2,n_trials,1)];
    for j = 22:30
        [p(n_cells(i),j),~,~] = anova1(tmp(:,j),gr,'off');
    end
end
        
