function dir =  trajdir(seq)
for i = 1:length(seq)
    dy = diff(seq(i).xorth(2,:))./diff(seq(i).xorth(1,:));
    [b,ind] = max(abs(dy));
    for j = 3:size(seq(1).xorth,2)
        x = seq(i).xorth(1,j) - seq(i).xorth(1,j-2);
        y = seq(i).xorth(2,j) - seq(i).xorth(2,j-2);
        dir(i,j) = atan2d(y,x);
    end
end