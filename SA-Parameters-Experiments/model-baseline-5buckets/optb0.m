% Baseline model: 5 buckets
likeprob = [0.025243733, 0.045782111, 0.063459570, 0.096678369, 0.193405846;
    0.018001565, 0.035001175, 0.056133056, 0.081325301, 0.162897146;
    0.004072135, 0.027573529, 0.040943789, 0.061082955, 0.154015133;
    0.002338270, 0.022201228, 0.041695147, 0.068577277, 0.139406028;
    0.000000000, 0.023220974, 0.044173328, 0.067079463, 0.122183171];
traindataFM = csvread('../data/trainFM3.csv');
testdataFM = csvread('../data/testFM3.csv');
m = length(traindataFM);
% data format: 
% 1, 2: user indexes
% 3: action
% 4, 5: genders
% 6, 7: user ids
% 8, 9: true buckets

% unique users
[femaleidx, ia] = unique(traindataFM(:, 1));
[maleidx, ib] = unique(traindataFM(:, 2));
users = [traindataFM(ia, [1, 4, 6, 8]); traindataFM(ib, [2, 5, 7, 9])];

% sort the users by index
[ids, order] = sort(users(:,1));
users = users(order, :);

% learn buckets
n = length(users);
x0 = 0.2 * ones(n, 5);
[x, blearnt] = learn_buckets_b2(x0, traindataFM, likeprob);
bgold = zeros([n,1]);
bgold(femaleidx) = users(femaleidx, 4);
bgold(maleidx) = users(maleidx, 4);
bgold(bgold == 0) = blearnt(bgold == 0);

% testing
thresholds = linspace(0, 0.4, 41);
[maxfscore, bestcm, bestthreshold] = test(testdataFM, bgold, thresholds, likeprob);
