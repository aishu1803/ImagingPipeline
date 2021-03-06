function [dir,peak] =  trajdir(seq)
for i = 1:length(seq)
    dy = diff(seq(i).xorth(2,:))./diff(seq(i).xorth(1,:));
    [b,ind] = max(abs(dy));
    for j = 3:size(seq(1).xorth,2)
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
    [~,max_y] = sort(abs(diffdir2(3:end)),'descend');
    [~,max_z] = sort(abs(diffdir3(3:end)),'descend');
    peak(i) = min([max_x max_y max_z]+3);
end
end