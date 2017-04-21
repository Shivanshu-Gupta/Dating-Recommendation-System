function [ x0 ] = initParams( traindata, n, type )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    if type == 1
        m = length(traindata);
        x0 = ones(n, 2);
        total = ones(n ,2);
        for i = 1:m
            line = traindata(i, :);
            u1 = line(1);
            u2 = line(2);
            like = line(3);
            if like
                x0(u1, 1) = x0(u1, 1) + 1;
                x0(u2, 2) = x0(u2, 2) + 1;
            end
            total(u1, 1) = total(u1, 1) + 1;
            total(u2, 2) = total(u2, 2) + 1;
        end
        x0 = x0 ./ total;
    elseif type == 2
        x0 = -1 + 2 * rand(n, 2);
    end
end

