%% Cell 1: Load some data.
load fisheriris; %Load classic flower dataset.
meas = zscore(meas);
X = meas(:,[1,2]); d = 2;
%X = meas; d = 4;
[sval,~,y]=unique(species);
idx=(y==2)|(y==3);
X = X(idx,:);
y = y(idx,:);
y(y==3)=1; y(y==2)=0;
Xtr = X(1:2:end,:);
Ytr = y(1:2:end); 
Xte = X(2:2:end,:);
Yte = y(2:2:end);

figure(4); clf; gscatter(X(:,1),X(:,2),y);  title('True Class Labels');

lx=-2.5:0.05:2.5;
[LX1,LX2]=meshgrid(lx,lx);                      %Generate a list of every single condition in order to plot the classification space.
LX=[LX1(:),LX2(:)];

%% Cell 2: Train Naive Bayes.
nb = fitcnb(Xtr, Ytr);
[~,pTrNB,~] = predict(nb, Xtr); predTr = pTrNB(:,2)>0.5; fprintf(1,'NB Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));

[~,pTeNB,~] = predict(nb, Xte); predTe = pTeNB(:,2)>0.5; fprintf(1,'NB Test acc: %1.2f\n', sum(Yte==predTe)/numel(Yte));
util_nbVizMulti(lx,LX,nb,Xtr,Ytr,2,0.5);

%% Cell 2B: Train LR.
w0 = zeros(1,size(Xtr,2)+1);
options = optimset('GradObj','on');
f    = @(w) util_lrlik_reg_2c(Ytr, Xtr, w);
[w,fval,eflag,out] = fminunc(f, w0, options);
pTrLR = util_lrclass_2c(Xtr,w); predTr = pTrLR>0.5; fprintf(1,'LR Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
pTeLR = util_lrclass_2c(Xte,w); predTe = pTeLR>0.5; fprintf(1,'LR Test acc: %1.2f\n',  sum(Yte==predTe)/numel(Yte));
util_lrViz(lx,LX,w,Xtr,Ytr,2,0.5);             %Visualise the space by coloring the background.

%% Cell 3: Apply trained LR/Naive bayes with different thresholds.
thr = 0.1;      %Try different values here and observe results.
predTr = pTrLR>thr; fprintf(1,'LR Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
predTe = pTeLR>thr; fprintf(1,'LR Test acc: %1.2f\n',  sum(Yte==predTe)/numel(Yte));
cmat = confusionmat(Yte,double(predTe))
util_lrViz(lx,LX,w,Xtr,Ytr,2,thr);             %Visualise the space by coloring the background.

predTr = pTrNB(:,2)>thr; fprintf(1,'NB Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
predTe = pTeNB(:,2)>thr; fprintf(1,'NB Test  acc: %1.2f\n', sum(Yte==predTe)/numel(Yte));
cmat = confusionmat(Yte,double(predTe))
util_nbVizMulti(lx,LX,nb,Xtr,Ytr,2,thr);

%% Cell 4;
% This code computes the confusion matrix, and TPR/FPR for NB and LR/MaxEnt.
% Add a loop over threshold to try a whole bunch of thresholds, and plot fpr against tpr to generate an roc curve.
thr = 0.65;
predTr = pTrLR>thr; fprintf(1,'LR Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
predTe = pTeLR>thr; fprintf(1,'LR Test acc: %1.2f\n',  sum(Yte==predTe)/numel(Yte));
cmat = confusionmat(Yte,double(predTe))
tpr_lr=cmat(2,2)/sum(Yte==1);
fpr_lr=cmat(1,2)/sum(Yte==0);

predTr = pTrNB(:,2)>thr; fprintf(1,'NB Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
predTe = pTeNB(:,2)>thr; fprintf(1,'NB Test  acc: %1.2f\n', sum(Yte==predTe)/numel(Yte));
cmat = confusionmat(Yte,double(predTe))
tpr_nb=cmat(2,2)/sum(Yte==1);
fpr_nb=cmat(1,2)/sum(Yte==0);
[~,~,~,aucLR]=perfcurve(Yte,pTeLR,1); 
[~,~,~,aucNB]=perfcurve(Yte,pTeNB(:,2),1);
%%
count = 1;
for i = 0:0.05:1
    thr = i;
    predTr = pTrLR>thr; fprintf(1,'LR Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
    predTe = pTeLR>thr; fprintf(1,'LR Test acc: %1.2f\n',  sum(Yte==predTe)/numel(Yte));
    cmat = confusionmat(Yte,double(predTe))
    tpr_lr(count)=cmat(2,2)/sum(Yte==1);
    fpr_lr(count)=cmat(1,2)/sum(Yte==0);

    predTr = pTrNB(:,2)>thr; fprintf(1,'NB Train acc: %1.2f\n', sum(Ytr==predTr)/numel(Ytr));
    predTe = pTeNB(:,2)>thr; fprintf(1,'NB Test  acc: %1.2f\n', sum(Yte==predTe)/numel(Yte));
    cmat = confusionmat(Yte,double(predTe))
    tpr_nb(count)=cmat(2,2)/sum(Yte==1);
    fpr_nb(count)=cmat(1,2)/sum(Yte==0);
    
    [~,~,~,aucLR(count)]=perfcurve(Yte,pTeLR,1); 
    [~,~,~,aucNB(count)]=perfcurve(Yte,pTeNB(:,2),1);
    count = count+1;
end
nb_tpr = find(fpr_nb == 0.16);
lr_tpr = find(fpr_lr == 0.16);

figure(1)
% False Positive Rate. True Positive Rate.
plot(fpr_lr,tpr_lr, 'bd-', 'LineWidth', 2);
title('ROC Curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
grid on;
line([0,1], [0,1], 'LineWidth', 2, 'Color', 'k');
axis square;
figure(2)
plot(fpr_nb,tpr_nb,'bd-', 'LineWidth', 2 );
title('ROC Curve');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
grid on;
line([0,1], [0,1], 'LineWidth', 2, 'Color', 'k');
axis square;
figure(3)
plot(aucLR,0:0.05:1);

figure(4)
plot(aucNB,0:0.05:1);