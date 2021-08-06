function y_hat = myFun(K,x)
yhat = K(:,2:end)*x + K(:,1);