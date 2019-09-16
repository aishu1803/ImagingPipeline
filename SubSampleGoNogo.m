function [go,nogo] = SubSampleGoNogo(trials,fps)
n_nogo = length(find([trials.type;])); %n_nogo stores the number of nogo trials
n_go = length(trials)-n_nogo; %n_go stores the number of go trials
ind_nogo = find([trials.type;]); % Indices of the nogo trials
ind_go = setdiff(1:length(trials),ind_nogo);
if n_go < n_nogo
    
    n_cells = size(trials(1).C_raw,1);
    n_trials = length(trials);
    for i = 1:n_cells
        %Randomly pick n_go number of nogo trials
        for j = 1:50 %subsampling to achieve 50 "averaged trials" for go and nogo each
            tmp_nogo=[];tmp_go=[];
            ss_nogo = randsample(n_nogo,n_go);
            ss_go = randsample(n_go,n_go);
            for k = 1:length(ss_nogo)
                tmp_nogo_trial = ind_nogo(ss_nogo(k));
                tmp_go_trial = ind_go(ss_go(k));
                tmp_nogo = [tmp_nogo; mean(trials(tmp_nogo_trial).C_raw(i,trials(tmp_nogo_trial).nosepokeframe:trials(tmp_nogo_trial).nosepokeframe + round(0.5*fps)))];
                tmp_go = [tmp_go; mean(trials(tmp_go_trial).C_raw(i,trials(tmp_go_trial).nosepokeframe:trials(tmp_go_trial).nosepokeframe + round(0.5*fps)))];
            end
            nogo(i,j) = mean(tmp_nogo);
            go(i,j) = mean(tmp_go);
        end
    end
else
    n_cells = size(trials(1).C_raw,1);
    n_trials = length(trials);
    for i = 1:n_cells
        %Randomly pick n_go number of nogo trials
        for j = 1:50 %subsampling to achieve 50 "averaged trials" for go and nogo each
            tmp_nogo=[];tmp_go=[];
            ss_nogo = randsample(n_nogo,n_nogo);
            ss_go = randsample(n_go,n_nogo);
            for k = 1:length(ss_nogo)
                tmp_nogo_trial = ind_nogo(ss_nogo(k));
                tmp_go_trial = ind_go(ss_go(k));
                tmp_nogo = [tmp_nogo; mean(trials(tmp_nogo_trial).C_raw(i,trials(tmp_nogo_trial).nosepokeframe:trials(tmp_nogo_trial).nosepokeframe + round(0.5*fps)))];
                tmp_go = [tmp_go; mean(trials(tmp_go_trial).C_raw(i,trials(tmp_go_trial).nosepokeframe:trials(tmp_go_trial).nosepokeframe + round(0.5*fps)))];
            end
            nogo(i,j) = mean(tmp_nogo);
            go(i,j) = mean(tmp_go);
        end
    end
end