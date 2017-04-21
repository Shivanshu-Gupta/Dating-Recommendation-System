% Driver code for SA Model v2

traindata = csvread('../data/train.csv');
testdata = csvread('../data/test.csv');
m = length(traindata);
% data format: 
% 1, 2: user indexes
% 3: action
% 4, 5: genders
% 6, 7: buckets
% 8, 9: user ids

% unique users
[C, ia] = unique(traindata(:, 1));
users = traindata(ia, [1,4,8]);
n = length(users);

% initialize parameters
[ x0MF, x0FM ] = initParams(n);

% optimize parameters
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'Display', 'iter');

C = 1;
% Male -> Female
traindataMF = traindata(traindata(:, 4) == 1, :);
func = @(x) reg_LL(traindataMF, x, C);
xMF = fminunc(func, x0MF, options);
testdataMF = testdata(testdata(:, 4) == 1, :);
[ncorrMF, confMatrixMF] = test_sa(testdataMF, xMF);
disp(ncorrMF);

% Female -> Male
traindataFM = traindata(traindata(:, 4) == 0, :);
func = @(x) reg_LL(traindataFM, x, C);
xFM = fminunc(func, x0FM, options);
testdataFM = testdata(testdata(:, 4) == 0, :);
[ncorrFM, confMatrixFM] = test_sa(testdataFM, xFM);
disp(ncorrFM);

% user parameters:
males = users(:, 2) == 1;
maleParams = [users(males, 3)'; xMF(males)'; xFM(males)']';
females = users(:, 2) == 0;
femaleParams = [users(females, 3)'; xFM(females)'; xMF(females)']';

% stats
male_mean = mean(maleParams(:, 2:3));
female_mean = mean(femaleParams(:, 2:3));
male_std = std(maleParams(:, 2:3));
female_std = std(femaleParams(:, 2:3));