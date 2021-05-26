function [corr_nogo_tcorr,corr_go_tcorr,err_nogo_tcorr,err_go_tcorr] =  TemporalSimilarity(trials)
[dpca_data,firingRates,firingRatesAverage,trialNum,ind_ee] = DataPreProcess(trials,0,1);
combinedParams = {{1, [1 3]}, {2, [2 3]}, {3}, {[1 2], [1 2 3]}};
margNames = {'Stimulus', 'Decision', 'Condition-independent', 'S/D Interaction'};
margColours = [23 100 171; 187 20 25; 150 150 150; 114 97 171]/256;
time = [];
timeEvents = [];
ifSimultaneousRecording = true;
optimalLambda = dpca_optimizeLambda(firingRatesAverage, firingRates, trialNum, ...
    'combinedParams', combinedParams, ...
    'simultaneous', ifSimultaneousRecording, ...
    'numRep', 10, ...  % increase this number to ~10 for better accuracy
    'filename', 'tmp_optimalLambdas.mat');

Cnoise = dpca_getNoiseCovariance(firingRatesAverage, ...
    firingRates, trialNum, 'simultaneous', ifSimultaneousRecording);

[W,V,whichMarg] = dpca(firingRatesAverage, 10, ...
    'combinedParams', combinedParams, ...
    'lambda', optimalLambda, ...
    'Cnoise', Cnoise);

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams);
[firingRates_taskonly,Trajs_taskonly,firingRates_timeonly,Trajs_timeonly] = ReconstructTrajs(firingRates,V,W,trialNum,whichMarg);
corr_nogo = squeeze(firingRates_taskonly(:,1,1,:,:));
corr_go = squeeze(firingRates_taskonly(:,2,1,:,:));
err_nogo = squeeze(firingRates_taskonly(:,1,2,:,1:trialNum(1,1,2)));
err_go = squeeze(firingRates_taskonly(:,2,2,:,1:trialNum(1,2,2)));
tt_nogo = trialNum(1,1,2);
tt_go = trialNum(1,2,2);
for m = 1:100
    tt = randsample(1:size(corr_nogo,3),tt_nogo);
    for i = 1:size(corr_nogo,2)
        for j = 1:size(corr_nogo,2)
            for v = 1:tt_nogo
                rr = dot(corr_nogo(:,i,tt(v)),corr_nogo(:,j,tt(v)));
                tmp_rr(i,j,v) = rr;
            end
        end
    end
    corr_nogo_tcorr(:,:,m) = squeeze(mean(tmp_rr,3));
end
for m = 1:100
    tt = randsample(1:size(corr_go,3),tt_go);
    for i = 1:size(corr_go,2)
        for j = 1:size(corr_go,2)
            for v = 1:tt_go
                rr = dot(corr_go(:,i,tt(v)),corr_go(:,j,tt(v)));
                tmp_rr(i,j,v) = rr;
            end
        end
    end
    corr_go_tcorr(:,:,m) = squeeze(mean(tmp_rr,3));
end
for i = 1:size(err_go,2)
    for j = 1:size(err_go,2)
        for v = 1:tt_go
            rr = dot(err_go(:,i,v),err_go(:,j,v));
            err_go_tcorr(i,j,v) = rr;
        end
    end
end
for i = 1:size(err_nogo,2)
    for j = 1:size(err_nogo,2)
        for v = 1:tt_nogo
            rr = dot(err_nogo(:,i,v),err_nogo(:,j,v));
            err_nogo_tcorr(i,j,v) = rr;
        end
    end
end
figure
subplot(2,2,1)

cMap = getPyPlot_cMap('rainbow',[],[],'C:\Users\Parthasarathy\AppData\Local\Programs\Python\Python39\python.exe');
imagesc(squeeze(mean(corr_nogo_tcorr(1:37,1:37,:),3)))
colormap(cMap)
set(gca,'XTick',[14 22 30],'Ytick',[14 22 30],'XTickLabel',{'0','0.5','1'},'YTickLabel',{'0','0.5','1'})
line([15 15],ylim,'color','w','LineStyle',':','LineWidth',2)
line(xlim,[15 15],'color','w','LineStyle',':','LineWidth',2)
subplot(2,2,2)
imagesc(squeeze(mean(corr_go_tcorr(1:37,1:37,:),3)))
colormap(cMap)
set(gca,'XTick',[14 22 30],'Ytick',[14 22 30],'XTickLabel',{'0','0.5','1'},'YTickLabel',{'0','0.5','1'})
line([15 15],ylim,'color','w','LineStyle',':','LineWidth',2)
line(xlim,[15 15],'color','w','LineStyle',':','LineWidth',2)
subplot(2,2,3)
imagesc(squeeze(mean(err_nogo_tcorr(1:37,1:37,:),3)))
colormap(cMap)
set(gca,'XTick',[14 22 30],'Ytick',[14 22 30],'XTickLabel',{'0','0.5','1'},'YTickLabel',{'0','0.5','1'})
line([15 15],ylim,'color','w','LineStyle',':','LineWidth',2)
line(xlim,[15 15],'color','w','LineStyle',':','LineWidth',2)
subplot(2,2,4)
imagesc(squeeze(mean(err_go_tcorr(1:37,1:37,:),3)))
colormap(cMap)
set(gca,'XTick',[14 22 30],'Ytick',[14 22 30],'XTickLabel',{'0','0.5','1'},'YTickLabel',{'0','0.5','1'})
line([15 15],ylim,'color','w','LineStyle',':','LineWidth',2)
line(xlim,[15 15],'color','w','LineStyle',':','LineWidth',2)
end
