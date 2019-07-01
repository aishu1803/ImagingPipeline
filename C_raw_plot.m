function C_raw_plot(act,no_goinc)
for j = 1:38
    tmp=[];
    for i = no_goinc
        tmp = [tmp;act(i).nogo(j,:)];
    end
    nogo_incavg(j,:) = mean(tmp,1);
end
for j = 1:37
    tmp=[];
    for i = no_goinc
        tmp = [tmp;act(i).go(j,:)];
    end
    go_incavg(j,:) = mean(tmp,1);
end