function [perf_traj,perf_overall_gng] = Decode(W,firingRates,trialNum,shuf,dims)
top_3_proj = nan(length(dims),size(firingRates,2),size(firingRates,3),size(firingRates,4),size(firingRates,5));
rng('shuffle');
for i = 1:2
    for j = 1:2
        for k = 1:trialNum(1,i,j)
            top_3_proj(:,i,j,:,k) = W(:,dims)'*squeeze(firingRates(:,i,j,:,k));
%             for l = 1:length(dims)
%             top_3_proj(l,i,j,:,k) = top_3_proj(l,i,j,:,k)- top_3_proj(l,i,j,1,k);
% %             top_3_proj(l,i,j,:,k) = top_3_proj(2,i,j,:,k) - top_3_proj(2,i,j,1,k);
% %             top_3_proj(3,i,j,:,k) = top_3_proj(3,i,j,:,k)- top_3_proj(3,i,j,1,k);
%             end
            
            
        end
    end
end
for i = 1:size(top_3_proj,1)
    for j = 1:2
        for k = 1:2
            for m = 1:trialNum(1,j,k)
                top_3_proj(i,j,k,:,m) = smooth(top_3_proj(i,j,k,:,m));
            end
        end
    end
end


z_score_firingRatesAverage = nanmean(firingRates,5);
z_score_firingRates = firingRates;

     test_nogo = randsample(trialNum(1,1,1),round(trialNum(1,1,1)*0.45));

     test_go = randsample(trialNum(1,2,1),round(trialNum(1,2,1)*0.45));
    
%     test_go_err = randsample(trialNum(1,2,2),round(trialNum(1,1,2)*0.5));
    test_go_err = 1:trialNum(1,2,2);
%     test_nogo_err = randsample(trialNum(1,1,2),round(trialNum(1,1,2)*0.5));
    test_nogo_err = 1:trialNum(1,1,2);


train_nogo = setdiff(1:trialNum(1,1,1),test_nogo);
train_go = setdiff(1:trialNum(1,2,1),test_go);
% train_nogo_err = setdiff(1:trialNum(1,1,2),test_nogo_err);
% train_go_err = setdiff(1:trialNum(1,2,2),test_go_err);
for i = 1:length(train_nogo)
    train_data_nogo(:,:,i) = squeeze(top_3_proj(:,1,1,:,train_nogo(i)));
%     train_data_nogo_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,1,1,:,train_nogo(i)));
end
for i = 1:length(train_go)
    train_data_go(:,:,i) = squeeze(top_3_proj(:,2,1,:,train_go(i)));
    %train_data_go_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,2,1,:,train_go(i)));
end
% for i = 1:length(train_nogo_err)
%     train_data_nogo_err(:,:,i) = squeeze(top_3_proj(:,1,2,:,train_nogo_err(i)));
%     train_data_nogo_err_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,1,2,:,train_nogo_err(i)));
% end
% for i = 1:length(train_go_err)
%     train_data_go_err(:,:,i) = squeeze(top_3_proj(:,2,2,:,train_go_err(i)));
%     train_data_go_err_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,2,2,:,train_go_err(i)));
% end
% train_data = cat(3,train_data_nogo, train_data_go, train_data_nogo_err, train_data_go_err);
% train_data_raw = cat(3,train_data_nogo_raw, train_data_go_raw, train_data_nogo_err_raw, train_data_go_err_raw);
train_data = cat(3,train_data_nogo, train_data_go);
%train_data_raw = cat(3,train_data_nogo_raw, train_data_go_raw);
if shuf
    ind = randperm(size(train_data,3));
    train_data = train_data(:,:,ind);
    %train_data_raw = train_data_raw(:,:,ind);
end
for i = 1:length(test_nogo)
    test_data_nogo(:,:,i) = squeeze(top_3_proj(:,1,1,:,test_nogo(i)));
    %test_data_nogo_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,1,1,:,test_nogo(i)));
end
for i = 1:length(test_go)
    test_data_go(:,:,i) = squeeze(top_3_proj(:,2,1,:,test_go(i)));
    %test_data_go_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,2,1,:,test_go(i)));
end
for i = 1:length(test_nogo_err)
    test_data_nogo_err(:,:,i) = squeeze(top_3_proj(:,1,2,:,test_nogo_err(i)));
    %test_data_nogo_err_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,1,2,:,test_nogo_err(i)));
end
for i = 1:length(test_go_err)
    test_data_go_err(:,:,i) = squeeze(top_3_proj(:,2,2,:,test_go_err(i)));
    %test_data_go_err_raw(:,:,i) = squeeze(z_score_firingRatesAverage(1,2,2,:,test_go_err(i)));
end

% len_test = [length(test_nogo) length(test_go) length(test_nogo_err) length(test_go_err)];
 len_test = [length(test_nogo) length(test_go)];
len_test = cumsum(len_test);
% test_data = cat(3,test_data_nogo, test_data_go,test_data_nogo_err, test_data_go_err);
 test_data = cat(3,test_data_nogo, test_data_go);
%test_data_raw = cat(3,test_data_nogo_raw, test_data_go_raw,test_data_nogo_err_raw, test_data_go_err_raw);
% test_data_raw = cat(3,test_data_nogo_raw, test_data_go_raw);
training_group = [ones(1,length(train_nogo)) 2*ones(1,length(train_go))]; 
    %2*ones(1,length(train_nogo_err)) 2*ones(1,length(train_go_err))];
% training_group_raw = [ones(1,length(train_nogo)) 2*ones(1,length(train_go)) ones(1,length(test_nogo)) 2*ones(1,length(test_go)) ];
  testing_group = [ones(1,length(test_nogo)) 2*ones(1,length(test_go)) ];
for tim = 2:size(firingRates,4)
    %     for j = 2:size(firingRates,4)
    class = classify(squeeze(test_data(:,tim,:))',squeeze(train_data(:,tim,:))',training_group,'linear');
    %class_raw = classify(squeeze(test_data_raw(tim,:,:)),squeeze(train_data_raw(tim,:,:)),training_group);
    %         perf_traj(j-1,tim-1) = length(find(class'-testing_group==0))/length(testing_group);
    %          perf_raw(j-1,tim-1) = length(find(class_raw'-testing_group==0))/length(testing_group);
    %     end
    perf_overall_gng(tim-1) = length(find(class(1:len_test(2)) - testing_group' ==0))/length(testing_group);
    for j = 1:length(len_test)
        if j==1
            perf_traj(j,tim-1) = length(find(class(1:len_test(j))==j))/length(test_nogo);
            %perf_raw(j,tim-1) = length(find(class_raw(1:len_test(j))==j))/length(test_nogo);
        elseif j==2
            perf_traj(j,tim-1) = length(find(class(len_test(j-1)+1:len_test(j))==j))/length(test_go);
            %perf_raw(j,tim-1) = length(find(class_raw(len_test(j-1)+1:len_test(j))==j))/length(test_go);
        elseif j ==3
            perf_traj(j,tim-1) = length(find(class(len_test(j-1)+1:len_test(j))==2))/length(test_nogo_err);
            %perf_raw(j,tim-1) = length(find(class_raw(len_test(j-1)+1:len_test(j))==2))/length(test_nogo_err);
        else
            perf_traj(j,tim-1) = length(find(class(len_test(j-1)+1:len_test(j))==1))/length(test_go_err);
            %perf_raw(j,tim-1) = length(find(class_raw(len_test(j-1)+1:len_test(j))==1))/length(test_go_err);
        end
    end
end
