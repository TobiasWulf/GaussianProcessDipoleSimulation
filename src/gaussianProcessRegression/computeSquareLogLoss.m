%% computeSquareLogLoss
% Compute SLL loss between test targets and predictive mean dependend on
% predictive variance of each predictive mean and used sigma2N in prediction.
%
function [L, SE] = computeSquareLogLoss(y, fmean, fcov, s2n)
    
    s2x = 2 * (fcov + s2n);
    SE = (y - fmean) .^ 2;
    
    L = 0.5 * log(pi * s2x) + SE ./ s2x;
end

