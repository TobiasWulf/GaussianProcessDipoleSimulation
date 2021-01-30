%% predIndividualGPR
% Predicts single test point of passed individual GPR model for served Xcos and
% Xsin values. Computes the predictive function mean and predictive function
% covariance.
%
function [fcos, fsin, fcovCos, fcovSin] = predIndividualGPR(Mdl, Xcos, Xsin)

    % compute the covarianc vector between test point and observations
    kxCos = Mdl.kernel(Mdl.Xcos, Xcos, Mdl.Xsin, Xsin, Mdl.thetaCos);
    %kxSin = Mdl.kernel(Mdl.Xcos, Xcos, Mdl.Xsin, Xsin, Mdl.thetaSin);
    
    % compute mean feature vector 
    hCos = Mdl.feature(Xcos);
    hSin = Mdl.feature(Xsin);
    
    % compute the covariance of test point itself
    kxxCos = Mdl.kernel(Xcos, Xcos, Xsin, Xsin, Mdl.thetaCos);
    %kxxSin = Mdl.kernel(Xcos, Xcos, Xsin, Xsin, Mdl.thetaSin);
    
    % compute the predictive function mean for cosine and sine
    fcos = hCos' * Mdl.betaCos + kxCos' * Mdl.Acos;
    %fsin = hSin' * Mdl.betaSin + kxSin' * Mdl.Asin;
    fsin = hSin' * Mdl.betaSin + kxCos' * Mdl.Asin;
    
    % compute the predictive function covariance as sum of the test point 
    % covarince and covarince restriction given by the covariance vector between
    % test point and observateion
    crCos = computeTransposeInverseProduct(Mdl.Lcos, kxCos);
    %crSin = computeTransposeInverseProduct(Mdl.Lsin, kxSin);
    fcovCos = kxxCos + crCos;
    %fcovSin = kxxSin + crSin;
    fcovSin =0;
end

