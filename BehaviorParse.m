function [perf,perf_gorew,perf_gopun,perf_nogorew,perf_nogopun] = BehaviorParse(A,D,E)
n_gr = length(find(E==32));
n_gp = length(find(E==33));
n_nr = length(find(E==34));
n_np = length(find(E==35));
ind_trial_start = find(E==2);
n_corr_gr = 0;n_corr_nr = 0;n_corr_gp = 0;n_corr_np = 0;
for i = 1:length(ind_trial_start)-1
    tmp = E(ind_trial_start(i):ind_trial_start(i+1));
    if ~isempty(find(tmp==3)) && ~isempty(find(tmp==32))
        n_corr_gr = n_corr_gr+1;
    elseif ~isempty(find(tmp==3)) && ~isempty(find(tmp==34))
        n_corr_nr = n_corr_nr+1;
    elseif ~isempty(find(tmp==28)) && ~isempty(find(tmp==33))
        n_corr_gp = n_corr_gp + 1;
    elseif ~isempty(find(tmp==28)) && ~isempty(find(tmp==35))
        n_corr_np = n_corr_np+1;
    end
end
perf = (n_corr_nr+n_corr_gr+n_corr_gp+n_corr_np)/(n_gr+n_gp+n_nr+n_np);
perf_gorew = n_corr_gr/n_gr;
perf_gopun = n_corr_gp/n_gp;
perf_nogorew = n_corr_nr/n_nr;
perf_nogopun = n_corr_np/n_np;
