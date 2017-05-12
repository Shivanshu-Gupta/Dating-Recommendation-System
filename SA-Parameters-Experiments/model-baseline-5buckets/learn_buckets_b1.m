function [x, b] = learn_buckets_b1(x, data, bgold, likeprob)
    m = length(data);
    for k = 1:10
        for i = 1:m
                line = data(i, :);
                u1 = line(1);
                u2 = line(2);
                action = line(3);
                    
                if action
                    x(u2, :) = likeprob(bgold(u1), :) .* x(u2, :);
                else
                    x(u2, :) = (1 - likeprob(bgold(u1), :)) .* x(u2, :);
                end
                x(u2, :) = x(u2, :)/sum(x(u2, :));
        end
    end
    [p, b] = max(x, [], 2);
end