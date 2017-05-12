function [params, maxfscoreval, bestcmval, bestthresholdval] = evaluate(traindataFM, valdataFM, C, theta)
%   Learn parameters on a train dataset and 
%   return results of validation on validation dataset.
    
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
    mean = zeros([n, 1]);
    mean(maleidx) = -3.0837;
    mean(femaleidx) = -2.2394;
    std = zeros([n, 1]);
    std(maleidx) = 0.0770;
    std(femaleidx) = 0.1136;
    x0FM = mean;
    
    % optimize parameters
    options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'Hessian', 'on', 'Display', 'iter');

    % Female -> Male
    func = @(x) LLWithPrior(traindataFM(:, 1:3), x, mean, std, C, theta);
    xFM = fminunc(func, x0FM, options);
    params = {xFM};

    thresholds = linspace(0, 0.4, 41);
    [maxfscoreval, bestcmval, bestthresholdval] = test_sa(valdataFM, xFM, theta, thresholds);    