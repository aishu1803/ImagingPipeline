function [dir,peak] =  trajdir2(seq,le)
for i = 1:length(seq)
    dy = diff(seq(i).xorth(2,:))./diff(seq(i).xorth(1,:));
    [b,ind] = max(abs(dy));
    for j = 3+le(1):le(2)
        x = seq(i).xorth(1,j) - seq(i).xorth(1,j-2);
        y = seq(i).xorth(2,j) - seq(i).xorth(2,j-2);
        z = seq(i).xorth(3,j) - seq(i).xorth(3,j-2);
        dir(1,i,j) = atan2d(y,x);
        dir(2,i,j) = atan2d(x,z);
        dir(3,i,j) = atan2d(y,z);
    end
    
    diffdir1 = diff(squeeze(dir(1,i,:)));
    diffdir2 = diff(squeeze(dir(2,i,:)));
    diffdir3 = diff(squeeze(dir(3,i,:)));
    for le = 1:length(diffdir1)
        if diffdir1(le)>180
            diffdir1(le)  = diffdir1(le) - 360;
        elseif diffdir2(le)>360
            diffdir2(le) = diffdir2(le)-360;
        elseif diffdir3(le)>360
            diffdir3(le) = diffdir3(le)-360;
        end   
    end
    [~,max_x] = sort(abs(diffdir1(3:end)),'descend');
    ff = max_x - max_x(1);
    [~,ind_x] = sort(abs(ff(1:5)),'descend');
    peak_x = [max_x(1) max_x(ind_x(1))];
    [~,max_y] = sort(abs(diffdir2(3:end)),'descend');
    ff = max_y - max_y(1);
    [~,ind_y] = sort(abs(ff(1:5)),'descend');
    peak_y = [max_y(1) max_y(ind_y(1))];
     [~,max_z] = sort(abs(diffdir3(3:end)),'descend');
     ff = max_z - max_z(1);
    [~,ind_z] = sort(abs(ff(1:5)),'descend');
    peak_z = [max_z(1) max_z(ind_z(1))];
    pe = [peak_x;peak_y;peak_z];
    peak(i,1) = min(pe(:,1));
    peak(i,2) = min(pe(:,2));
end
end