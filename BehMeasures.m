function beh = BehMeasures(D,E,ani,record)
ind_reward = find(E==3);
ind_trial_start = find(E==42 | E==43);
overall_perf = length(ind_reward)/length(ind_trial_start);

ind_corr_lever_press = find(E==7);
ind_go = find(E==43);
ind_nogo =  find(E==42);
go_perf = length(ind_corr_lever_press)/length(ind_go);
nogo_perf = (length(ind_reward) - length(ind_corr_lever_press))/length(ind_go);
ind_cue_on_go = find(E==52);
count = 1;
for i = 1:length(ind_cue_on_go)
    if i ~=length(ind_cue_on_go)
        tmp_ind = find(E(ind_cue_on_go(i):ind_cue_on_go(i+1))==3,1) + ind_cue_on_go(i) - 1;
        if ~isempty(tmp_ind)
            ind_lvr = find(E(ind_cue_on_go(i):tmp_ind)==7) + ind_cue_on_go(i) - 1;
            if ~isempty(ind_lvr)
                tim_lever = D(ind_lvr) - D(ind_cue_on_go(i));
                tim_lever = tim_lever/100;
                latency(count) = tim_lever;
                count = count+1;
            end
        end
    else
        tmp_ind = find(E(ind_cue_on_go(i):end)==3,1) + ind_cue_on_go(i) - 1;
        if ~isempty(tmp_ind)
            ind_lvr = find(E(ind_cue_on_go(i):tmp_ind)==7) + ind_cue_on_go(i) - 1;
            if ~isempty(ind_lvr)
                tim_lever = D(ind_lvr) - D(ind_cue_on_go(i));
                tim_lever = tim_lever/100;
                latency(count) = tim_lever;
                count = count+1;
            end
        end
        
    end
end
count = 1;
for i = 1:length(ind_cue_on_go)
    if i ~=length(ind_cue_on_go)
        tmp_ind = find(E(ind_cue_on_go(i):ind_cue_on_go(i+1))==3,1) + ind_cue_on_go(i) - 1;
        if ~isempty(tmp_ind)
            ind_lvr = find(E(ind_cue_on_go(i):tmp_ind)==20) + ind_cue_on_go(i) - 1;
            if ~isempty(ind_lvr)
                tim_lever = D(ind_lvr(end)) - D(ind_cue_on_go(i));
                tim_lever = tim_lever/100;
                np_exit_go(count) = tim_lever;
                count = count+1;
            else
                np_exit_go(count) = 0;
                count = count+1;
            end
        end
    else
        tmp_ind = find(E(ind_cue_on_go(i):end)==3,1) + ind_cue_on_go(i) - 1;
        if ~isempty(tmp_ind)
            ind_lvr = find(E(ind_cue_on_go(i):tmp_ind)==20) + ind_cue_on_go(i) - 1;
            if ~isempty(ind_lvr)
                tim_lever = D(ind_lvr(end)) - D(ind_cue_on_go(i));
                tim_lever = tim_lever/100;
                np_exit_go(count) = tim_lever;
                count = count+1;
            else
                np_exit_go(count) = 0;
                count = count+1;
            end
            
        end
        
    end
end
count = 1;nogo_press = 0;
ind_cue_on_nogo = find(E==50);
for i = 1:length(ind_cue_on_nogo)
    if i ~=length(ind_cue_on_nogo)
        tmp_ind = find(E(ind_cue_on_nogo(i):ind_cue_on_nogo(i+1))==3,1) + ind_cue_on_nogo(i) - 1;
        if ~isempty(tmp_ind)
            tmp_ind = find(E(ind_cue_on_nogo(i):ind_cue_on_nogo(i+1))==13,1) + ind_cue_on_nogo(i) - 1;
            ind_lvr = find(E(ind_cue_on_nogo(i):tmp_ind)==20) + ind_cue_on_nogo(i) - 1;
            ind_nogo_off = find(E(ind_cue_on_nogo(i):tmp_ind)==51) + ind_cue_on_nogo(i) - 1;
            
            if ~isempty(ind_lvr) && ~isempty(ind_nogo_off)
                tim_lever = D(ind_lvr(end)) - D(ind_nogo_off);
                tim_lever = tim_lever/100;
                np_exit_nogo(count) = tim_lever;
                count = count+1;
                ind_press = find(E(ind_lvr(end):tmp_ind)==19);
                if ~isempty(ind_press)
                    nogo_press = nogo_press+1;
                end
                
            else
                np_exit_nogo(count) = 0;
                count = count+1;
            end
            
        end
    else
        tmp_ind = find(E(ind_cue_on_nogo(i):end)==3,1) + ind_cue_on_nogo(i) - 1;
        if ~isempty(tmp_ind)
            tmp_ind = find(E(ind_cue_on_nogo(i):end)==13,1) + ind_cue_on_nogo(i) - 1;
            ind_lvr = find(E(ind_cue_on_nogo(i):tmp_ind)==20) + ind_cue_on_nogo(i) - 1;
            ind_nogo_off = find(E(ind_cue_on_nogo(i):tmp_ind)==51) + ind_cue_on_nogo(i) - 1;
            
            if ~isempty(ind_lvr)&& ~isempty(ind_nogo_off)
                tim_lever = D(ind_lvr(end)) - D(ind_nogo_off);
                tim_lever = tim_lever/100;
                np_exit_nogo(count) = tim_lever;
                count = count+1;
                ind_press = find(E(ind_lvr(end):tmp_ind)==19);
                if ~isempty(ind_press)
                    nogo_press = nogo_press+1;
                end
            else
                np_exit_nogo(count) = 0;
                count = count+1;
            end
            
        end
        
    end
end
beh.perf = overall_perf*100;
beh.go_perf = go_perf*100;
beh.nogo_perf = nogo_perf*100;
beh.latency = median(latency);
beh.np_exit_go = median(np_exit_go);
beh.np_exit_nogo = median(np_exit_nogo);
beh.nogo_press = nogo_press;
beh.ani = ani;
beh.record = record;