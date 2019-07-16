function p_baselinecheck = CheckTaskEngagement(trials,fps)
re = [trials.reward;];
re_ind = find(re);
trials = trials(re_ind);
for i =1:size(trials(1).C_raw,1)
    tmp_baseline = []; tmp_np=[];
    for j = 1:length(trials)
        tmp_baseline = [tmp_baseline mean(trials(j).C_raw(i,trials(j).nosepokeframe-fps+1:trials(j).nosepokeframe))];
        tmp_np = [tmp_np mean(trials(j).C_raw(i,trials(j).nosepokeframe:trials(j).nosepokeframe+round(0.5*fps)))];
    end
    [~,p_baselinecheck(i),~] = ttest2(tmp_np,tmp_baseline);
end
end