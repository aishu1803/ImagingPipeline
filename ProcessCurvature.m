function [overall_perf_pre_corr,overall_perf_pre_err,overall_perf_post_corr,overall_perf_post_err,confusion_corr,confusion_err,confusion_corr_post,confusion_err_post,cosi_pre500_gowi,cosi_pre500_gobw,cosi_post500_gowi,cosi_post500_gobw,cosi_pre500_nogowi,cosi_pre500_nogobw,cosi_post500_nogowi,cosi_post500_nogobw,cosi_prep500_gowi,cosi_prep500_gobw,cosi_prep500_nogowi,cosi_prep500_nogobw] = ProcessCurvature(go_curves,nogo_curves,go_err_curves,nogo_err_curves,trajs,cosi_ntrials_all)
% Trajectories 500ms before the curvature and 500ms after the curvature
for i = 1:length(go_curves)
    tmp_tp =go_curves(i).chdirfinal2;
    data_pre500_go(:,i) = mean(squeeze(trajs(:,tmp_tp-9:tmp_tp-4,2,1,i)),2);
    data_post500_go(:,i) = mean(squeeze(trajs(:,tmp_tp+4:tmp_tp+9,2,1,i)),2);
    tmp_pre500 = mean(squeeze(cosi_ntrials_all(i+length(nogo_curves),:,tmp_tp-9:tmp_tp-4)),2);
    tmp_prepre500 = mean(squeeze(cosi_ntrials_all(i+length(nogo_curves),:,tmp_tp-15:tmp_tp-10)),2);
    tmp_pre500(i+length(nogo_curves)) = [];
    ss = randsample(length(nogo_curves)-1,24);
    cosi_pre500_gowi(i) = mean(tmp_pre500(ss+length(nogo_curves)+1));
    cosi_pre500_gobw(i) = mean(tmp_pre500(ss));
    cosi_prep500_gowi(i) = mean(tmp_prepre500(ss+length(nogo_curves)+1));
    cosi_prep500_gobw(i) = mean(tmp_prepre500(ss));
    tmp_post500 = mean(squeeze(cosi_ntrials_all(i+length(nogo_curves),:,tmp_tp+4:tmp_tp+9)),2);
    tmp_post500(i+length(nogo_curves)) = [];
    cosi_post500_gowi(i) = mean(tmp_post500(ss+length(nogo_curves)+1));
    cosi_post500_gobw(i) = mean(tmp_post500(ss));
end
for i = 1:length(nogo_curves)
    tmp_tp =nogo_curves(i).chdirfinal2;
    data_pre500_nogo(:,i) = mean(squeeze(trajs(:,tmp_tp-9:tmp_tp-4,1,1,i)),2);
    data_post500_nogo(:,i) = mean(squeeze(trajs(:,tmp_tp+4:tmp_tp+9,1,1,i)),2);
    tmp_pre500 = mean(squeeze(cosi_ntrials_all(i,:,tmp_tp-9:tmp_tp-4)),2);
    tmp_prepre500 = mean(squeeze(cosi_ntrials_all(i,:,tmp_tp-15:tmp_tp-10)),2);
    tmp_pre500(i) = [];
    ss = randsample(length(nogo_curves)-1,24);
    cosi_pre500_nogowi(i) = mean(tmp_pre500(ss));
    cosi_pre500_nogobw(i) = mean(tmp_pre500(ss+length(nogo_curves)+1));
    cosi_prep500_nogowi(i) = mean(tmp_prepre500(ss));
    cosi_prep500_nogobw(i) = mean(tmp_prepre500(ss+length(nogo_curves)+1));
    tmp_post500 = mean(squeeze(cosi_ntrials_all(i,:,tmp_tp+4:tmp_tp+9)),2);
    tmp_post500(i) = [];
    cosi_post500_nogobw(i) = mean(tmp_post500(ss+length(nogo_curves)+1));
    cosi_post500_nogowi(i) = mean(tmp_post500(ss));
end
for i = 1:length(nogo_err_curves)
    tmp_tp =nogo_err_curves(i).chdirfinal2;
    data_pre500_nogoerr(:,i) = mean(squeeze(trajs(:,tmp_tp-9:tmp_tp-4,1,2,i)),2);
    data_post500_nogoerr(:,i) = mean(squeeze(trajs(:,tmp_tp+4:tmp_tp+9,1,2,i)),2);
