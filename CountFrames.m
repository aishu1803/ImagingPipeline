function fno = CountFrames(foldername)
f = dir(foldername);
tt = [];
for i = 1:92
tt = [tt; f(i).date];
end
[A,ind]=sortrows(tt);
ind = [5; ind(6:end)];

count = 1;
for i = 1:length(ind)
    if length(f(ind(i)).name)>2 && f(ind(i)).isdir
        str = sprintf('%s\\%s',foldername,f(ind(i)).name);
        cd(str);
        f1 = dir(str);
        if  length(f1)==5
            if f1(5).bytes>1500
                data = readtable('timestamp.dat');
                fno(count) = size(data,1)-1;
                count = count +1;
            end
        end
        
    end
end
