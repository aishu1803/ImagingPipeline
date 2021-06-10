function Plot_DPCA_OldGoNogo(Trajs,trialNum)
nogo_corr = squeeze(Trajs(1:3,:,1,1,:));
nogo_err = squeeze(Trajs(1:3,:,1,2,1:trialNum(1,1,2)));
go_corr = squeeze(Trajs(1:3,:,2,1,:));
go_err = squeeze(Trajs(1:3,:,2,2,1:trialNum(1,2,2)));
figure
subplot('Position',[0.03 0.11 0.16 0.815])
scatter3(squeeze(mean(nogo_corr(1,1:7,:),2)),squeeze(mean(nogo_corr(2,1:7,:),2)),squeeze(mean(nogo_corr(3,1:7,:),2)),144,'MarkerFaceColor','r','MarkerEdgeColor','r')
hold on
scatter3(squeeze(mean(go_corr(1,1:7,:),2)),squeeze(mean(go_corr(2,1:7,:),2)),squeeze(mean(go_corr(3,1:7,:),2)),144,'MarkerFaceColor','b','MarkerEdgeColor','b')
scatter3(squeeze(mean(nogo_err(1,1:7,:),2)),squeeze(mean(nogo_err(2,1:7,:),2)),squeeze(mean(nogo_err(3,1:7,:),2)),144,'MarkerFaceColor',[1 0.6824 0.25],'MarkerEdgeColor',[1 0.6824 0.25])
scatter3(squeeze(mean(go_err(1,1:7,:),2)),squeeze(mean(go_err(2,1:7,:),2)),squeeze(mean(go_err(3,1:7,:),2)),144,'MarkerFaceColor',[0.6 0.2 0.5],'MarkerEdgeColor',[0.6 0.2 0.5])
subplot('Position',[0.225 0.11 0.16 0.815])
scatter3(squeeze(mean(nogo_corr(1,8:15,:),2)),squeeze(mean(nogo_corr(2,8:15,:),2)),squeeze(mean(nogo_corr(3,8:15,:),2)),144,'MarkerFaceColor','r','MarkerEdgeColor','r')
hold on
scatter3(squeeze(mean(go_corr(1,8:15,:),2)),squeeze(mean(go_corr(2,8:15,:),2)),squeeze(mean(go_corr(3,8:15,:),2)),144,'MarkerFaceColor','b','MarkerEdgeColor','b')
scatter3(squeeze(mean(nogo_err(1,8:15,:),2)),squeeze(mean(nogo_err(2,8:15,:),2)),squeeze(mean(nogo_err(3,8:15,:),2)),144,'MarkerFaceColor',[1 0.6824 0.25],'MarkerEdgeColor',[1 0.6824 0.25])
scatter3(squeeze(mean(go_err(1,8:15,:),2)),squeeze(mean(go_err(2,8:15,:),2)),squeeze(mean(go_err(3,8:15,:),2)),144,'MarkerFaceColor',[0.6 0.2 0.5],'MarkerEdgeColor',[0.6 0.2 0.5])
subplot('Position',[0.425 0.11 0.16 0.815])
scatter3(squeeze(mean(nogo_corr(1,16:22,:),2)),squeeze(mean(nogo_corr(2,16:22,:),2)),squeeze(mean(nogo_corr(3,16:22,:),2)),144,'MarkerFaceColor','r','MarkerEdgeColor','r')
hold on
scatter3(squeeze(mean(go_corr(1,16:22,:),2)),squeeze(mean(go_corr(2,16:22,:),2)),squeeze(mean(go_corr(3,16:22,:),2)),144,'MarkerFaceColor','b','MarkerEdgeColor','b')
scatter3(squeeze(mean(nogo_err(1,16:22,:),2)),squeeze(mean(nogo_err(2,16:22,:),2)),squeeze(mean(nogo_err(3,16:22,:),2)),144,'MarkerFaceColor',[1 0.6824 0.25],'MarkerEdgeColor',[1 0.6824 0.25])
scatter3(squeeze(mean(go_err(1,16:22,:),2)),squeeze(mean(go_err(2,16:22,:),2)),squeeze(mean(go_err(3,16:22,:),2)),144,'MarkerFaceColor',[0.6 0.2 0.5],'MarkerEdgeColor',[0.6 0.2 0.5])
subplot('Position',[0.625 0.11 0.16 0.815])
scatter3(squeeze(mean(nogo_corr(1,23:30,:),2)),squeeze(mean(nogo_corr(2,23:30,:),2)),squeeze(mean(nogo_corr(3,23:30,:),2)),144,'MarkerFaceColor','r','MarkerEdgeColor','r')
hold on
scatter3(squeeze(mean(go_corr(1,23:30,:),2)),squeeze(mean(go_corr(2,23:30,:),2)),squeeze(mean(go_corr(3,23:30,:),2)),144,'MarkerFaceColor','b','MarkerEdgeColor','b')
scatter3(squeeze(mean(nogo_err(1,23:30,:),2)),squeeze(mean(nogo_err(2,23:30,:),2)),squeeze(mean(nogo_err(3,23:30,:),2)),144,'MarkerFaceColor',[1 0.6824 0.25],'MarkerEdgeColor',[1 0.6824 0.25])
scatter3(squeeze(mean(go_err(1,23:30,:),2)),squeeze(mean(go_err(2,23:30,:),2)),squeeze(mean(go_err(3,23:30,:),2)),144,'MarkerFaceColor',[0.6 0.2 0.5],'MarkerEdgeColor',[0.6 0.2 0.5])
subplot('Position',[0.825 0.11 0.16 0.815])
scatter3(squeeze(mean(nogo_corr(1,30:37,:),2)),squeeze(mean(nogo_corr(2,30:37,:),2)),squeeze(mean(nogo_corr(3,23:30,:),2)),144,'MarkerFaceColor','r','MarkerEdgeColor','r')
hold on
scatter3(squeeze(mean(go_corr(1,30:37,:),2)),squeeze(mean(go_corr(2,30:37,:),2)),squeeze(mean(go_corr(3,30:37,:),2)),144,'MarkerFaceColor','b','MarkerEdgeColor','b')
scatter3(squeeze(mean(nogo_err(1,30:37,:),2)),squeeze(mean(nogo_err(2,30:37,:),2)),squeeze(mean(nogo_err(3,30:37,:),2)),144,'MarkerFaceColor',[1 0.6824 0.25],'MarkerEdgeColor',[1 0.6824 0.25])
scatter3(squeeze(mean(go_err(1,30:37,:),2)),squeeze(mean(go_err(2,30:37,:),2)),squeeze(mean(go_err(3,30:37,:),2)),144,'MarkerFaceColor',[0.6 0.2 0.5],'MarkerEdgeColor',[0.6 0.2 0.5])