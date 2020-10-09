function trials = Postprocess_trajectory(seq1,seq2,trials)

for i = 1:length(seq1)
    ex1(1,:) = seq1(i).xorth(1,:) - seq1(i).xorth(1,1);
    ex1(2,:) = seq1(i).xorth(2,:) - seq1(i).xorth(2,1);
    ex1(3,:) = seq1(i).xorth(3,:) - seq1(i).xorth(3,1);
    
    [L1,R1,K1] = curvature(ex1');
    [~,~,W] = svd(ex1'-mean(ex1'));
    no = W(:,end);
    
    for j = 1:size(K1,1)
        le_vec_length(j) = sqrt(K1(j,1)^2 + K1(j,2)^2+K1(j,3)^2);
    end
   
    [trials(i).max_npentry_len,trials(i).max_vec_npentry] = max(le_vec_length(10:20));
%     k2 = ex1(2:3,trials(i).max_vec_npentry + 9) - ex1(2:3,trials(i).max_vec_npentry + 8);
k2 = [0.5 0.5 0.5];
%     %      trials(i).np_entry_angle = atan2d(norm(cross(K1(trials(i).max_vec_npentry + 9,2:3),k2)), dot(K1(trials(i).max_vec_npentry + 9,2:3),k2));
%     trials(i).np_entry_angle1 = atan2d(K1(trials(i).max_vec_npentry + 9,3) - ex1(3,trials(i).max_vec_npentry + 9), K1(trials(i).max_vec_npentry + 9,2) - ex1(2,trials(i).max_vec_npentry + 9));
%     trials(i).np_entry_angle2 = atan2d(K1(trials(i).max_vec_npentry + 9,3) - ex1(3,trials(i).max_vec_npentry + 9), K1(trials(i).max_vec_npentry + 9,1) - ex1(1,trials(i).max_vec_npentry + 9));
%     trials(i).np_entry_angle3 = atan2d(K1(trials(i).max_vec_npentry + 9,2) - ex1(2,trials(i).max_vec_npentry + 9), K1(trials(i).max_vec_npentry + 9,1) - ex1(1,trials(i).max_vec_npentry + 9));
    
    v1 = [ K1(trials(i).max_vec_npentry + 9,1:3)  ];
     trials(i).np_entry_angle = atan2d(norm(cross(v1,k2)),dot(v1,k2));
    trials(i).entry_curvature =  K1(trials(i).max_vec_npentry + 9,1:3); 
    if dot(cross(v1,k2),no) < 0
        trials(i).np_entry_angle =  360-trials(i).np_entry_angle ;
    end
    trials(i).max_vec_npentry =  trials(i).max_vec_npentry + 9 ;
    
    [trials(i).max_npexit_len,trials(i).max_vec_npexit] = max(le_vec_length(end-22:end-7));
%     k2 = ex1(:,trials(i).max_vec_npexit + length(le_vec_length)-21) - ex1(:,trials(i).max_vec_npexit + +length(le_vec_length)-20);
k2 = [0.5 0.5 0.5];
    %      trials(i).np_exit_angle = atan2d(norm(cross(K1(trials(i).max_vec_npexit+length(le_vec_length)-21,2:3),k2)), dot(K1(trials(i).max_vec_npexit+length(le_vec_length)-21,2:3),k2));
%     trials(i).np_exit_angle1 = atan2d(K1(trials(i).max_vec_npexit + length(le_vec_length)-21,3)- ex1(3,trials(i).max_vec_npexit + length(le_vec_length)-21), K1(trials(i).max_vec_npexit + length(le_vec_length)-21,2)- ex1(2,trials(i).max_vec_npexit + length(le_vec_length)-21));
%     trials(i).np_exit_angle2 = atan2d(K1(trials(i).max_vec_npexit + length(le_vec_length)-21,3)- ex1(3,trials(i).max_vec_npexit + length(le_vec_length)-21), K1(trials(i).max_vec_npexit + length(le_vec_length)-21,1)- ex1(1,trials(i).max_vec_npexit + length(le_vec_length)-21));
%     trials(i).np_exit_angle3 = atan2d(K1(trials(i).max_vec_npexit + length(le_vec_length)-21,2)- ex1(2,trials(i).max_vec_npexit + length(le_vec_length)-21), K1(trials(i).max_vec_npexit + length(le_vec_length)-21,1)- ex1(1,trials(i).max_vec_npexit + length(le_vec_length)-21));
   
    v1e = [K1(trials(i).max_vec_npexit + length(le_vec_length)-23,1:3)  ];
    trials(i).np_exit_angle = atan2d(norm(cross(v1e,k2)),dot(v1e,k2));
    trials(i).exit_curvature = K1(trials(i).max_vec_npexit + length(le_vec_length)-23,1:3);
    trials(i).max_vec_npexit =  trials(i).max_vec_npexit + length(le_vec_length)-23;
      if dot(cross(v1e,k2),no) < 0
        trials(i).np_exit_angle =  360-trials(i).np_exit_angle ;
    end
    ex1=[]; le_vec_length=[];
end
