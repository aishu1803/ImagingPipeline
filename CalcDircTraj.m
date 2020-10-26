function angl = CalcDircTraj(trajectories)
hdgidx = [];
for i = 1:size(trajectories,5)
    x_go = squeeze(trajectories(1,:,2,1,i));
    x_nogo = squeeze(trajectories(1,:,1,1,i));
    y_go = squeeze(trajectories(2,:,2,1,i));
    y_nogo = squeeze(trajectories(2,:,1,1,i));
    dx = gradient(smooth(x_nogo), 0.1);
    dy = gradient(smooth(y_nogo), 0.1);
    hdc = pi/2;                             % Critical Heading Change
    hdg = atan2(dy,dx);                     % Heading
    sec = 2;                                % ‘Look Ahead’ Time (sec)
    dhdg = filter([1 zeros(1,sec*15-2) 1], 2, hdg);
    hdgidx = [hdgidx; find(abs(dhdg) >= hdc)];
    [L,R,k] = curvature([x_nogo' y_nogo']);
end
end