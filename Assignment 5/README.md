# Assignment 5

## 1

- K = 2, cluster quality is 83.5.
- K = 3, cluster quality is 62.8.
- K = 4, cluster quality is 57.9.
- K = 5, cluster quality is 54.9.

As the K increase, the cluster quality decrease. When K equals to 2, the cluster gets its best quality which is 83.5.

## 2

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

## 3

Clustering accuracy improved after uncommenting

```matlab
X = meas; d = 4;
```

The **meas** has 150 rows and 4 columns.

Before uncommenting the code above.

```matlab
X = meas(:,1:2); d = 2;
```

The **X** takes the first two columns of **meas**.

Why???????????

## 4
