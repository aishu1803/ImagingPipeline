function LeastSquares(K,firingRates,trials,trialNum)
[task_Event] =  BuildEventMatrix(trials);
X = [task_Event.val;];
for i = 1:size(K,1)
    tmp_K = squeeze(mean(K(i,:,:),2));
    tmp_K = [tmp_K(1) ;smooth(tmp_K(2:end))];
    tmp_cell = squeeze(firingRates(i,2,1,:,1:trialNum(1,2,1)));
    tmp_cell = [tmp_cell squeeze(firingRates(i,1,1,:,1:trialNum(1,1,1)))];
    y_hat = myFun(tmp_K',X);
    cell1=[];
    for i_train = 1:size(tmp_cell,2)
        cell1 = [cell1;tmp_cell(:,i_train)];
        
    end
    figure
    subplot(2,1,1)
    plot(y_hat,'LineWidth',2)
    hold on
    plot(cell1,'LineWidth',2)
    subplot(2,1,2)
    plot(tmp_K(2:91),'LineWidth',2)
    hold on
    plot(tmp_K(92:181),'LineWidth',2)
    plot(tmp_K(182:271),'LineWidth',2)
    plot(tmp_K(272:361),'LineWidth',2)
    plot(tmp_K(362:451),'LineWidth',2)
    legend('npentry','tone_go_on','tone_nogo_on','reward','lp')
end