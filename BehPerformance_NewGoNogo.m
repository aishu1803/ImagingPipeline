function [perf,latency,latency_npexit,latency_npexit_nogo_err] = BehPerformance_NewGoNogo(str_folder,n_animals,Cohort)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes the performance of the animals in the new go/nogo
% task. We will be computing the performance of the animals in the go/nogo
% trials and the latency to press the lever in the go trials. This is only
% for the 1st cohort of animals as we changed the event identity in the
% next few cohorts.
% Input  -
% 1) str_folder :  The folder where the medpc output files are stored.
% 2) n_animals : Number of animals in the cohort.
% 3) Cohort : Mentions which cohort it is
% Output -
% 1) perf - Nanimals x Nsessions x 2: The performance of the animals in
% different sessions in the go and nogo trials. Nanimals x Nsession x 1
% stores the performance of the go trials and Nanimals x Nsessions x 2
% stores the performance of the nogo trials. Nsessions is the max number of
% sessions performed by any one animal. If any other animal performs in
% fewer sessions, it is NaN padded.
% 2) latency - Nanimals x Nsessions: median latency of lever press during go trials.
% 6th October 2020
% Aishwarya Parthasarathy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move to the folder specified in str_folder
cd(str_folder);
f = dir('*LeversOut*');
n_sessions = length(f);
perf = nan(n_animals,n_sessions,2);
latency = nan(n_animals,n_sessions);
latency_npexit = nan(n_animals,n_sessions,2);
latency_npexit_nogo_err = nan(n_animals,n_sessions);
if Cohort==1
    for i = 1:n_sessions
        cd(f(i).name);
        ff = dir;
        tic
        for j = 1:length(ff)
            if ff(j).bytes > 5 && ~isempty(strfind('A C D E F K L M',ff(j).name))
                [A,D,E] = ProcessMedPC(ff(j).name);
                ind_trials = find(E==1);
                n_go = 0;
                n_nogo = 0;
                n_go_corr  = 0;
                n_nogo_corr = 0;
                n_nogo_err = 0;
                lat_npexit_nogo_err = [];
                lat=[];lat_npexit_go=[];lat_npexit_nogo=[]; len_gotrials = [];
                for k = 1:length(ind_trials)
                    if k ~=length(ind_trials)
                        tmp =  E(ind_trials(k):ind_trials(k+1));
                        if ~isempty(find(tmp==47)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueon = find(tmp == 52) + ind_trials(k) -1;
                            ind_cuelighton = find(tmp == 16) + ind_trials(k) -1;
                            ind_npstart = find(tmp == 43) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 7) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 53) + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cuelighton:ind_cueoff)==20,1,'last') + ind_cuelighton - 1;
                            if ~isempty(ind_cueon)
                                lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueon))*0.01;
                                lat_npexit_go(n_go_corr) = (D(ind_npexit) - D(ind_cueon))*0.01;
                                if A(16)==2
                                    len_gotrials(n_go_corr) = (D(ind_leverpress) - D(ind_npstart))*0.01;
                                end
                            end
                            
                        elseif ~isempty(find(tmp==46)) && ~isempty(find(tmp==3))
                            
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                            ind_cueon = find(tmp == 42) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 1,1,'last') + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cueon:ind_cueoff)==20,1,'last') + ind_cueon - 1;
                            if ~isempty(ind_cueon)
                                lat_npexit_nogo(n_nogo_corr) = (D(ind_npexit) - D(ind_cueon))*0.01;
                            end
                        elseif ~isempty(find(tmp==46)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                            n_nogo_err = n_nogo_err + 1;
                            ind_cueon = find(tmp == 42) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 17) + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cueon:ind_cueoff)==20,1,'last') + ind_cueon - 1;
                            if ~isempty(ind_cueon) && ~isempty(ind_npexit)
                                lat_npexit_nogo_err(n_nogo_err) = (D(ind_npexit) - D(ind_cueon))*0.01;
                            end
                            
                        else
                            n_go = n_go+1;
                        end
                    else
                        tmp =  E(ind_trials(k):end);
                        if ~isempty(find(tmp==47)) && ~isempty(find(tmp==3))
                            n_go_corr = n_go_corr +1;
                            n_go = n_go +1;
                            ind_cueon = find(tmp == 52) + ind_trials(k) -1;
                            ind_cuelighton = find(tmp == 16) + ind_trials(k) -1;
                            ind_npstart = find(tmp == 43) + ind_trials(k) -1;
                            ind_leverpress = find(tmp == 7) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 53) + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cuelighton:ind_cueoff)==20,1,'last') + ind_cuelighton - 1;
                            if ~isempty(ind_cueon)
                                lat(n_go_corr) = (D(ind_leverpress) - D(ind_cueon))*0.01;
                                lat_npexit_go(n_go_corr) = (D(ind_npexit) - D(ind_cueon))*0.01;
                                if A(16)==2
                                    len_gotrials(n_go_corr) = (D(ind_leverpress) - D(ind_npstart))*0.01;
                                end
                       
                            end
                        elseif ~isempty(find(tmp==46)) && ~isempty(find(tmp==3))
                            n_nogo_corr = n_nogo_corr +1;
                            n_nogo = n_nogo +1;
                            ind_cueon = find(tmp == 42) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 1,1,'last') + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cueon:ind_cueoff)==20,1,'last') + ind_cueon - 1;
                            if ~isempty(ind_cueon)
                                lat_npexit_nogo(n_nogo_corr) = (D(ind_npexit) - D(ind_cueon))*0.01;
                            end
                            
                        elseif ~isempty(find(tmp==46)) && isempty(find(tmp==3))
                            n_nogo = n_nogo +1;
                            n_nogo_err = n_nogo_err + 1;
                            ind_cueon = find(tmp == 42) + ind_trials(k) -1;
                            ind_cueoff = find(tmp == 17) + ind_trials(k) -1;
                            ind_npexit = find(E(ind_cueon:ind_cueoff)==20,1,'last') + ind_cueon - 1;
                            if ~isempty(ind_cueon) && ~isempty(ind_npexit)
                                lat_npexit_nogo_err(n_nogo_err) = (D(ind_npexit) - D(ind_cueon))*0.01;
                            end
                        else
                            n_go = n_go+1;
                        end
                    end
                end
                if strcmp(ff(j).name,'A')
                    perf(1,i,1) = n_go_corr/n_go;
                    perf(1,i,2) = n_nogo_corr/n_nogo;
                    latency(1,i) = median(lat);
                    latency_npexit(1,i,1) = median(lat_npexit_go);
                    latency_npexit(1,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(1,i) = median(lat_npexit_nogo_err);
                elseif strcmp(ff(j).name,'C')
                    perf(2,i,1) = n_go_corr/n_go;
                    perf(2,i,2) = n_nogo_corr/n_nogo;
                    latency(2,i) = median(lat);
                    latency_npexit(2,i,1) = median(lat_npexit_go);
                    latency_npexit(2,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(2,i) = median(lat_npexit_nogo_err);
                elseif strcmp(ff(j).name,'D')
                    perf(3,i,1) = n_go_corr/n_go;
                    perf(3,i,2) = n_nogo_corr/n_nogo;
                    latency(3,i) = median(lat);
                    latency_npexit(3,i,1) = median(lat_npexit_go);
                    latency_npexit(3,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(3,i) = median(lat_npexit_nogo_err);
                elseif strcmp(ff(j).name,'E')
                    perf(4,i,1) = n_go_corr/n_go;
                    perf(4,i,2) = n_nogo_corr/n_nogo;
                    latency(4,i) = median(lat);
                    latency_npexit(4,i,1) = median(lat_npexit_go);
                    latency_npexit(4,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(4,i) = median(lat_npexit_nogo_err);
                    
                elseif strcmp(ff(j).name,'F')
                    perf(5,i,1) = n_go_corr/n_go;
                    perf(5,i,2) = n_nogo_corr/n_nogo;
                    latency(5,i) = median(lat);
                    latency_npexit(5,i,1) = median(lat_npexit_go);
                    latency_npexit(5,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(5,i) = median(lat_npexit_nogo_err);
                elseif strcmp(ff(j).name,'K')
                    perf(6,i,1) = n_go_corr/n_go;
                    perf(6,i,2) = n_nogo_corr/n_nogo;
                    latency(6,i) = median(lat);
                    latency_npexit(6,i,1) = median(lat_npexit_go);
                    latency_npexit(6,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(6,i) = median(lat_npexit_nogo_err);
                elseif strcmp(ff(j).name,'L')
                    perf(7,i,1) = n_go_corr/n_go;
                    perf(7,i,2) = n_nogo_corr/n_nogo;
                    latency(7,i) = median(lat);
                    latency_npexit(7,i,1) = median(lat_npexit_go);
                    latency_npexit(7,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(7,i) = median(lat_npexit_nogo_err);
                else
                    perf(8,i,1) = n_go_corr/n_go;
                    perf(8,i,2) = n_nogo_corr/n_nogo;
                    latency(8,i) = median(lat);
                    latency_npexit(8,i,1) = median(lat_npexit_go);
                    latency_npexit(8,i,2) = median(lat_npexit_nogo);
                    latency_npexit_nogo_err(8,i) = median(lat_npexit_nogo_err);
                end
            end
        end
        toc
        cd ..
    end
end