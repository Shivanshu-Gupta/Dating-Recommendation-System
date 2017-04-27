function [maxfscore, bestCM, bestThreshold] = test_sa(data, x, theta, thresholds)
%   Test on a particular dataset and for given list of thresholds
%   Return the maximum Fscore, and the corresponding CM and threshold

    m = length(data);
    % confusion matrices - actual in rows and predicted in columns
    cm = zeros(2, 2, length(thresholds));
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        s = x(u1);
        a = x(u2);
        p = logsig(theta(1)*s + theta(2)*a + theta(3));
        action = line(3);
        for j = 1:length(thresholds)
            threshold = thresholds(j);
            pred = (p > threshold);
            cm(action+1, pred+1, j) = cm(action+1, pred+1, j) + 1;
        end
    end    
    
    %     beta = 0.5;
    [precision, recall, fpr, fscores] = metrics(cm, 0.5);
    [maxfscore, maxidx] = max(fscores);
    bestCM = cm(:, :, maxidx);
    bestThreshold = thresholds(maxidx);