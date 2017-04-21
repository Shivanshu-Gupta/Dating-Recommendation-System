function [ x0MF, x0FM ] = initParams(n)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
    
    x0MF = -1 + 2 * rand(n,1);
    x0FM = -1 + 2 * rand(n,1);
end

