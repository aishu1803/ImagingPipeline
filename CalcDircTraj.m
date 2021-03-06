function [go_curves,nogo_curves,go_err_curves,nogo_err_curves,vel_nogo,vel_go,vel_nogo_err,vel_go_err] = CalcDircTraj(trajectories,trialNum,x,lp,np,np_nogo)
nogo_curves = [];
go_curves = [];
go_err_curves=[];
nogo_err_curves=[];
% Nogo
for i = 1:size(trajectories,5)
    
    x_nogo = smooth(squeeze(trajectories(1,:,1,1,i)),7);
    
    y_nogo = smooth(squeeze(trajectories(2,:,1,1,i)),7);
    
    z_nogo = smooth(squeeze(trajectories(3,:,1,1,i)),7);
    for j = 2:length(x_nogo)-1
        v1 = [x_nogo(j-1) y_nogo(j-1) z_nogo(j-1)];
        v2 = [x_nogo(j) y_nogo(j) z_nogo(j)];
        v3 = [x_nogo(j+1) y_nogo(j+1) z_nogo(j+1)];
        v21 = v2 - v1;
        v21 = v21/sqrt(v21(1)^2 + v21(2)^2 );
        v32 = v3 - v2;
        v32 = v32/sqrt(v32(1)^2 + v32(2)^2 );
        
%         t(j) = atan2d(norm(cross(v1-v2,v3-v2)), dot(v1-v2,v3-v2));
        vel_nogo(i,j) = sqrt((v3(1) - v1(1))^2+((v3(2) - v1(2))^2));
        t2_nogo(j) = dot(v21,v32);
    end
    %t = atan2d(diff(x_nogo),diff(y_nogo));
    
%     nogo_curves(i).timepoints = unique([ix;]);
%     nogo_curves(i).angles = dt;
    nogo_curves(i).dotpd = t2_nogo;
end
% Go
for i = 1:size(trajectories,5)
    x_go = smooth(squeeze(trajectories(1,:,2,1,i)),7);
    
    y_go = smooth(squeeze(trajectories(2,:,2,1,i)),7);
    
    z_go = smooth(squeeze(trajectories(3,:,2,1,i)),7);
    t(1) = nan;
    for j = 2:length(x_go)-1
        v1 = [x_go(j-1) y_go(j-1)];
        v2 = [x_go(j) y_go(j)];
        v3 = [x_go(j+1) y_go(j+1)];
        v21 = v2 - v1;
        v21 = v21/sqrt(v21(1)^2 + v21(2)^2);
        v32 = v3 - v2;
        v32 = v32/sqrt(v32(1)^2 + v32(2)^2);
%         t(j) = atan2d(norm(cross(v1-v2,v3-v2)), dot(v1-v2,v3-v2));
        vel_go(i,j) = sqrt((v3(1) - v1(1))^2+((v3(2) - v1(2))^2));
        t2_go(j) = dot(v21,v32);
    end
    %t = atan2d(diff(x_go),diff(y_go));
%     dt = 180-t;                % angle between lines
%     
%     ix_go = find(abs(dt)>x);
    % angle between lines
    
    
%     go_curves(i).timepoints = unique([ix_go;]);
%     go_curves(i).angles = dt;
    go_curves(i).dotpd = t2_go;
    
