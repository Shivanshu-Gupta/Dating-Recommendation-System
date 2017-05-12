function [ precision, tpr, fpr, fscores ] = metrics( cm, beta )
%METRICS calculate metrics for the given confusion matrices
%   Takes as input a list of confusion matrices and 
%   returns for each:
%   fall-out = fpr = fp / (tn + fp) = fp / actual -ves = 1-specificity
%   sensitivity, recall(r), tpr = tp / (tp + fn) = tp / actual +ves
%   precision(p) = tp / (tp + fp) = tp / predicted +ves
%   fscore = ((1 + b) * p * r) ./ (b*p + r);
    
    tn = cm(1, 1, :);
    fp = cm(1, 2, :);
    fn = cm(2, 1, :);
    tp = cm(2, 2, :);
    precision = tp ./ (tp + fp);
    tpr = tp ./ (tp + fn); recall = tpr;
    fpr = fp ./ (tn + fp);
    fscores = ((1+beta) .* precision .* recall) ./ ((beta)*precision + recall);
end

