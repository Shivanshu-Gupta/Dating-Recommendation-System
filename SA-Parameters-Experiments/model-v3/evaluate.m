function [params, threshold, maxfscore] = evaluate(traindataFM, valdataFM, C, theta)
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
    
    thresholds = linspace(0, 0.4, 41);
    [cmFM] = test_sa(valdataFM, xFM, theta, thresholds);
    tp = cmFM(2, 2, :);
    fp = cmFM(1, 2, :);
    fn = cmFM(2, 1, :);
    precision = tp ./ (tp + fp);
    recall = tp ./ (tp + fn);
%     beta = 0.5;
    params = {xFM};
    fscores = (1.5 .* precision .* recall) ./ (0.5*precision + recall);
    [maxfscore, maxidx] = max(fscores);
    threshold = thresholds(maxidx);