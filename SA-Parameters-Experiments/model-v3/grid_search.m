traindataFM = csvread('../data/trainFM1.csv');
valdataFM = csvread('../data/valFM1.csv');
testdataFM = csvread('../data/testFM1.csv');
m = length(traindataFM);

C = 2;
theta1 = linspace(-30, -10, 2);
theta2 = linspace(-30, -10, 2);
theta3 = linspace(10, 30, 2);
[T1, T2, T3] = ndgrid(theta1, theta2, theta3);
evalFunc = @(t1, t2, t3) evaluate(traindataFM, valdataFM, C, [t1, t2, t3]);
[params, thresholds, fscores] = arrayfun(evalFunc, T1, T2, T3);
[maxval1, minidx1] = max(fscores);
[maxval2, minidx2] = max(maxval1);
[maxval3, minidx3] = max(maxval2);
minidx = [minidx1(minidx2(minidx3)), minidx2(minidx3), minidx3];
bestTheta = [theta1(minidx(1)), theta2(minidx(2)), theta3(minidx(3))];
bestParams = cell2mat(params(minidx(1), minidx(2), minidx(3)));
bestThreshold = thresholds(minidx(1), minidx(2), minidx(3));
18363         946
         936         518