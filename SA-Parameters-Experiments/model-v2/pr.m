function [acc, cm, precision, recall] = pr(data, x)
%   fpr = fp / (tn + fp) = fp / actual -ves = fall-out = 1 - specificity
%   tpr = tp / (tp + fn) = tp / actual +ves = sensitivity, recall
%   precision = tp / (tp + fp) = tp / predicted +ves

    m = length(data);
    k = 101;
    thresholds = linspace(0, 1, k);
    ncorr = zeros(1,k);
    % confusion matrices - actual in rows and predicted in columns
    cm = zeros(2, 2, k);
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        s = x(u1);
        a = x(u2);
        p = logsig(s*a);
        
        action = line(3);
        for j = 1:k
            threshold = thresholds(j);
            pred = (p > threshold);
            if action == pred
                ncorr(j) = ncorr(j) + 1;
            end
            cm(action+1, pred+1, j) = cm(action+1, pred+1, j) + 1;
        end
    end
    tp = squeeze(cm(2, 2, :));
    fp = squeeze(cm(1, 2, :));
    fn = squeeze(cm(2, 1, :));
    precision = tp ./ (tp + fp);
    recall = tp ./ (tp + fn);
    acc = ncorr / m;
    
    plot(recall, precision, '-o');
    %text(recall, precision, num2str(thresholds'));
    legend('Precision-Recall','Location','east');
    xlabel('recall');
    ylabel('precision');