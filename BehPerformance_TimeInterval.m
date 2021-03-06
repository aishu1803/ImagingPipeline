function [perf,latency] = BehPerformance_TimeInterval(str_folder,n_animals,Cohort)
cd(str_folder);
f = dir('*LeversOut*');
n_sessions = length(f);
perf = nan(n_animals,n_sessions);
latency = nan(n_animals,n_sessions);
if Cohort == 1
    for i = 1:n_sessions
        cd(f(i).name);
        ff = dir;
        for j = 1:length(ff)
            if ff(j).bytes > 5 && ~isempty(strfind('K L P K_2 L_2 P_2',ff(j).name))
                out = load_intervaldetection_behav_data(ff(j).name);
                ind_e = find(strcmp(out(:,1),'E:'));
                ind_f = find(strcmp(out(:,1),'F:'));
                d = [];
                e = [];
                E = out(ind_e+1:ind_f-1,:);
                E(:,1) = [];
                for g = 1:size(E,1)
                    for h = 1:size(E,2)
                        if h==1
                            d(g,h) = cell2mat(E(g,h));
                        else
                            if ~isempty(E{g,h})
                                d(g,h) = str2num(E{g,h});
                            end
                        end
                    end
                end
                F = out(ind_f+1:ind_f+size(E,1),:);
                F(:,1) = [];
                for g = 1:size(F,1)
                    for h = 1:size(F,2)
                        if h==1
                            e(g,h) = cell2mat(F(g,h));
                        else
                            if ~isempty(E{g,h})
                                e(g,h) = str2num(F{g,h});
                            end
                        end
                    end
                end
                e = reshape(e',1,[]);
                d = reshape(d',1,[]);
                ind_trials = find(e==1);
                ind_rew = find(e==6);
                cc = 1;lat=[];
                for m = 1:length(ind_trials)
                    if m ~=length(ind_trials)
                        tmp =  e(ind_trials(m):ind_trials(m+1));
                        tmp_d = d(ind_trials(m):ind_trials(m+1));
                        ind_r = find(tmp==6);
                        if ~isempty(ind_r)
                            ind_lvr = find(tmp(1:ind_r)==4 |tmp(1:ind_r)==5 );
                            lat(cc) = (tmp_d(ind_r) - tmp_d(1));
                            cc = cc+1;
                        end
                    else
                        tmp =  e(ind_trials(m):end);
                        tmp_d = d(ind_trials(m):end);
                        ind_r = find(tmp==3);
                        if ~isempty(ind_r)
                            ind_lvr = find(tmp(1:ind_r)==4 |tmp(1:ind_r)==5 );
                            lat(cc) = (tmp_d(ind_r) - tmp_d(1));
                            cc = cc+1;
                        end
                        
                    end
                end
                
                if strcmp(ff(j).name,'K')
                    perf(1,i) = length(ind_rew)/length(ind_trials);
                    
                    latency(1,i) = median(lat);
                elseif strcmp(ff(j).name,'L')
                    perf(2,i) = length(ind_rew)/length(ind_trials);
                    latency(2,i) = median(lat);
                elseif strcmp(ff(j).name,'P')
                    perf(3,i) =length(ind_rew)/length(ind_trials);
                    latency(3,i) = median(lat);
                elseif strcmp(ff(j).name,'K_2')
                    perf(1,i) = length(ind_rew)/length(ind_trials);
                    latency(1,i) = median(lat);
                elseif strcmp(ff(j).name,'L_2')
                    perf(2,i) = length(ind_rew)/length(ind_trials);
                    latency(1,i) = median(lat);
                else
                    perf(3,i) = length(ind_rew)/length(ind_trials);
                    latency(1,i) = median(lat);
                end
            end
        end
        cd ..
    end
    
end
end