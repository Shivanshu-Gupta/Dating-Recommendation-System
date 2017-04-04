traindata = csvread('data/train.csv');
testdata = csvread('data/test.csv');
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
x0 = initParams(traindata, n);

% optimize parameters
options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'Display', 'iter');
C = 8;
func = @(x) reg_LL(traindata, x, C);
x = fminunc(func, x0, options);

% test Params
[acc, confMatrixMF, confMatrixFM] = test_sa(testdata, x);

% user parameters:
userParams = [users';x']';
maleParams = userParams(userParams(:,2) == 1, 3:5);
femaleParams = userParams(userParams(:,2) == 0, 3:5);

% stats
male_mean = mean(maleParams(:, 2:3));
female_mean = mean(femaleParams(:, 2:3));
male_std = std(maleParams(:, 2:3));
female_std = std(femaleParams(:, 2:3));