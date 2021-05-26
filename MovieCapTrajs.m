function MovieCapTrajs(Trajs,cMap1,cMap2,nogo_curves,dist)
Trajs = Trajs(:,:,:,:,1:20);
for i = 1:10
    Trajs(1,:,1,1,i) = smooth(Trajs(1,:,1,1,i));
    Trajs(2,:,1,1,i) = smooth(Trajs(2,:,1,1,i));
    Trajs(3,:,1,1,i) = smooth(Trajs(3,:,1,1,i));
    Trajs(1,:,2,1,i) = smooth(Trajs(1,:,2,1,i));
    Trajs(2,:,2,1,i) = smooth(Trajs(2,:,2,1,i));
    Trajs(3,:,2,1,i) = smooth(Trajs(3,:,2,1,i));
    
end
tmp_dist_ct = squeeze(mean(dist.hit_hit,3));
tmp_dist = squeeze(mean(dist.hit_cr(:,1,:),3));
pr_dist_25 = prctile(tmp_dist_ct,5,2)';
pr_dist_95 = prctile(tmp_dist_ct,95,2)';
v = VideoWriter('Trajs_ex_dist');
v.FrameRate = 4;
open(v)
co = 1;
for i = 1:89
    figure
    if i<30
        str = sprintf('Baseline');
    elseif i>29 && i<37
        str = sprintf('Nosepoke hold');
    elseif i>36 && i<39
        str = sprintf('Tone On');
    elseif i >= 89 && i<=90
        str = sprintf('Nosepoke exit for Nogo');
    elseif i >= 81 && i<=84
        str = sprintf('Tone off');
    else
        str = [];
    end
    j = 1;
    subplot(1,2,1)
        plot3(squeeze(Trajs(1,1:i,1,1,j)),squeeze(Trajs(2,1:i,1,1,j)),squeeze(Trajs(1,1:i,1,1,j)),'-r','LineWidth',2);
        hold on
        for k = 1:20
            plot3(squeeze(Trajs(1,1:i,2,1,k)),squeeze(Trajs(2,1:i,2,1,k)),squeeze(Trajs(1,1:i,2,1,k)),'-b','LineWidth',0.5);
        end
   
    xlabel('dPC1'),ylabel('dPC2'),zlabel('dPC3')
    xlim([-10 4]),ylim([-6 4]),zlim([-10 3]);
    set(gca,'Box','On','XGrid','On','yGrid','On','ZGrid','On')
    set(gcf,'Color','w')
    title(str)
    
    set(gca,'FontSize',20)
        subplot(1,2,2)
        
        x_patch = [1:90 90:-1:1];
        y_patch = [pr_dist_25 fliplr(pr_dist_95)];
        patch(x_patch,y_patch,'b','FaceAlpha',0.2);
        hold on
        
        plot(tmp_dist(1:i),'-r','LineWidth',2);
        xlim([1 90]),ylim([0 14]),xlabel('Time since nosepoke entry'),ylabel('Curvature value')
        line([30 30],ylim,'LineStyle',':','LineWidth',1,'Color','k');
        set(gca,'FontSize',20)
        set(gca,'XTick',[15 30 45 60 75 90],'XTickLabel',{'-1','0','1','2','3','4'});
    F(co) = getframe(gcf);
    writeVideo(v,F(co));
    close all
    co = co+1;
end
close(v)