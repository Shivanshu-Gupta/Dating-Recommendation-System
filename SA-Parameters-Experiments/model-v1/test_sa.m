function [ncorr, cmMales, cmFemales] = test_sa(data, x)
    m = length(data);
    ncorr = 0;
    % confusion matrices - actual in rows and predicted in columns
    cmMales = zeros(2);
    cmFemales = zeros(2);
    
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        s = x(u1, 1);
        a = x(u2, 2);
        p = logsig(s*a);
        if p > 0.5
            pred = 1;
        else
            pred = 0;
        end
        
        action = line(3);
        if action == pred
            ncorr = ncorr + 1;
        end
        
        g1 = line(4);
        if g1
            cmMales(action+1, pred+1) = cmMales(action+1, pred+1) + 1;
        else
            cmFemales(action+1, pred+1) = cmFemales(action+1, pred+1) + 1;
        end
    end    
