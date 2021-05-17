function [r,r_go,r_nogo,pval,p_val_go,p_val_nogo] =  CurvaturePlots(go,nogo,go_err,nogo_err)
% Leverpress latency scatter
 figure
t1 = [go.lp;];
t2 = [go.lp_real;];
t1_nan = find(isnan(t1));
t1(t1_nan) = [];
t2(t1_nan) = [];
t1 = (t1-30)/15;
t2 = (t2 - 30)/15;
lp_val = [go.lp_val;];
subplot(1,2,1)
scatter(t1,t2,'MarkerFaceColor','b','MarkerEdgeColor','b')
set(gca,'FontSize',20),xlabel('Predicted Latency (s)'),ylabel('True Latency(s)');
title('Leverpress latency');
[r,pval] = corr(t1',t2');
st = sprintf('R = %.3g, p = %.3g',r,pval);
text(min(t1),max(t2),st,'FontSize',14,'Color','b');
subplot(1,2,2)
histogram(lp_val,-1:0.25:1,'FaceColor','b','FaceAlpha',0.3,'EdgeColor','k');
set(gca,'FontSize',20),xlabel('Curvature value'),ylabel('Number of trials');
title('Leverpress latency');
% Nosepoke exit latency
figure
t1_go = [go.np;];
t2_go = [go.np_real;];
t1_go_nan = find(isnan(t1_go));
t1_go(t1_go_nan) = [];
t2_go(t1_go_nan) = [];
t1_go = (t1_go-30)/15;
t2_go = (t2_go - 30)/15;
subplot(1,3,1)
scatter(t1_go,t2_go,'MarkerFaceColor','b','MarkerEdgeColor','b')
[r_go,p_val_go] = corr(t1_go',t2_go');
st = sprintf('R = %.2g, p = %.2g',r_go,p_val_go);
text(min(t1_go),3,st,'FontSize',14,'Color','b');
set(gca,'FontSize',20),xlabel('Predicted Latency (s)'),ylabel('True Latency(s)');
t1_nogo = [nogo.np;];
t2_nogo = [nogo.np_real;];
t1_nogo_nan = find(isnan(t1_nogo));
t1_nogo(t1_nogo_nan) = [];
t2_nogo(t1_nogo_nan) = [];
t1_nogo = (t1_nogo-30)/15;
t2_nogo = (t2_nogo - 30)/15;
hold on
scatter(t1_nogo,t2_nogo,'MarkerFaceColor','r','MarkerEdgeColor','r')
[r_nogo,p_val_nogo] = corr(t1_nogo',t2_nogo');
st = sprintf('R = %.2g, p = %.2g',r_nogo,p_val_nogo);
text(0.5,2.5,st,'FontSize',14,'Color','r');
title('Nosepoke exit latency');
subplot(1,3,2)
np_go_val = [go.np_val;];
np_nogo_val = [nogo.np_val;];
histogram(np_go_val,-1:0.25:1,'FaceColor','b','FaceAlpha',0.3,'EdgeColor','k')
set(gca,'FontSize',20),xlabel('Curvature value'),ylabel('Number of trials');
subplot(1,3,3)
histogram(np_nogo_val,-1:0.25:1,'FaceColor','r','FaceAlpha',0.3,'EdgeColor','k')
set(gca,'FontSize',20),xlabel('Curvature value'),ylabel('Number of trials');

% close all;
