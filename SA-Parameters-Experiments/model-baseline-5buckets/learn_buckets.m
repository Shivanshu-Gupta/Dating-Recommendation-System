function [x, b] = learn_buckets(x, data, likeprob)
    m = length(data);
    for k = 1:10
        for i = 1:m
                line = data(i, :);
                u1 = line(1);
                u2 = line(2);
                action = line(3);
                    
                if rem(k, 2)
                    if action
                        x(u2, :) = (x(u1,:) * likeprob) .* x(u2, :);
                    else
                        x(u2, :) = (x(u1,:) * (1-likeprob)) .* x(u2, :);
                    end
                    x(u2, :) = x(u2, :)/sum(x(u2, :));
                else
                    if action
                        x(u1, :) = (x(u2,:) * likeprob') .* x(u1, :);
                    else
                        x(u1, :) = (x(u2,:) * (1-likeprob)') .* x(u1,:);
                    end
                    x(u1, :) = x(u1, :)/sum(x(u1, :));
                end
        end
    end
    [p, b] = max(x, [], 2);
end