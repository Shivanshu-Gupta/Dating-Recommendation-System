% Driver code for SA Model v3

traindataFM = csvread('../data/trainFM2.csv');
testdataFM = csvread('../data/testFM2.csv');
m = length(traindataFM);
% data format: 
% 1, 2: user indexes
% 3: action
% 4, 5: genders
% 6, 7: user ids

% unique users
[femaleids, ia] = unique(traindataFM(:, 1));
[maleids, ib] = unique(traindataFM(:, 2));
users = [traindataFM(ia, [1, 4, 6]); traindataFM(ib, [2, 5, 7])];
n = length(users);

% initialize parameters
x0FM = -1 + 2 * rand([n, 1]);

% optimize parameters
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'Hessian', 'on', 'Display', 'iter');

C = 2;
theta = [-1 -1 0];
% Female -> Male
func = @(x) reg_LL(traindataFM(:, 1:3), x, C, theta);
xFM = fminunc(func, x0FM, options);
% [confMatrixFM] = test_sa(testdataFM, xFM, theta, 0.22);

% user parameters:
males = users(:, 2) == 1;
maleParams = [users(males, 3)'; xFM(males)']';
females = users(:, 2) == 0;
femaleParams = [users(females, 3)'; xFM(females)']';

% stats
male_mean = mean(maleParams(:, 2));
female_mean = mean(femaleParams(:, 2));
male_std = std(maleParams(:, 2));
female_std = std(femaleParams(:, 2));