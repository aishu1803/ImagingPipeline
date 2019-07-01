function res = CaTrajs(trials,npoff)

count = 1;
for i = 1:length(trials)
    if trials(i).reward
    dat(count).trialId = trials(i).nogo;
    dat(count).y = trials(i).C_raw(setdiff(1:size(trials(1).C_raw,1),npoff),trials(i).nosepokecueoffframe-22:trials(i).nosepokecueoffframe+15);
    dat(count).T = size(dat(count).y,2);
    count = count+1;
    end
end
go=[];nogo=[];
for i = 1:length(dat)
    if dat(i).trialId
        nogo=[nogo i];
    else
        go = [go i];
    end
end
count = 1;
for i = 1:length(trials)
    if trials(i).reward
    dat2(count).trialId = trials(i).nogo;
    dat2(count).y = trials(i).C_raw(setdiff(1:size(trials(1).C_raw,1),npoff),trials(i).nosepokeframe:trials(i).nosepokeframe+15);
    dat2(count).T = size(dat2(count).y,2);
    count = count+1;
    end
end


figure
nogo_dat = dat(nogo);
go_dat = dat(go);
% for gg = 1:length(ind_trialsaftererror)
%     dat(ind_trialsaftererror(gg)).trialId = dat(ind_trialsaftererror(gg)).trialId+5;
% end

res = neuralTraj('r80gggt97c',dat);
tt = [];
for i = 1:length(dat2)
    tt = [tt dat2(i).y];
end
go_percell = [go_dat.y;];
go_percell = reshape(go_percell,size(go_dat(1).y,1),size(go_dat(1).y,2),length(go_dat));
nogo_percell = [nogo_dat.y;];
nogo_percell = reshape(nogo_percell,size(nogo_dat(1).y,1),size(nogo_dat(1).y,2),length(nogo_dat));
m_tt = mean(tt,2);
st_tt = std(tt,[],2);
go_tmp=[];
subplot(2,4,1)
imagesc((squeeze(mean(go_percell,3))-repmat(m_tt,1,dat(1).T))./repmat(st_tt,1,dat(1).T))
hold on
line([22 22],ylim,'color','white')
subplot(2,4,2)
imagesc((squeeze(mean(nogo_percell,3))-repmat(m_tt,1,dat(1).T))./repmat(st_tt,1,dat(1).T))
hold on
line([22 22],ylim,'color','white')
for i = 1:length(go_dat)
    go_tmp = [go_tmp; mean((go_dat(i).y-repmat(m_tt,1,dat(1).T))./repmat(st_tt,1,dat(1).T))];
end
nogo_tmp=[];
for i = 1:length(nogo_dat)
    nogo_tmp = [nogo_tmp; mean((nogo_dat(i).y-repmat(m_tt,1,dat(1).T))./repmat(st_tt,1,dat(1).T))];
end
y_patch_go = [mean(go_tmp)+(std(go_tmp)/sqrt(size(go_tmp,1))) fliplr(mean(go_tmp)-(std(go_tmp)/sqrt(size(go_tmp,1))))];
y_patch_nogo = [mean(nogo_tmp)+(std(nogo_tmp)/sqrt(size(nogo_tmp,1))) fliplr(mean(nogo_tmp)-(std(nogo_tmp)/sqrt(size(nogo_tmp,1))))];
x_patch = [1:38 38:-1:1];
subplot(2,4,3)
plot(mean(go_tmp),'-g')
hold on
patch(x_patch,y_patch_go,[0 1 0],'EdgeColor','none','FaceAlpha',0.2)
plot(mean(nogo_tmp),'-r')
patch(x_patch,y_patch_nogo,[1 0 0],'EdgeColor','none','FaceAlpha',0.2)
line([22 22],ylim,'color','black')
for i = 1:dat(1).T
    tmp=[];
    for j = 1:length(dat)
        tmp=[tmp dat(j).y(:,i)];
    end
    tmp = (tmp-repmat(m_tt,1,length(dat)))./repmat(st_tt,1,length(dat));
    [p,tbl,stats] = anova1(tmp,[dat.trialId],'off');
    pev(i) = (tbl{2,2} - tbl{3,4})/(tbl{4,2} + tbl{3,4});
