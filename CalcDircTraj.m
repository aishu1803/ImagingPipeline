function [go_curves,nogo_curves] = CalcDircTraj(trajectories)
nogo_curves = [];
go_curves = [];
for i = 1:size(trajectories,5)
    
    x_nogo = smooth(squeeze(trajectories(1,:,1,1,i)));
    
    y_nogo = smooth(squeeze(trajectories(2,:,1,1,i)));
    
    z_nogo = smooth(squeeze(trajectories(3,:,1,1,i)));
   
        t = atan2d(diff(x_nogo),diff(z_nogo));
       
    dt = wrapTo180(diff(t));                % angle between lines
    
    ix = find(abs(dt)>30);
    nogo_curves(i).timepoints = ix;
    nogo_curves(i).angles = dt;
end
for i = 1:size(trajectories,5)
    x_go = smooth(squeeze(trajectories(1,:,2,1,i)));
    
    y_go = smooth(squeeze(trajectories(2,:,2,1,i)));
    
    z_go = smooth(squeeze(trajectories(3,:,2,1,i)));
    
    t = atan2d(diff(x_go),diff(z_go));
    dt = wrapTo180(diff(t));                % angle between lines
    
    ix_go = find(abs(dt)>30);
    go_curves(i).timepoints = ix_go;
    go_curves(i).angles = dt;
end
end