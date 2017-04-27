function [params, maxfscore, bestcm, bestthreshold] = evaluate(traindataFM, valdataFM, C, theta)
%   Learn parameters on a train dataset and 
%   return results of validation on validation dataset.
    
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

    % Female -> Male
    func = @(x) reg_LL(traindataFM(:, 1:3), x, C, theta);
    xFM = fminunc(func, x0FM, options);
    params = {xFM};

    thresholds = linspace(0, 0.4, 41);
    [maxfscore, bestcm, bestthreshold] = test_sa(valdataFM, xFM, theta, thresholds);    