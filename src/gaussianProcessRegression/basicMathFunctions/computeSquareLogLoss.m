%% computeSquareLogLoss
% Compute SLL loss between test targets and predictive mean dependend on
% predictive variance plus used variance for noisy covariance matrix as variance
% of normal distriubtion over predictive means s2 = fcov + s2n. The pred
% functions returns the standard deviation s so sqrt of the variance. 
%
function [SLL, SE, s2] = computeSquareLogLoss(y, fmean, s)
    
    % squared error
    SE = (y - fmean).^2;
    
    % s as standard deviation of nomal destributed fmean so square it for
    % variance.
    s2 = s.^2;
    
    % logaritmic error
    SLL = 0.5 * (log(2 * pi * s2) + SE ./ s2);
end

