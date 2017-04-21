function [ncorr, cmMales, cmFemales] = test_baseline(data)
%   predicts likes from males and hides from females
    m = length(data);
    ncorr = 0;
    % confusion matrices - actual in rows and predicted in columns
    cmMales = zeros(2);
    cmFemales = zeros(2);
    
    mf = zeros(1,2);
    fm = zeros(1,2); 
    for i = 1:m
        line = data(i, :);
        action = line(3);
        g1 = line(4);
        
        if g1
            pred = 1;
        else
            pred = 0;
        end
        
        if action == pred
            ncorr = ncorr + 1;
        end
        
        if g1
            cmMales(action+1, pred+1) = cmMales(action+1, pred+1) + 1;
        else
            cmFemales(action+1, pred+1) = cmFemales(action+1, pred+1) + 1;
        end
        
%         if g1 && like
%             mf(1) = mf(1) + 1;
%         elseif g1 && ~like
%             mf(2) = mf(2) + 1;
%         elseif ~g1 && like
%             fm(1) = fm(1) + 1;
%         else
%             fm(2) = fm(2) + 1;
%         end
    end
    