end
% Nogo error
for i = 1:trialNum(1,1,2)
    x_go = smooth(squeeze(trajectories(1,:,1,2,i)),7);
    
    y_go = smooth(squeeze(trajectories(2,:,1,2,i)),7);
    
    z_go = smooth(squeeze(trajectories(3,:,1,2,i)),7);
    t(1) = nan;
    for j = 2:length(x_go)-1
        v1 = [x_go(j-1) y_go(j-1) z_go(j-1)];
        v2 = [x_go(j) y_go(j) z_go(j)];
        v3 = [x_go(j+1) y_go(j+1) z_go(j+1)];
        v21 = v2 - v1;
        v21 = v21/sqrt(v21(1)^2 + v21(2)^2 + v21(3)^2);
        v32 = v3 - v2;
        v32 = v32/sqrt(v32(1)^2 + v32(2)^2 + v32(3)^2);
        t(j) = atan2d(norm(cross(v1-v2,v3-v2)), dot(v1-v2,v3-v2));
        vel_nogo_err(i,j) = sqrt((v3(1) - v1(1))^2+((v3(2) - v1(2))^2+(v3(3) - v1(3))^2));
        t2_nogo_err(j) = dot(v21,v32);
    end
    %t = atan2d(diff(x_go),diff(y_go));
    dt = 180-t;                % angle between lines
    
    ix_go = find(abs(dt)>x);
    % angle between lines
    
    
    nogo_err_curves(i).timepoints = unique([ix_go;]);
    nogo_err_curves(i).angles = dt;
    nogo_err_curves(i).dotpd = t2_nogo_err;
end
% Go error
for i = 1:trialNum(1,2,2)
    x_go = smooth(squeeze(trajectories(1,:,2,2,i)),7);
    
    y_go = smooth(squeeze(trajectories(2,:,2,2,i)),7);
    
    z_go = smooth(squeeze(trajectories(3,:,2,2,i)),7);
    t(1) = nan;
    for j = 2:length(x_go)-1
        v1 = [x_go(j-1) y_go(j-1) z_go(j-1)];
        v2 = [x_go(j) y_go(j) z_go(j)];
        v3 = [x_go(j+1) y_go(j+1) z_go(j+1)];
        v21 = v2 - v1;
        v21 = v21/sqrt(v21(1)^2 + v21(2)^2 + v21(3)^2);
        v32 = v3 - v2;
        v32 = v32/sqrt(v32(1)^2 + v32(2)^2 + v32(3)^2);
        t(j) = atan2d(norm(cross(v1-v2,v3-v2)), dot(v1-v2,v3-v2));
        vel_go_err(i,j) = sqrt((v3(1) - v1(1))^2+((v3(2) - v1(2))^2+(v3(3) - v1(3))^2));
        t2_go_err(j) = dot(v21,v32);
    end
    %t = atan2d(diff(x_go),diff(y_go));
    dt = 180-t;                % angle between lines
    
    ix_go = find(abs(dt)>x);
    % angle between lines
    
    
    go_err_curves(i).timepoints = unique([ix_go;]);
    go_err_curves(i).angles = dt;
    go_err_curves(i).dotpd = t2_go_err;
end

