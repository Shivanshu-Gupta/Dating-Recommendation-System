function [ncorr, cm] = test_sa(data, x)
    m = length(data);
    ncorr = 0;
    % confusion matrices - actual in rows and predicted in columns
    cm = zeros(2);
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        s = x(u1);
        a = x(u2);
        p = logsig(s*a);
        threshold = 0.5;
        pred = p > threshold;
        action = line(3);
        if action == pred
            ncorr = ncorr + 1;
        end
        
        cm(action+1, pred+1) = cm(action+1, pred+1) + 1;
    end    
