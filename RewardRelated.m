function [rew_resp,rew_gonogo,npoff,act] =  RewardRelated(trials)
go = [];nogo=[];rew_resp=[];rew_gonogo=[];npoff=[];
mkdir('RewardEffect')
for i = 1:length(trials)
    if trials(i).nogo==1  & trials(i).reward
        nogo=[nogo i];
    elseif trials(i).nogo==0  &trials(i).reward
        go = [go i];
    end
end
n_neurons = size(trials(1).C_raw,1);
for i = 1:n_neurons
    figure
    tmp_go=[];tmp_nogo=[];
    for j = nogo
        tmp_nogo = [tmp_nogo;trials(j).C_raw(i,trials(j).rewardframe-22:trials(j).rewardframe+22)];
    end
    for k = go
        tmp_go =[tmp_go;trials(k).C_raw(i,trials(k).rewardframe-22:trials(k).rewardframe+22)];
    end
    tmp = [tmp_go;tmp_nogo];
    baseline_reward = mean(tmp(:,32:47),2);%pre-reward baseline
    for tim = 48:80
        [~,p(tim-47)] = ttest2(tmp(:,tim),baseline_reward);
    end
    h = find(p<0.05);
    N = 3; % Required number of consecutive numbers following a first one
 x = diff(h)==1;
 f = find([false,x]~=[x,false]);
 g = find(f(2:2:end)-f(1:2:end-1)>=N,1,'first');
 first_t = h(f(2*g-1));% First t followed by >=N consecutive numbers
  if ~isempty(first_t) 
      rew_resp =[rew_resp i];
  end
 subplot(1,3,1)
    plot([-50:40]*0.033,mean(tmp),'-k')
     xdata = [-50:1:40 40:-1:-50]*0.033;
    y_data = [mean(tmp)+(std(tmp)/sqrt(length([go nogo]))) fliplr(mean(tmp)-(std(tmp)/sqrt(length([go nogo]))))];
    patch(xdata,y_data,'k','FaceAlpha','0.2','EdgeColor','none')
     line([0 0],ylim,'color','k','LineStyle',':')
    xlabel('Time from reward (s)')
    title({'reward related activity','error bars are sem'})
    subplot(1,3,2)
    plot([-50:40]*0.033,mean(tmp_go),'-g')
    hold on
    plot([-50:40]*0.033,mean(tmp_nogo),'-r')
    legend('go','no-go')
    xdata = [-50:1:40 40:-1:-50]*0.033;
    y_datago = [mean(tmp_go)+(std(tmp_go)/sqrt(length(go))) fliplr(mean(tmp_go)-(std(tmp_go)/sqrt(length(go))))];
    y_datanogo = [mean(tmp_nogo)+(std(tmp_nogo)/sqrt(length(nogo))) fliplr(mean(tmp_nogo)-(std(tmp_nogo)/sqrt(length(nogo))))];
    patch(xdata,y_datago,'g','FaceAlpha','0.2','EdgeColor','none')
    patch(xdata,y_datanogo,'r','FaceAlpha','0.2','EdgeColor','none')
    line([0 0],ylim,'color','k','LineStyle',':')
    xlabel('Time from reward (s)')
    title({'Go Vs No-go','error bars are sem'})
    for tim = 48:80
        [~,p_gonogo(tim-47)] = ttest2(tmp_go(:,tim),tmp_nogo(:,tim));
    end
    h = find(p_gonogo<0.05);
    N = 3; % Required number of consecutive numbers following a first one
 x = diff(h)==1;
 f = find([false,x]~=[x,false]);
 g = find(f(2:2:end)-f(1:2:end-1)>=N,1,'first');
 first_t = h(f(2*g-1));
 if ~isempty(first_t)
     rew_gonogo = [rew_gonogo i];
 end
    subplot(1,3,3)
    tmp_go=[];
    tmp_nogo=[];
    for j = nogo
        tmp_nogo = [tmp_nogo;trials(j).C_raw(i,trials(j).nosepokeframe+60:trials(j).nosepokeframe+120)];
    end
    for k = go
        tmp_go =[tmp_go;trials(k).C_raw(i,trials(k).nosepokeframe-15:trials(k).nosepokeframe+45)];
    end
    act(i).go = tmp_go;
    act(i).nogo = tmp_nogo;
plot([-30:30]*0.033,mean(act(i).go),'-g')
    hold on
    plot([-30:30]*0.033,mean(act(i).nogo),'-r')
    legend('go','no-go')
   for tim = 1:60
        [~,p_gn(tim)] = ttest2(act(i).go(:,tim),act(i).nogo(:,tim));
    end
    h1 = find(p_gn(15:30)<0.05);
    h2 = find(p_gn(31:60)<0.05);
    N = 3; % Required number of consecutive numbers following a first one
 x1 = diff(h1)==1;
 f1 = find([false,x1]~=[x1,false]);
 g1 = find(f1(2:2:end)-f1(1:2:end-1)>=N,1,'first');
 first_t1 = h1(f1(2*g1-1));
  x2 = diff(h2)==1;
 f2 = find([false,x2]~=[x2,false]);
 g2 = find(f2(2:2:end)-f2(1:2:end-1)>=N,1,'first');
 first_t2 = h2(f2(2*g2-1));
 if isempty(first_t1) & ~isempty(first_t2)
     npoff = [npoff i];
 end
    xdata = [-30:1:30 30:-1:-30]*0.033;
    y_datago = [mean(tmp_go)+(std(tmp_go)/sqrt(length(go))) fliplr(mean(tmp_go)-(std(tmp_go)/sqrt(length(go))))];
    y_datanogo = [mean(tmp_nogo)+(std(tmp_nogo)/sqrt(length(nogo))) fliplr(mean(tmp_nogo)-(std(tmp_nogo)/sqrt(length(nogo))))];
    patch(xdata,y_datago,'g','FaceAlpha','0.2','EdgeColor','none')
    patch(xdata,y_datanogo,'r','FaceAlpha','0.2','EdgeColor','none')
    line([0 0],ylim,'color','k','LineStyle',':')
    xlabel('Time from nosepoke cue off (s)')
    title({'Go Vs No-go','error bars are sem'})
    filename = sprintf('RewardEffect\\%d.png',i);
%     saveas(gcf,filename);
    close all;
end
    