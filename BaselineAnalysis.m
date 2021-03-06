function p = BaselineAnalysis(trials)
prev_wrong=[];prev_correct = []; go = [];nogo=[];
for i = 1:length(trials)
    if trials(i).prevcorrect==1  & trials(i).reward
        prev_correct = [prev_correct i];
    elseif trials(i).prevcorrect==0  &trials(i).reward
        prev_wrong = [prev_wrong i];
    end
end
for i = 1:length(trials)
    if trials(i).nogo==1  & trials(i).reward
        nogo=[nogo i];
    elseif trials(i).nogo==0  &trials(i).reward
        go = [go i];
    end
end
mkdir('PrevTrialEffect')
n_cells = size(trials(1).C_raw,1);
for i = 1:n_cells
    tmp_c=[]; tmp_w = []; tmp_go=[];tmp_nogo=[];
    for j = prev_correct
        tmp_c = [tmp_c;trials(j).C_raw(i,trials(j).nosepokeframe-15:trials(j).nosepokeframe+25)];
    end
    for k = prev_wrong
        tmp_w = [tmp_w;trials(k).C_raw(i,trials(k).nosepokeframe-15:trials(k).nosepokeframe+25)];
    end
    for j = nogo
        tmp_nogo = [tmp_nogo;trials(j).C_raw(i,trials(j).nosepokeframe-15:trials(j).nosepokeframe+25)];
    end
    for k = go
        tmp_go =[tmp_go;trials(k).C_raw(i,trials(k).nosepokeframe-15:trials(k).nosepokeframe+25)];
    end
    [~,p(i)] = ttest2(mean(tmp_go,2),mean(tmp_nogo,2));
    tmp = [tmp_c;tmp_w];
    for z = 1:1000
        if length(prev_wrong)<length(prev_correct)
            tmp_ss(z,:) = mean(tmp_c(randsample(size(tmp_c,1),size(tmp_w,1)),:));
            tmp_shuf(z,:) = mean(tmp(randsample(size(tmp,1),size(tmp_w,1)),:));
        else
            tmp_ss(z,:) = mean(tmp_w(randsample(size(tmp_w,1),size(tmp_c,1)),:));
            tmp_shuf(z,:) = mean(tmp(randsample(size(tmp,1),size(tmp_c,1)),:));
        end
    end
    figure
    
    if length(prev_wrong)<length(prev_correct)
        subplot(1,2,2)
        plot([-15:25]*0.03,mean(tmp_w),'-b')
        hold on
        plot([-15:25]*0.03,mean(tmp_ss),'color',[0 0 0.4])
        legend('Wrong','Correct')
       xdata = [-15:1:25 25:-1:-15]*0.03;
       ydata = [prctile(tmp_ss,97.5) fliplr(prctile(tmp_ss,2.5))];
       ydata_shuf = [prctile(tmp_shuf,97.5) fliplr(prctile(tmp_shuf,2.5))];
       patch(xdata,ydata,'b','FaceAlpha','0.2','EdgeColor','none');
%        patch(xdata,ydata_shuf,'k','FaceAlpha','0.2','EdgeColor','none');
       line([0 0],ylim,'color','k','LineStyle',':')
        set(gca,'Box','off');
       xlabel('Time from nosepoke (s)')
       title({'Previous correct Vs wrong','error bars are 97.5/2,5th percentile'})
    else
        subplot(1,2,2)
         plot(-15:25,mean(tmp_c),'-','color',[0 0 0.4])
        hold on
        plot(-15:25,mean(tmp_ss),'-b')
        legend('Previous Trial Correct','Previous Trial Wrong')
       xdata = [-15:1:25 25:-1:-15]*0.03;
       ydata = [prctile(tmp_ss,97.5) fliplr(prctile(tmp_ss,2.5))];
       ydata_shuf = [prctile(tmp_shuf,97.5) fliplr(prctile(tmp_shuf,2.5))];
       patch(xdata,ydata,'b','FaceAlpha','0.2','EdgeColor','none');
%        patch(xdata,ydata_shuf,'k','FaceAlpha','0.2','EdgeColor','none');
       line([0 0],ylim,'color','k','LineStyle',':')
       set(gca,'Box','off');
       xlabel('Time from nosepoke')
      
    end
    subplot(1,2,1)
    plot([-15:25]*0.03,mean(tmp_go),'-g')
    hold on
    plot([-15:25]*0.03,mean(tmp_nogo),'-r')
    legend('go','no-go')
    y_datago = [mean(tmp_go)+(std(tmp_go)/sqrt(length(go))) fliplr(mean(tmp_go)-(std(tmp_go)/sqrt(length(go))))];
    y_datanogo = [mean(tmp_nogo)+(std(tmp_nogo)/sqrt(length(nogo))) fliplr(mean(tmp_nogo)-(std(tmp_nogo)/sqrt(length(nogo))))];
    patch(xdata,y_datago,'g','FaceAlpha','0.2','EdgeColor','none')
    patch(xdata,y_datanogo,'r','FaceAlpha','0.2','EdgeColor','none')
    line([0 0],ylim,'color','k','LineStyle',':')
    xlabel('Time from nosepoke (s)')
    title({'Go Vs No-go','error bars are sem'})
    filename = sprintf('PrevTrialEffect\\%d.png',i);
    saveas(gcf,filename);
    close all;
end
        
       
       
        
    
    