end
for i = 1:length(go_err_curves)
    tmp_tp =go_err_curves(i).chdirfinal2;
    data_pre500_goerr(:,i) = mean(squeeze(trajs(:,tmp_tp-9:tmp_tp-4,2,2,i)),2);
    data_post500_goerr(:,i) = mean(squeeze(trajs(:,tmp_tp+4:tmp_tp+9,2,2,i)),2);
end
group = [repmat(1,1,length(nogo_curves)) repmat(2,1,length(go_curves)) repmat(1,1,length(nogo_err_curves)) repmat(2,1,length(go_err_curves))]';
group_true = [repmat(1,1,length(nogo_curves)) repmat(2,1,length(go_curves)) repmat(3,1,length(nogo_err_curves)) repmat(4,1,length(go_err_curves))]';
data_pre500 = [data_pre500_nogo'; data_pre500_go'; data_pre500_nogoerr'; data_pre500_goerr'];
data_post500 = [data_post500_nogo'; data_post500_go'; data_post500_nogoerr'; data_post500_goerr'];
training_set_nogo = randsample(length(nogo_curves),30);
training_set_go = randsample(length(go_curves),30) + length(nogo_curves);
training_set = [training_set_nogo; training_set_go];
testing_set = setdiff(1:length(group),training_set);
group_train = group(training_set);
group_test = group(testing_set);
group_test_true = group_true(testing_set);
data_pre500_train = data_pre500(training_set,:);
data_pre500_test = data_pre500(testing_set,:);
data_post500_train = data_post500(training_set,:);
data_post500_test = data_post500(testing_set,:);
class = classify(data_pre500_test,data_pre500_train,group_train);
corr_trials = find(group_test_true==1 | group_test_true==2);
err_trials = find(group_test_true==3 | group_test_true==4);
overall_perf_pre_corr = length(find(class(corr_trials) - group_test(corr_trials)==0))*100/length(corr_trials);
overall_perf_pre_err = length(find(class(err_trials) - group_test(err_trials)==0))*100/length(err_trials);
class_post = classify(data_post500_test,data_post500_train,group_train);
overall_perf_post_corr = length(find(class_post(corr_trials) - group_test(corr_trials)==0))*100/length(corr_trials);
overall_perf_post_err = length(find(class_post(err_trials) - group_test(err_trials)==0))*100/length(err_trials);
for tt = 1:2
    corr_tt = find(group_test(corr_trials)==tt);
    err_tt = find(group_test(err_trials)==tt) + err_trials(1) - 1;
    if tt ==1
    confusion_corr(tt,1) = length(find((class(corr_tt) - group_test(corr_tt)==0)))*100/length(corr_tt);
    confusion_corr(tt,2) = length(find((class(corr_tt) - group_test(corr_tt)~=0)))*100/length(corr_tt);
    confusion_err(tt,1) = length(find((class(err_tt) - group_test(err_tt)==0)))*100/length(err_tt);
    confusion_err(tt,2) = length(find((class(err_tt) - group_test(err_tt)~=0)))*100/length(err_tt);
    confusion_corr_post(tt,1) = length(find((class_post(corr_tt) - group_test(corr_tt)==0)))*100/length(corr_tt);
    confusion_corr_post(tt,2) = length(find((class_post(corr_tt) - group_test(corr_tt)~=0)))*100/length(corr_tt);
    confusion_err_post(tt,1) = length(find((class_post(err_tt) - group_test(err_tt)==0)))*100/length(err_tt);
    confusion_err_post(tt,2) = length(find((class_post(err_tt) - group_test(err_tt)~=0)))*100/length(err_tt);
    else
       confusion_corr(tt,2) = length(find((class(corr_tt) - group_test(corr_tt)==0)))*100/length(corr_tt);
    confusion_corr(tt,1) = length(find((class(corr_tt) - group_test(corr_tt)~=0)))*100/length(corr_tt);
    confusion_err(tt,2) = length(find((class(err_tt) - group_test(err_tt)==0)))*100/length(err_tt);
    confusion_err(tt,1) = length(find((class(err_tt) - group_test(err_tt)~=0)))*100/length(err_tt); 
     confusion_corr_post(tt,2) = length(find((class_post(corr_tt) - group_test(corr_tt)==0)))*100/length(corr_tt);
    confusion_corr_post(tt,1) = length(find((class_post(corr_tt) - group_test(corr_tt)~=0)))*100/length(corr_tt);
    confusion_err_post(tt,2) = length(find((class_post(err_tt) - group_test(err_tt)==0)))*100/length(err_tt);
    confusion_err_post(tt,1) = length(find((class_post(err_tt) - group_test(err_tt)~=0)))*100/length(err_tt);
    end
    
end

end
