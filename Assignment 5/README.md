# Assignment 5

## Q1.6A.

- K = 2, cluster quality is 83.5.
- K = 3, cluster quality is 62.8.
- K = 4, cluster quality is 57.9.
- K = 5, cluster quality is 54.9.

As the K increase, the cluster quality decrease. When K equals to 5, the cluster gets its minimize quality which is 54.9\. Because the cluster quality is the total Distence To Cluster. So The min value is better.

Reason: The algorithm is that

1. Determine an initial cluster center for each cluster so that there are K initial cluster centers.
2. Assign samples in the sample set to the nearest neighbor cluster based on the principle of minimum distance
3. Use the sample data mean in each cluster as the new cluster center.
4. Repeat step 2.3 until the cluster center no longer changes.
5. End, get minimize the squared error criterion.

## Q1.6B.

seed | K | cluster quality
---- | - | ---------------
0    | 3 | 64.1
1    | 3 | 62.8
2    | 3 | 73.8
3    | 3 | 65.4
4    | 3 | 75.6
5    | 3 | 83.5
6    | 3 | 65.6
7    | 3 | 62.7

The different seeds is the random seed that will pick different initial conditions for the cluster. So the number of the seed will not affect the cluster quality, only affect the locations of the initial points.

## Q1.7.

Clustering accuracy improved after uncommenting

```matlab
X = meas; d = 4;
```

The value **meas** has 150 rows and 4 columns.

Before uncommenting the code above.

```matlab
X = meas(:,1:2); d = 2;
```

The **X** takes the first two columns of **meas**. So that after uncommenting the code, the clustering accuracy improved.

## Q2.3

1. Run Cell2A. Naïve Bayes classifiers

  - NB Train acc: 0.70
  - NB Test acc: 0.74 ![img](Lab6/4-1-1.jpg)

2. Run Cell2B. LR classifiers

  - LR Train acc: 0.70
  - LR Test acc: 0.76 ![img](Lab6/4-1-2.jpg)

## Q2.4

Decision is the LR classifiers , that the test accuracy is 0.76 which is better than Naïve Bayes classifiers Test accuracy.

## Q2.5

1. threshold = 0.3

  - LR Train acc: 0.64
  - LR Test acc: 0.60
  - ![img](Lab6/4-5-2.jpg)
  - NB Train acc: 0.64
  - NB Test acc: 0.62
  - ![img](Lab6/4-5-2.jpg)

2. threshold = 0.6

  - LR Train acc: 0.68
  - LR Test acc: 0.72
  - ![img](Lab6/4-5-3.jpg)
  - NB Train acc: 0.68
  - NB Test acc: 0.72
  - ![img](Lab6/4-5-4.jpg)

3. threshold = 1.0

  - LR Train acc: 0.52
  - LR Test acc: 0.54
  - ![img](Lab6/4-5-5.jpg)
  - NB Train acc: 0.50
  - NB Test acc: 0.56
  - ![img](Lab6/4-5-6.jpg)

## Q2.7

```matlab

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


    count = count+1;
end
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
```

## Q2.8

- ROC Curve LR classifiers ![img](Lab6/4-7-2.jpg)
- ROC Curve Naïve Bayes classifiers ![img](Lab6/4-7-1.jpg)

```matlab
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
```

## Q2.11

```matlab
[~,~,~,aucLR]=perfcurve(Yte,pTeLR,1);
[~,~,~,aucNB]=perfcurve(Yte,pTeNB(:,2),1);
```

The result shows that

- aucLR = 0.8104
- aucNB = 0.7992

The LR is preferabled by AUC metric.

## Q2.12

```matlab
nb_tpr = find(fpr_nb == 0.16);
lr_tpr = find(fpr_lr == 0.16);
```

Using the code to find the location in the array the FPR Naïve Bayes classifiers and LR classifiers is 0.16\. And using the same location to find each classifiers TPR.

- When the Naïve Bayes classifiers' FPR is 0.16, the maximum TPR is 0.64.
- When the LR classifiers' FPR is 0.16, the maximum TPR is 0.60.

So Naïve Bayes classifier is preferabled because maximum TPR is better.
