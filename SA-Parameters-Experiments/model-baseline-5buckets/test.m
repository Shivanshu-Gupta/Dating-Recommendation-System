function [maxfscore, bestcm, bestthreshold] = test(data, b, thresholds, likeprob)
    m = length(data);
    % confusion matrices - actual in rows and predicted in columns
    cm = zeros(2, 2, length(thresholds));
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);

        b1 = b(u1);
        b2 = b(u2);
        p = likeprob(b1, b2);
%         [p1, b1] = max(x(u1, :));
%         [p2, b2] = max(x(u2, :));
%         p = x(u1, :) * likeprob * x(u2)';

        action = line(3);
        for j = 1:length(thresholds)
            threshold = thresholds(j);
            pred = (p > threshold);
            cm(action+1, pred+1, j) = cm(action+1, pred+1, j) + 1;
        end
    end    
    
    [precision, recall, fpr, fscores] = metrics(cm, 0.5);
    [maxfscore, maxidx] = max(fscores);
    bestcm = cm(:, :, maxidx);
    bestthreshold = thresholds(maxidx);