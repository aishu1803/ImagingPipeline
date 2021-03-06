function [perf,latency] = BehPerformance_OldGoNogo(str_folder,n_animals,Cohort)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes the performance of the animals in the old go/nogo
% task. We will be computing the performance of the animals in the go/nogo
% trials and the latency to press the lever in the go trials. This is only
% for the 1st cohort of animals as we changed the event identity in the
% next few cohorts.
% Input  -
% 1) str_folder :  The folder where the medpc output files are stored.
% 2) n_animals : Number of animals in the cohort.
% Output -
% 1) perf - Nanimals x Nsessions x 2: The performance of the animals in
% different sessions in the go and nogo trials. Nanimals x Nsession x 1
% stores the performance of the go trials and Nanimals x Nsessions x 2
% stores the performance of the nogo trials. Nsessions is the max number of
% sessions performed by any one animal. If any other animal performs in
% fewer sessions, it is NaN padded.
% 2) latency - Nanimals x Nsessions: median latency of lever press during go trials.
% 5th October 2020
% Aishwarya Parthasarathy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Move to the folder specified in str_folder
cd(str_folder);
f = dir('*LeversOut*');
n_sessions = length(f);
perf = nan(n_animals,n_sessions,2);
latency = nan(n_animals,n_sessions);
if Cohort==1
    for i = 1:n_sessions
        cd(f(i).name);
        ff = dir;
        for j = 1:length(ff)
            if ff(j).bytes > 5
                [A,D,E] = ProcessMedPC(ff(j).name);
                ind_trials = find(E==2);
                n_go = 0;
                n_nogo = 0;
                n_go_corr  = 0;
                n_nogo_corr = 0;
                lat=[];
                for k = 1:length(ind_trials)
                    if k ~=length(ind_trials)
                        tmp =  E(ind_trials(k):ind_trials(k+1));
                        if ~isempty(find(tmp==19)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueoff = find(tmp == 8) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 18) + ind_trials(k) -1;
                            lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueoff))*0.01;
                            
                        elseif ~isempty(find(tmp==20)) && ~isempty(find(tmp==3))
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                        elseif ~isempty(find(tmp==20)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                        else
                            n_go = n_go+1;
                        end
                    else
                        tmp =  E(ind_trials(k):end);
                        if ~isempty(find(tmp==19)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueoff = find(tmp == 8) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 18) + ind_trials(k) -1;
                            lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueoff))*0.01;
                        elseif ~isempty(find(tmp==20)) && ~isempty(find(tmp==3))
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                        elseif ~isempty(find(tmp==20)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                        else
                            n_go = n_go+1;
                        end
                    end
                end
                if strcmp(ff(j).name,'1')
                    perf(1,i,1) = n_go_corr/n_go;
                    perf(1,i,2) = n_nogo_corr/n_nogo;
                    latency(1,i) = median(lat);
                elseif strcmp(ff(j).name,'2')
                    perf(2,i,1) = n_go_corr/n_go;
                    perf(2,i,2) = n_nogo_corr/n_nogo;
                    latency(2,i) = median(lat); 
                else
                    perf(3,i,1) = n_go_corr/n_go;
                    perf(3,i,2) = n_nogo_corr/n_nogo;
                    latency(3,i) = median(lat);
                end
            end
        end
        cd ..
    end
else
    for i = 1:n_sessions
        cd(f(i).name);
        ff = dir;
        for j = 1:length(ff)
            if ff(j).bytes > 5 && ~isempty(strfind('N O P Q R',ff(j).name))
                [A,D,E] = ProcessMedPC(ff(j).name);
                ind_trials = find(E==1);
                n_go = 0;
                n_nogo = 0;
                n_go_corr  = 0;
                n_nogo_corr = 0;
                lat=[];
                for k = 1:length(ind_trials)
                    if k ~=length(ind_trials)
                        tmp =  E(ind_trials(k):ind_trials(k+1));
                        if ~isempty(find(tmp==47)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueoff = find(tmp == 17) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 7) + ind_trials(k) -1;
                            lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueoff))*0.01;
                            
                        elseif ~isempty(find(tmp==46)) && ~isempty(find(tmp==3))
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                        elseif ~isempty(find(tmp==46)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                        else
                            n_go = n_go+1;
                        end
                    else
                        tmp =  E(ind_trials(k):end);
                        if ~isempty(find(tmp==47)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueoff = find(tmp == 17) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 7) + ind_trials(k) -1;
                            lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueoff))*0.01;
                        elseif ~isempty(find(tmp==46)) && ~isempty(find(tmp==3))
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                        elseif ~isempty(find(tmp==46)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                        else
                            n_go = n_go+1;
                        end
                    end
                end
                if strcmp(ff(j).name,'N')
                    perf(1,i,1) = n_go_corr/n_go;
                    perf(1,i,2) = n_nogo_corr/n_nogo;
                    latency(1,i) = median(lat);
                elseif strcmp(ff(j).name,'O')
                    perf(2,i,1) = n_go_corr/n_go;
                    perf(2,i,2) = n_nogo_corr/n_nogo;
                    latency(2,i) = median(lat);
                elseif strcmp(ff(j).name,'P')
                    perf(3,i,1) = n_go_corr/n_go;
                    perf(3,i,2) = n_nogo_corr/n_nogo;
                    latency(3,i) = median(lat);
                elseif strcmp(ff(j).name,'Q')
                    perf(4,i,1) = n_go_corr/n_go;
                    perf(4,i,2) = n_nogo_corr/n_nogo;
                    latency(4,i) = median(lat);
                else
                    perf(5,i,1) = n_go_corr/n_go;
                    perf(5,i,2) = n_nogo_corr/n_nogo;
                    latency(5,i) = median(lat);
                end
            end
        end
        cd ..
    end
end
