%% predZeroMeanGPR
% Predicts single test point of passed zero mean GPR model for served Xcos and
% Xsin values. Computes the predictive function mean and predictive function
% covariance.
%
function [fcos, fsin, fcov] = predZeroMeanGPR(Mdl, Xcos, Xsin)

    % compute the covarianc vector between test point and observations
    kx = Mdl.kernel(Mdl.Xcos, Xcos, Mdl.Xsin, Xsin, Mdl.theta);
    
    % compute the covariance of test point itself
    kxx = Mdl.kernel(Xcos, Xcos, Xsin, Xsin, Mdl.theta);
    
    % compute the predictive function mean for cosine and sine
    fcos = kx' * Mdl.Acos;
    fsin = kx' * Mdl.Asin;
    
    % compute the predictive function covariance as sum of the test point 
    % covarince and covarince restriction given by the covariance vector between
    % test point and observateion
    cr = computeTransposeInverseProduct(Mdl.L, kx);
    fcov = kxx + cr;
end

