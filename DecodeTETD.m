function perf = DecodeTETD(trials,seqNogoEng)
for i = 1:length(trials)
    data_te(i,:) = seqNogoEng(i).xorth(:,trials(i).max_vec_npentry);
     data_td(i,:) = seqNogoEng(i).xorth(:,trials(i).max_vec_npexit);
     data_tn(i,:) = seqNogoEng(i).xorth(:,trials(i).max_vec_npentry + 30);
%      data_te(i,:) = seqNogoEng(i).xorth(:,1);
%     data_td(i,:) = seqNogoEng(i).xorth(:,end);
end
tot_dt = [data_te;data_td; data_tn];
tot_gr = [ones(size(data_td,1),1);2*ones(size(data_te,1),1);3*ones(size(data_te,1),1)];
tr_no = randsample(size(tot_dt,1),round(0.7*size(tot_dt,1)));
te_no = setdiff(1:size(tot_dt,1),tr_no);
class = classify(tot_dt(te_no,:),tot_dt(tr_no,:),tot_gr(tr_no));
perf = (length(find(class-tot_gr(te_no)==0))/length(class))*100;
