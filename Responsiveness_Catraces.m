function responsivecells = Responsiveness_Catraces(trials,baseline,f_of_interest)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%U
% By Aishwarya Parthasarathy
% Updated on 19th December 2019
%trials - struct containing C_raw and trial parameters for correct trials

% baseline - in the format [x y] describing the start frame and end frame
% of a baseline you intend to compare the data of interest.

%f_of_interest - again in the format [x y] where x and y are the start and
%end frame of a period of interest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% I am assuming trials(1).C_raw is of size n1,n2. its the calcium
% transients measured in the first trial  and n1 is the number of neurons
% and n2 is the number of frames recorded in the trial. n1 will remain same
% for all trials. N2 changes from trial to trial. Change this accordingly
% if your trial structure isnt built this way
% Call the function like this :
% responsivecells = Responsiveness_Catraces(trials_corr,[1 15],[30 50])
% where [1 15] defines the start and end frame of your baseline and [30 50]
% defines the start and end frame of the period of your interest. Note that
% your trials(i).Craw should atleast have 50 frames in this case. 
responsivecells = [];
for i = 1:size(trials(1).C_raw)
    a=[]; b = [];C=[];
    for j = 1:length(trials)
        a = [a; trials(j).C_raw(i,baseline(1):baseline(2))];
        b = [b ;trials(j).C_raw(i,f_of_interest(1):f_of_interest(2))];
    end
    a_prc_2_5 = prctile(mean(a,2),2.5);
    a_prc_97_5 = prctile(mean(a,2),97.5);
    responsive_frames = [];
    for k = 1:size(b,2)
        [h,p_test,c] = ttest(mean(a,2),b(:,k));
        if p_test<0.05
            responsive_frames = [responsive_frames k];
        end
    end
    if ~isempty(responsive_frames)
        i1 = 1;
        C{i1}=responsive_frames(i1);
        for j1 = 2:numel(responsive_frames)
            t = responsive_frames(j1)-responsive_frames(j1-1);
            if t == 1
                C{i1} = [C{i1} responsive_frames(j1)];
            else
                i1  = i1 + 1;
                C{i1} = responsive_frames(j1);
            end
        end
        len_cons=[];
        for hh = 1:length(C)
            len_cons = [len_cons length(C{hh})];
        end
    end
    if ~isempty(responsive_frames)
        for r = 1:1000
            a_shuf=[]; b_shuf = [];C_shuf=[];
    for j = 1:length(trials)
        a_shuf = [a_shuf; trials(j).C_raw(i,baseline(1):baseline(2))];
        b_shuf = [b_shuf ;trials(j).C_raw(i,f_of_interest(1):f_of_interest(2))];
    end
   tmp_shuf = [a_shuf b_shuf];
   ind_shuf = randsample(size(tmp_shuf,2),size(a,2));
   ind_rest_shuf = setdiff(1:size(tmp_shuf,2),ind_shuf);
   a_shuf = tmp_shuf(:,ind_shuf);
   b_shuf = tmp_shuf(:,ind_rest_shuf);
    responsive_frames = [];
    for k = 1:size(b_shuf,2)
        [h,p_test,c] = ttest(mean(a_shuf,2),b_shuf(:,k));
        if p_test<0.05
            responsive_frames = [responsive_frames k];
        end
    end
    if ~isempty(responsive_frames)
        i1 = 1;
        C_shuf{i1}=responsive_frames(i1);
        for j1 = 2:numel(responsive_frames)
            t = responsive_frames(j1)-responsive_frames(j1-1);
            if t == 1
                C_shuf{i1} = [C_shuf{i1} responsive_frames(j1)];
            else
                i1  = i1 + 1;
                C_shuf{i1} = responsive_frames(j1);
            end
        end
        len_cons_shuf=[];
        for hh = 1:length(C_shuf)
            len_cons_shuf = [len_cons_shuf length(C_shuf{hh})];
        end
    end
    m_l_cons_shuf(r) = max(len_cons_shuf);
        end
    end
    if ~isempty(responsive_frames) && prctile(m_l_cons_shuf,90) < max(len_cons)
        responsivecells = [responsivecells i];
    end
end

end