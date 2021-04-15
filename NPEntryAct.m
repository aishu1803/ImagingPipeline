function [nogo_activity,go_activity,nogo_err_activity,go_err_activity] =  NPEntryAct(firingRates,trials,trialNum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get z-scored baseline subtracted activity of all the neurons aligned to
% nosepoke entry.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Nogo trials
for i = 1:size(firingRates,1)
    for j = 1:trialNum(1,1,1)
        nogo_activity(i,:,j) = firingRates(i,1,1,:,j);
    end  
end
% Go trials
for i = 1:size(firingRates,1)
    for j = 1:trialNum(1,2,1)
        go_activity(i,:,j) = firingRates(i,2,1,:,j);
    end  
end
% NoGo error trials
for i = 1:size(firingRates,1)
    for j = 1:trialNum(1,1,2)
        nogo_err_activity(i,:,j) = firingRates(i,1,2,:,j);
    end  
end
% Go error trials
for i = 1:size(firingRates,1)
    for j = 1:trialNum(1,2,2)
        go_err_activity(i,:,j) = firingRates(i,2,2,:,j);
    end  
end