end
for i = 1:dat(1).T
    tmp=[];
    for j = 1:length(dat)
        tmp=[tmp dat(j).y(:,i)];
    end
    tmp = (tmp-repmat(m_tt,1,length(dat)))./repmat(st_tt,1,length(dat));
    for k = 1:1000
        [p,tbl,stats] = anova1(tmp,randsample([dat.trialId],length([dat.trialId])),'off');
        pev_shuf(i,k) = (tbl{2,2} - tbl{3,4})/(tbl{4,2} + tbl{3,4});
    end
end
subplot(2,4,4)
plot(pev*100,'-b')
hold on
plot(prctile(pev_shuf,97.5,2)*100,'--b')
line([22 22],ylim,'color','k')
[estparam,seqTrain,seqTest] = postprocess(res);
train=[seqTrain.xorth;];
train = reshape(train,3,dat(1).T,length(seqTrain));
test=[seqTest.xorth;];
test = reshape(test,3,dat(1).T,length(seqTest));
group = [seqTrain.trialId;];
testgroup = [seqTest.trialId;];
for i = 1:dat(1).T
    class(i,:) = classify(squeeze(test(:,i,:))',squeeze(train(:,i,:))',group);
    perf(i) = length(find(class(i,:)-testgroup==0))/length(testgroup);
    for k = 1:1000
        perf_shuf(i,k) = length(find(class(i,:)-randsample(testgroup,length(testgroup))==0))/length(testgroup);
    end
end
subplot(2,4,5)
plot3D(seqTrain,'xorth','dimsToPlot',1:3)
subplot(2,4,6)
plot(perf*100,'-r')
hold on
plot(prctile(perf_shuf,97.5,2)*100,'--r')
line([22 22],ylim,'color','black')
dir_train = trajdir(seqTrain);
dir_test = trajdir(seqTest);
dir_test = permute(dir_test,[1 3 2]);
dir_train = permute(dir_train,[1 3 2]);
dir_train = [train;dir_train];
dir_test = [test;dir_test];
for i = 3:size(dir_train,2)
    class_dir(i,:) = classify(squeeze(dir_test(:,i,:))',squeeze(dir_train(:,i,:))',group);
    perf_dir(i) = length(find(class_dir(i,:)-testgroup==0))/length(testgroup);
    for k = 1:1000
        perf_dir_shuf(i,k) = length(find(class_dir(i,:)-randsample(testgroup,length(testgroup))==0))/length(testgroup);
    end
end
subplot(2,4,7)
plot(perf_dir(3:end)*100,'-r')
hold on
plot(prctile(perf_dir_shuf(3:size(perf_dir_shuf,1),:),97.5,2)*100,'--r')
line([22 22],ylim,'color','black')
subplot(2,4,8)
for i = 3:size(dir_train,2)
    class_dironly(i,:) = classify(squeeze(dir_test(4:6,i,:))',squeeze(dir_train(4:6,i,:))',group);
    perf_dironly(i) = length(find(class_dironly(i,:)-testgroup==0))/length(testgroup);
    for k = 1:1000
        perf_dironly_shuf(i,k) = length(find(class_dironly(i,:)-randsample(testgroup,length(testgroup))==0))/length(testgroup);
    end
end
% z1 = perf'-mean(perf_shuf,2);
% z2 = perf_dir'-mean(perf_dir_shuf,2);
plot(perf_dironly(3:end)*100,'-r')
hold on
plot(prctile(perf_dironly_shuf(3:size(perf_dironly_shuf,1),:),97.5,2)*100,'--r');
line([22 22],ylim,'color','black')




function dir =  trajdir(seq)
for i = 1:length(seq)
    dy = diff(seq(i).xorth(2,:))./diff(seq(i).xorth(1,:));
    [b,ind] = max(abs(dy));
    for j = 3:size(seq(1).xorth,2)
        x = seq(i).xorth(1,j) - seq(i).xorth(1,j-2);
        y = seq(i).xorth(2,j) - seq(i).xorth(2,j-2);
        z = seq(i).xorth(3,j) - seq(i).xorth(3,j-2);
        dir(1,i,j) = atan2d(y,x);
        dir(2,i,j) = atan2d(x,z);
        dir(3,i,j) = atan2d(y,z);
    end
end
