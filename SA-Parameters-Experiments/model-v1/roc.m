function [ncorr, cmMF, cmFM] = roc(data, x)
    m = length(data);
    k = 101;
    thresholds = linspace(0, 1, k);
    ncorr = zeros(1,k);
    % confusion matrices - actual in rows and predicted in columns
    cmMF = zeros(2, 2, k);
    cmFM = zeros(2, 2, k);
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        g1 = line(4);
        s = x(u1, 1);
        a = x(u2, 2);
        p = logsig(s*a);
        action = line(3);
        for j = 1:k
            threshold = thresholds(j);
            pred = (p > threshold);
            if action == pred
                ncorr(j) = ncorr(j) + 1;
            end
            if g1
                cmMF(action+1, pred+1, j) = cmMF(action+1, pred+1, j) + 1;
            else
                cmFM(action+1, pred+1, j) = cmFM(action+1, pred+1, j) + 1;
            end
        end
    end    
    prMF = cmMF(:, 2, :) ./ sum(cmMF, 2);
    fprMF = squeeze(prMF(1,1,:));
    tprMF = squeeze(prMF(2,1,:));
    plot(fprMF, tprMF, 'b-*'); 
    text(fprMF, tprMF, num2str(thresholds'));
    
    hold on
    prFM = cmFM(:, 2, :) ./ sum(cmFM, 2);
    fprFM = squeeze(prFM(1,1,:));
    tprFM = squeeze(prFM(2,1,:));
    plot(fprFM, tprFM, 'r-*'); 
    text(fprFM, tprFM, num2str(thresholds'));
    
    acc = ncorr / m;
    plot(thresholds, acc, 'c-x');
    hold off
    
    legend('ROC M->F', 'ROC F->M', 'accuracy vs threshold','Location','east');