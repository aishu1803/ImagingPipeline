function [K,resnorm,residual]= Regression(firingRates,trials,trialNum,reg,shuf_flag)
[task_Event] =  BuildEventMatrix(trials,reg);
CV0 = cvpartition(1:length(task_Event),'k',5);
options = optimset('Display','none','TolX', 1e-10, 'TolFun', 1e-10, 'MaxFunEvals', 4000000, 'MaxIter', 4000);
for i = 1:5
    c(:,i) = test(CV0,i);
end
for i = 1:size(firingRates,1)
    tmp_cell = squeeze(firingRates(i,2,1,:,1:trialNum(1,2,1)));
    tmp_cell = [tmp_cell squeeze(firingRates(i,1,1,:,1:trialNum(1,1,1)))];
    for j = 1:5
        train_t = setdiff(1:size(tmp_cell,2),find(c(:,j)));
        test_t = find(c(:,j));
        train_y = tmp_cell(:,train_t);
        test_y = tmp_cell(:,test_t);
        train_x = task_Event(train_t);
        test_x = task_Event(test_t);
        cell1=[];
        for i_train = 1:length(train_t)
            cell1 = [cell1;train_y(:,i_train)];
            
        end
        X = [train_x.val;];
        if shuf_flag
            cell1 = cell1(randsample(length(cell1),length(cell1)));
        end
         [K(i,j,:),resnorm(i,j),residual(i,j,:),~,~,~,~] = lsqcurvefit(@(K,x) myFun(K,x), [1 ones(1,size(X,1))],X,cell1',[],[],options);
    end
end