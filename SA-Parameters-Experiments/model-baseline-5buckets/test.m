function [cm, maxfscore, threshold] = test(data, x, thresholds, likeprob)
    m = length(data);
    % confusion matrices - actual in rows and predicted in columns
    cm = zeros(2, 2, length(thresholds));
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        b1 = x(u1);
        b2 = x(u2);
        p = likeprob(b1, b2);
        action = line(3);
        for j = 1:length(thresholds)
            threshold = thresholds(j);
            pred = (p > threshold);
            cm(action+1, pred+1, j) = cm(action+1, pred+1, j) + 1;
        end
    end    
    
    tp = cm(2, 2, :);
    fp = cm(1, 2, :);
    fn = cm(2, 1, :);
    precision = tp ./ (tp + fp);
    recall = tp ./ (tp + fn);
    %     beta = 0.5;
    fscores = (1.5 .* precision .* recall) ./ (0.5*precision + recall);
    [maxfscore, maxidx] = max(fscores);
    threshold = thresholds(maxidx);
