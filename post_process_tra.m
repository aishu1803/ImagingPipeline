
ang=[];
for i = 1:length(seqNogoEng)
    ex(1,:,i) = seqNogoEng(i).xorth(1,:) - seqNogoEng(i).xorth(1,1);
    ex(2,:,i) = seqNogoEng(i).xorth(2,:) - seqNogoEng(i).xorth(2,1);
    ex(3,:,i) = seqNogoEng(i).xorth(3,:) - seqNogoEng(i).xorth(3,1);
end
    
for i = 1:size(ex,3)
    ex1 = squeeze(ex(:,:,i));
    tk = [1 2;1 3;2 3];
    idx=[];
    for j = 1:size(tk,1)
        f2 = gradient(ex1(tk(j,1),:),ex1(tk(j,2),:));
        id = sign(f2);
        idx=[idx strfind(id,[-1 1])];
    end
    post_process_trajec(i).turningtime = unique(idx);
end
for i = 1:length(post_process_trajec)
    exam = post_process_trajec(i).turningtime;
    exam_ind = find(diff(exam)<5);
    [L_ng(:,i),R_ng(:,i),K_ng(:,:,i)] = curvature(seqNogoEng(i).xorth');
    quest_ind = exam(exam_ind+1);
    exam_r = R_ng(exam,i);
    exam_ind = exam_ind+1;
    for j = 1:length(exam_ind)
    end
    innd=[];
    for j = 1:length(exam_ind)
        if exam_r(exam_ind(j)) > exam_r(exam_ind(j)-1)
            innd=[innd exam_ind(j)-1];
        else
            innd = [innd exam_ind(j)];
        end
    end
    exam(innd)=[];
    post_process_trajec(i).turningtime = exam;
end
for i = 1:length(post_process_trajec)
    tmp = find(post_process_trajec(i).turningtime>10& post_process_trajec(i).turningtime<20,1,'first');
    if ~isempty(tmp)
        tu(i) = post_process_trajec(i).turningtime(tmp);
    else
        tu(i) = 0;
    end
end
for i = 1:length(post_process_trajec)
    tmp = find(post_process_trajec(i).turningtime>20 & post_process_trajec(i).turningtime<60,1,'first');
    if ~isempty(tmp)
        tu_de(i) = post_process_trajec(i).turningtime(tmp);
    else
        tu_de(i) = 0;
    end
end
for i = 1:49
    post_process_trajec(i).engage_turningpt = tu(i);
end
for i = 1:49
    post_process_trajec(i).disengage_turningpt = tu_de(i);
end

for i = 1:49
if post_process_trajec(i).disengage_turningpt~=0
np2 = K_ng(post_process_trajec(i).disengage_turningpt,1:3,i)/norm(K_ng(post_process_trajec(i).disengage_turningpt,1:3,i));
post_process_trajec(i).disengage_angle = np2;
end
end

for i = 1:49
if post_process_trajec(i).engage_turningpt~=0
np2 = K_ng(post_process_trajec(i).engage_turningpt,1:3,i)/norm(K_ng(post_process_trajec(i).engage_turningpt,1:3,i));
post_process_trajec(i).engage_angle = np2;
end
end