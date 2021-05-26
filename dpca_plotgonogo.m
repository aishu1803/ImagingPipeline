function dpca_plotgonogo(Trajs,cMap1,cMap2)
figure
for i = 1:10
tmp = squeeze(Trajs(1:3,:,1,1,i));
tmp1 = smooth(tmp(1,:),7);
tmp2 = smooth(tmp(2,:),7);
tmp3 = smooth(tmp(3,:),7);
fd = plot3(tmp1,tmp2,tmp3,'LineWidth',2);
hold on
cd = [uint8(cMap1*255) uint8(ones(size(Trajs,2),1))].';
drawnow
set(fd.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
end
for i = 1:10
tmp = squeeze(Trajs(1:3,:,2,1,i));
tmp1 = smooth(tmp(1,:),7);
tmp2 = smooth(tmp(2,:),7);
tmp3 = smooth(tmp(3,:),7);
fd = plot3(tmp1,tmp2,tmp3,'LineWidth',2);
hold on
cd = [uint8(cMap2*255) uint8(ones(size(Trajs,2),1))].';
drawnow
set(fd.Edge, 'ColorBinding','interpolated', 'ColorData',cd);
end