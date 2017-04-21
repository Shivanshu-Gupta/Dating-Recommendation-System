function [f, g] = reg_LL(data, x, C)
%   computes objective function and it's gradient with 
%   given parameters.
%   objective function = - (log-likelihood - regularizer)
%   probability-function = sigmoid(s*a)

    m = length(data);
    f = 0;
    g = zeros(size(x));
    
    % compute log-likelihood and it's gradient
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        action = line(3);
        s = x(u1);
        a = x(u2);
        if action
            p = logsig(s*a);
            f = f - log(p);
            g(u1) = g(u1) - (1 - p) * a;
            g(u2) = g(u2) - (1 - p) * s;
        else
            p = logsig(-s*a);
            f = f - log(p);
            g(u1) = g(u1) + (1 - p) * a;
            g(u2) = g(u2) + (1 - p) * s;
        end
    end
    
    % add regularizer
    g = g + 2 * C * x;
    f = f + C * sum(sum((x .* x)));

%     disp(-f);