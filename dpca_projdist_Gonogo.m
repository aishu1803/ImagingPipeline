function [dist,first_t_hitcr,first_t_crhit] = dpca_projdist_Gonogo(Trajs,trialNum)
rng('Shuffle')
hit_SS = squeeze(Trajs(:,:,2,1,:));
miss_SS = squeeze(Trajs(:,:,2,2,1:trialNum(1,2,2)));
cr_SS = squeeze(Trajs(:,:,1,1,:));
fa_SS = squeeze(Trajs(:,:,1,2,1:trialNum(1,1,2)));
n_hit = size(hit_SS,3);
n_miss = size(miss_SS,3);
n_cr = size(cr_SS,3);
n_fa = size(fa_SS,3);
n_trials = round(0.5*size(hit_SS,3));

for k = 1:1000
    n_hit_sub = randsample(n_hit,n_trials);
    n_cr_sub = randsample(n_cr,n_trials);
    hit_SS_m = squeeze(mean(hit_SS(:,:,n_hit_sub),3));
    
    cr_SS_m = squeeze(mean(cr_SS(:,:,n_cr_sub),3));
    
    for i = 1:size(Trajs,2)
        for j = 1:n_hit
            %miss_hit_dist(i,j) = sqrt(sum((hit_SS_m - miss_SS_sub(:,j)) .^ 2));
            hit_hit_dist(i,j,k) = sqrt(sum((hit_SS_m(:,i) - hit_SS(:,i,j)) .^ 2));
            cr_cr_dist(i,j,k) = sqrt(sum((cr_SS_m(:,i) - cr_SS(:,i,j)) .^ 2));
            cr_hit_dist(i,j,k) = sqrt(sum((cr_SS_m(:,i) - hit_SS(:,i,j)) .^ 2));
            hit_cr_dist(i,j,k) = sqrt(sum((hit_SS_m(:,i) - cr_SS(:,i,j)) .^ 2));
            %fa_cr_dist(i,j) = sqrt(sum((cr_SS_m - fa_SS_sub(:,j)) .^ 2));
        end
    end
    
end
dist.cr_hit = cr_hit_dist;
dist.hit_hit = hit_hit_dist;
dist.cr_cr = cr_cr_dist;
dist.hit_cr = hit_cr_dist;
ans = squeeze(mean(dist.hit_hit,3));
ans2 = squeeze(mean(dist.hit_cr,3));
pr25 = prctile(ans,5,2)';
pr975 = prctile(ans,95,2)';
y_patch = [pr25 fliplr(pr975)];
x_patch = [1:90 90:-1:1];
figure
patch(x_patch,y_patch,'k','FaceAlpha',0.1)
for i = 1:size(ans2,2)
    hold on
    plot(ans2(:,i),'-r','LineWidth',2);
    ind_exceed = [];
    for j = 1:90
        if ans2(j,i) > pr975(j)
            ind_exceed = [ind_exceed j];
        end
        
        N = 5; % Required number of consecutive numbers following a first one
        x = diff(ind_exceed)==1;
        f = find([false,x]~=[x,false]);
        g = find(f(2:2:end)-f(1:2:end-1)>=N,1,'first');
        if ~isempty(g)
            first_t_hitcr(i) = ind_exceed(f(2*g-1));
        else
            first_t_hitcr(i) = nan;
        end
    end
end
line([30 30],ylim,'Color','k','LineWidth',1)
line([37 37],ylim,'Color','k','LineWidth',1,'LineStyle','--')
set(gca,'FontSize',20);
xlabel('Time since nosepoke entry (s)')
ylabel('Distance (a.u.)')
set(gca,'XTick',[30 45 60 75 90],'XTickLabel',{'0','1','2','3','4'});
ans = squeeze(mean(dist.cr_cr,3));
pr25 = prctile(ans,5,2)';
pr975 = prctile(ans,95,2)';
y_patch = [pr25 fliplr(pr975)];
ans2 = squeeze(mean(dist.cr_hit,3));
figure
patch(x_patch,y_patch,'k','FaceAlpha',0.1)
hold on
for i = 1:1:size(ans2,2)
    plot(ans2(:,i),'-b','LineWidth',2);
    ind_exceed = [];
    for j = 1:90
        if ans2(j,i) > pr975(j)
            ind_exceed = [ind_exceed j];
        end
    N = 8; % Required number of consecutive numbers following a first one
    x = diff(ind_exceed)==1;
    f = find([false,x]~=[x,false]);
    g = find(f(2:2:end)-f(1:2:end-1)>=N,1,'first');
    if ~isempty(g)
        first_t_crhit(i) = ind_exceed(f(2*g-1));
    else
        first_t_crhit(i) = nan;
    end
    end
end
line([30 30],ylim,'Color','k','LineWidth',1)
line([37 37],ylim,'Color','k','LineWidth',1,'LineStyle','--')
set(gca,'XTick',[30 45 60 75 90],'XTickLabel',{'0','1','2','3','4'});
set(gca,'FontSize',20);
xlabel('Time since nosepoke entry (s)')
ylabel('Distance (a.u.)')
end