% Nogo trajectory post-process
for i = 1:length(nogo_curves)
    for dim = 1:3
        trajectories(dim,:,1,1,i) = smooth(trajectories(dim,:,1,1,i));
    end
    tmp = nogo_curves(i).dotpd;
    tmp_chdir = find(tmp<0.7);
     ind_tmp_chdir = dsearchn(tmp_chdir',np_nogo(i));
%     if (tmp_chdir(ind_tmp_chdir) - np_nogo(i)) <7 && (tmp_chdir(ind_tmp_chdir) - np_nogo(i)) > -3 
        nogo_curves(i).np_val = tmp(tmp_chdir(ind_tmp_chdir));
         nogo_curves(i).np = tmp_chdir(ind_tmp_chdir);
          nogo_curves(i).np_real = np_nogo(i);
%     else
%         nogo_curves(i).np_val = nan;
%         nogo_curves(i).np = nan;
%         nogo_curves(i).np_real = np_nogo(i);
%     end
    ind_tmp_chdir2 = dsearchn(tmp_chdir',37);
    if (tmp_chdir(ind_tmp_chdir2) - 37) <7 & (tmp_chdir(ind_tmp_chdir2) - 37) > 0
        nogo_curves(i).tone_val = tmp(tmp_chdir(ind_tmp_chdir2));
         nogo_curves(i).tone = tmp_chdir(ind_tmp_chdir2);
          nogo_curves(i).tone_real = 37;
    else
        nogo_curves(i).tone_val = nan;
        nogo_curves(i).tone = nan;
        nogo_curves(i).tone_real = 37;
    end
    tmp2 = diff(tmp_chdir);
    tmp_chdir2 = tmp_chdir(find(tmp2>5) + 1);
    nogo_curves(i).chdir = tmp_chdir;
    nogo_curves(i).chdir2 = tmp_chdir2;
    tmp5 = nogo_curves(i).chdir2;
    ind = find(tmp5>22 & tmp5 <55);
    [b,ind_max] = min(tmp5(ind));
    nogo_curves(i).chdirfinal = tmp5(ind(ind_max));
    [~,tmp_chdirfinal2] = min(abs(tmp(37:75)));
    nogo_curves(i).chdirfinal2 = tmp_chdirfinal2 + 36;
    if ~isempty(nogo_curves(i).chdirfinal)
        v1 = squeeze(trajectories(1:3,nogo_curves(i).chdirfinal+9,1,1,i));
        v2 = squeeze(trajectories(1:3,nogo_curves(i).chdirfinal+6,1,1,i));
        v4 = squeeze(trajectories(1:3,nogo_curves(i).chdirfinal-6,1,1,i));
        v3 = squeeze(trajectories(1:3,nogo_curves(i).chdirfinal-9,1,1,i));
        v2 = v2-v1;
        v3 = v3 - v4;
        nogo_curves(i).anatcurvepre = atan2d(v2(2),v2(1));
        
        nogo_curves(i).anatcurvexpost = atan2d(v3(2),v3(1));
        
        tmp_vel = squeeze(trajectories(:,:,1,1,i));
        tmp1_vel = dist(tmp_vel(:,[nogo_curves(i).chdirfinal-5 nogo_curves(i).chdirfinal-2]));
        nogo_curves(i).prevel = tmp1_vel(1,2)*1000/(66*4);
        tmp2_vel = dist(tmp_vel(:,[nogo_curves(i).chdirfinal+2 nogo_curves(i).chdirfinal+5]));
        nogo_curves(i).postvel = tmp2_vel(1,2)*1000/(66*4);
    end
end
% Go trajectory post-process
for i = 1:length(go_curves)
    for dim = 1:3
        trajectories(dim,:,2,1,i) = smooth(trajectories(dim,:,2,1,i));
    end
    tmp = go_curves(i).dotpd;
    tmp_chdir = find(tmp<0.7);
    ind_tmp_chdir = dsearchn(tmp_chdir',np(i));
%     if (tmp_chdir(ind_tmp_chdir) - np(i)) <7 && (tmp_chdir(ind_tmp_chdir) - np(i)) >-3 
        go_curves(i).np_val = tmp(tmp_chdir(ind_tmp_chdir));
        go_curves(i).np = tmp_chdir(ind_tmp_chdir);
        go_curves(i).np_real = np(i);
%     else
%        go_curves(i).np_val = nan;
%         go_curves(i).np = nan;
%         go_curves(i).np_real = np(i);
%     end
    ind_tmp_chdir_lp = dsearchn(tmp_chdir',lp(i));
%     if ((tmp_chdir(ind_tmp_chdir_lp) - lp(i)) <7) && ((tmp_chdir(ind_tmp_chdir_lp) - lp(i))>-3) 
        go_curves(i).lp_val = tmp(tmp_chdir(ind_tmp_chdir_lp));
        go_curves(i).lp = tmp_chdir(ind_tmp_chdir_lp);
        go_curves(i).lp_real = lp(i);
%     else
%        go_curves(i).lp_val = nan;
%         go_curves(i).lp = nan;
%         go_curves(i).lp_real = lp(i);
%     end
    ind_tmp_chdir2 = dsearchn(tmp_chdir',37);
    if (tmp_chdir(ind_tmp_chdir2) - 37) <10 && (tmp_chdir(ind_tmp_chdir2) - 37) >0
        go_curves(i).tone_val = tmp(tmp_chdir(ind_tmp_chdir2));
         go_curves(i).tone = tmp_chdir(ind_tmp_chdir2);
         go_curves(i).tone_real = 37;
    else
        go_curves(i).tone_val = nan;
        go_curves(i).tone = nan;
        go_curves(i).tone_real = 37;
    end
    tmp2 = diff(tmp_chdir);
    tmp_chdir2 = tmp_chdir(find(tmp2>5) + 1);
    go_curves(i).chdir = tmp_chdir;
    go_curves(i).chdir2 = tmp_chdir2;
    tmp5 = go_curves(i).chdir2;
    ind = find(tmp5>22 & tmp5 <55);
    [b,ind_max] = min(tmp5(ind));
    go_curves(i).chdirfinal = tmp5(ind(ind_max));
    [~,tmp_chdirfinal2] = min(abs(tmp(37:75)));
    go_curves(i).chdirfinal2 = tmp_chdirfinal2 + 36;
    if ~isempty(go_curves(i).chdirfinal)
        v1 = squeeze(trajectories(1:3,go_curves(i).chdirfinal+9,2,1,i));
        v2 = squeeze(trajectories(1:3,go_curves(i).chdirfinal+6,2,1,i));
        v4 = squeeze(trajectories(1:3,go_curves(i).chdirfinal-6,2,1,i));
        v3 = squeeze(trajectories(1:3,go_curves(i).chdirfinal-9,2,1,i));
        v2 = v2-v1;
        v3 = v3 - v4;
        go_curves(i).anatcurvepre = atan2d(v2(2),v2(1));
        
        go_curves(i).anatcurvepost = atan2d(v3(2),v3(1));
        
        tmp_vel = squeeze(trajectories(:,:,2,1,i));
        tmp1_vel = dist(tmp_vel(:,[go_curves(i).chdirfinal-5 go_curves(i).chdirfinal-2]));
        go_curves(i).prevel = tmp1_vel(1,2)*1000/(66*3);
        tmp2_vel = dist(tmp_vel(:,[go_curves(i).chdirfinal+2 go_curves(i).chdirfinal+5]));
        go_curves(i).postvel = tmp2_vel(1,2)*1000/(66*3);
    end
end
% Go error trajectory post-process
for i = 1:length(go_err_curves)
    for dim = 1:3
        trajectories(dim,:,2,2,i) = smooth(trajectories(dim,:,2,2,i));
    end
    tmp = go_err_curves(i).dotpd;
    tmp_chdir = find(tmp<0.7);
    ind_tmp_chdir2 = dsearchn(tmp_chdir',37);
    if (tmp_chdir(ind_tmp_chdir2) - 37) <7 & (tmp_chdir(ind_tmp_chdir2) - 37) >-3
        go_err_curves(i).tone_val = tmp(tmp_chdir(ind_tmp_chdir2));
         go_err_curves(i).tone = tmp_chdir(ind_tmp_chdir2);
          go_err_curves(i).tone_real = 37;
    else
        go_err_curves(i).tone_val = nan;
        go_err_curves(i).tone = nan;
        go_err_curves(i).tone_real = 37;
    end
    tmp2 = diff(tmp_chdir);
    tmp_chdir2 = tmp_chdir(find(tmp2>5) + 1);
    go_err_curves(i).chdir = tmp_chdir;
    go_err_curves(i).chdir2 = tmp_chdir2;
    tmp5 = go_err_curves(i).chdir2;
    ind = find(tmp5>22 & tmp5 <55);
    [b,ind_max] = min(tmp5(ind));
    go_err_curves(i).chdirfinal = tmp5(ind(ind_max));
    [~,tmp_chdirfinal2] = min(abs(tmp(30:55)));
    go_err_curves(i).chdirfinal2 = tmp_chdirfinal2 + 29;
    if ~isempty(go_err_curves(i).chdirfinal)
        v1 = squeeze(trajectories(1:3,go_err_curves(i).chdirfinal+9,2,2,i));
        v2 = squeeze(trajectories(1:3,go_err_curves(i).chdirfinal+6,2,2,i));
        v4 = squeeze(trajectories(1:3,go_err_curves(i).chdirfinal-6,2,2,i));
        v3 = squeeze(trajectories(1:3,go_err_curves(i).chdirfinal-9,2,2,i));
        v2 = v2-v1;
        v3 = v3 - v4;
        go_err_curves(i).anatcurvepre = atan2d(v2(2),v2(1));
        
        go_err_curves(i).anatcurvepost = atan2d(v3(2),v3(1));
        
        tmp_vel = squeeze(trajectories(:,:,2,2,i));
        tmp1_vel = dist(tmp_vel(:,[go_err_curves(i).chdirfinal-5 go_err_curves(i).chdirfinal-2]));
        go_err_curves(i).prevel = tmp1_vel(1,2)*1000/(66*3);
        tmp2_vel = dist(tmp_vel(:,[go_err_curves(i).chdirfinal+2 go_err_curves(i).chdirfinal+5]));
        go_err_curves(i).postvel = tmp2_vel(1,2)*1000/(66*3);
    end
end
% Nogo error trajectory post-process
for i = 1:length(nogo_err_curves)
    for dim = 1:3
        trajectories(dim,:,1,2,i) = smooth(trajectories(dim,:,1,2,i));
    end
    tmp = nogo_err_curves(i).dotpd;
    tmp_chdir = find(tmp<0.7);
    ind_tmp_chdir2 = dsearchn(tmp_chdir',37);
    if (tmp_chdir(ind_tmp_chdir2) - 37) <7 & (tmp_chdir(ind_tmp_chdir2) - 37) >-3
        nogo_err_curves(i).tone_val = tmp(tmp_chdir(ind_tmp_chdir2));
         nogo_err_curves(i).tone = tmp_chdir(ind_tmp_chdir2);
          nogo_err_curves(i).tone_real = 37;
    else
        nogo_err_curves(i).tone_val = nan;
        nogo_err_curves(i).tone = nan;
        nogo_err_curves(i).tone_real = 37;
    end
    tmp2 = diff(tmp_chdir);
    tmp_chdir2 = tmp_chdir(find(tmp2>5) + 1);
    nogo_err_curves(i).chdir = tmp_chdir;
    nogo_err_curves(i).chdir2 = tmp_chdir2;
    tmp5 = nogo_err_curves(i).chdir2;
    ind = find(tmp5>22 & tmp5 <55);
    [b,ind_max] = min(tmp5(ind));
    nogo_err_curves(i).chdirfinal = tmp5(ind(ind_max));
    [~,tmp_chdirfinal2] = min(abs(tmp(30:55)));
    nogo_err_curves(i).chdirfinal2 = tmp_chdirfinal2 + 29;
    if ~isempty(nogo_err_curves(i).chdirfinal)
        v1 = squeeze(trajectories(1:3,nogo_err_curves(i).chdirfinal+9,1,2,i));
        v2 = squeeze(trajectories(1:3,nogo_err_curves(i).chdirfinal+6,1,2,i));
        v4 = squeeze(trajectories(1:3,nogo_err_curves(i).chdirfinal-6,1,2,i));
        v3 = squeeze(trajectories(1:3,nogo_err_curves(i).chdirfinal-9,1,2,i));
        v2 = v2-v1;
        v3 = v3 - v4;
        nogo_err_curves(i).anatcurvepre = atan2d(v2(2),v2(1));
        
        nogo_err_curves(i).anatcurvepost = atan2d(v3(2),v3(1));
        
        tmp_vel = squeeze(trajectories(:,:,1,2,i));
        tmp1_vel = dist(tmp_vel(:,[nogo_err_curves(i).chdirfinal-5 nogo_err_curves(i).chdirfinal-2]));
        nogo_err_curves(i).prevel = tmp1_vel(1,2)*1000/(66*3);
        tmp2_vel = dist(tmp_vel(:,[nogo_err_curves(i).chdirfinal+2 nogo_err_curves(i).chdirfinal+5]));
        nogo_err_curves(i).postvel = tmp2_vel(1,2)*1000/(66*3);
    end
end
end