% Driver code for SA Model v3

traindataFM = csvread('../data/trainFM3.csv');
testdataFM = csvread('../data/testFM3.csv');
m = length(traindataFM);
% data format: 
% 1, 2: user indexes
% 3: action
% 4, 5: genders
% 6, 7: user ids

% unique users
[femaleidx, ia] = unique(traindataFM(:, 1));
[maleidx, ib] = unique(traindataFM(:, 2));
users = [traindataFM(ia, [1, 4, 6]); traindataFM(ib, [2, 5, 7])];
n = length(users);

% initialize parameters
x0FM = -1 + 2 * rand([n, 1]);

% optimize parameters
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'Hessian', 'on', 'Display', 'iter');

C = 2;
theta = [-50 -50 0];
% Female -> Male
func = @(x) reg_LL(traindataFM(:, 1:3), x, C, theta);
xFM = fminunc(func, x0FM, options);
% [confMatrixFM] = test_sa(testdataFM, xFM, theta, 0.22);

% user parameters:
males = users(:, 2) == 1;
maleidx = users(males, 1);
maleParams = [maleidx'; users(males, 3)'; xFM(maleidx)']';
females = users(:, 2) == 0;
femaleidx = users(females, 1);
femaleParams = [femaleidx'; users(females, 3)'; xFM(femaleidx)']';

% stats
male_mean = mean(maleParams(:, 3));
female_mean = mean(femaleParams(:, 3));
male_std = std(maleParams(:, 3));
female_std = std(femaleParams(:, 3));