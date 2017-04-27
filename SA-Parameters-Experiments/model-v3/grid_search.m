traindataFM = csvread('../data/trainFM3.csv');
valdataFM = csvread('../data/valFM3.csv');
testdataFM = csvread('../data/testFM3.csv');
m = length(traindataFM);

C = 2;
theta1 = linspace(0, 100, 11);
theta2 = linspace(0, 100, 11);
theta3 = linspace(-50, 50, 11);
[T1, T2, T3] = ndgrid(theta1, theta2, theta3);
evalFunc = @(t1, t2, t3) evaluate(traindataFM, valdataFM, C, [t1, t2, t3]);
[allparams, allfscores, allcm, allthresholds] = arrayfun(evalFunc, T1, T2, T3);
[maxFscore, maxidx] = max(allfscores(:));
[i1, i2, i3] = ind2sub(size(allfscores), maxidx);
bestTheta = [theta1(i1), theta2(i2), theta3(i3)];
bestParams = cell2mat(allparams(i1, i2, i3));
bestThreshold = allthresholds(i1, i2, i3);
bestCM = allcm(i1, i2, i3);
