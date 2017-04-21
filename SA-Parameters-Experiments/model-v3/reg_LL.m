function [f, g, h] = reg_LL(data, x, C, theta)
%   computes objective function and it's gradient with 
%   given parameters.
%   objective function = - (log-likelihood - regularizer)
%   like probability = sigma(theta1*s + theta2*a + theta3)
    
    m = length(data);
    f = 0;
    g = zeros(size(x));
    h = zeros(size(x,1));
    
    % compute log-likelihood and it's gradient
    for i = 1:m
        line = data(i, :);
        u1 = line(1);
        u2 = line(2);
        action = line(3);
        s = x(u1);
        a = x(u2);
        if action
            p = logsig(theta(1)*s + theta(2)*a + theta(3));
            f = f - log(p);
            du1 = (1 - p) * theta(1);
            du2 = (1 - p) * theta(2);
            g(u1) = g(u1) - du1;
            g(u2) = g(u2) - du2;
            h(u1, u1) = h(u1, u1) + du1 * p * theta(1);
            h(u1, u2) = h(u1, u2) + du1 * p * theta(2);
            h(u2, u1) = h(u2, u1) + du2 * p * theta(1);
            h(u2, u2) = h(u2, u2) + du2 * p * theta(2);
%             g(u1) = g(u1) - (1 - p) * theta(1);
%             g(u2) = g(u2) - (1 - p) * theta(2);

        else
            p = logsig(-theta(1)*s - theta(2)*a - theta(3));
            f = f - log(p);
            du1 = (1 - p) * theta(1);
            du2 = (1 - p) * theta(2);
            g(u1) = g(u1) + du1;
            g(u2) = g(u2) + du2;
            h(u1, u1) = h(u1, u1) + du1 * p * theta(1);
            h(u1, u2) = h(u1, u2) + du1 * p * theta(2);
            h(u2, u1) = h(u2, u1) + du2 * p * theta(1);
            h(u2, u2) = h(u2, u2) + du2 * p * theta(2);
%             g(u1) = g(u1) + (1 - p) * theta(1);
%             g(u2) = g(u2) + (1 - p) * theta(2);
        end
    end
    
    % add regularizer
    f = f + C * sum(sum((x .* x)));
    g = g + 2 * C * x;
    h = h + 2 * C * eye(size(h));
%      disp(-f);