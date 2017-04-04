function [ncorr, mf, fm] = test_baseline1(data)
%   predicts likes from males and hides from females
    m = length(data);
    ncorr = 0;
    mf = zeros(1,2);
    fm = zeros(1,2); 
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        like = line(3);
        g1 = line(4);
        g2 = line(5);
        if g1 && like || ~g1 && ~like
            ncorr = ncorr + 1;
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
    