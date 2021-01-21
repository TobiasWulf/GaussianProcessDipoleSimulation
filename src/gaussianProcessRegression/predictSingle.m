%% predictSingle
% Predicts single
function [predMean, predVar] = predictSingle(XtestCos, XtestSin, ...
    XtrainCos, XtrainSin, offset, H, L, alpha, beta, theta, feature)
    
    % compute covariance between observations and test point
    kx = quadraticFrobeniusCovariance(XtrainCos, XtestCos, ...
        XtrainSin, XtestSin, theta);
    
    % compute the mean feature vector of test point
    switch feature
        case 'atan2'
            h = featureAtan2(XtestCos, XtestSin, offset);
        case 'cos'
            h = featureMean(XtestCos);
        case 'sin'
            h = featureMean(XtestSin);
        otherwise
            h = 0;
    end
    
    % compute the predictive mean
    predMean = h' * beta + kx' * alpha;
    
    % compute the covariance of test point itself
    kxx = quadraticFrobeniusCovariance(XtestCos, XtestCos, ...
        XtestSin, XtestSin, theta);
    
    % compute inverse matrix product v of KxT * Ky^-1 * Kx
    kxy = computeTransposeInverseProduct(L, kx);
    
    % compute predictive variance restriction RT * (H * Ky^-1 * HT)^-1 * R
    % with R = h - H * Ky^-1 * Kx
    R = h - H * computeInverseMatrixProduct(L, kx);
    
    % and A = H * Ky^-1 * HT
    A = computeTransposeInverseProduct(L, H');
    
    % both side inverse product khxy = RT * A^-1 * R
    L1 = chol(A, 'lower');
    khxy = computeTransposeInverseProduct(L1 , R);
    
    
    % compute predictiv variance as the difference between test point covariance
    % product of the covariance between observations and test points and the
    % noisy covariance matrix + a feature variance between test point and
    % observation
    % (kxx) - (kxT * Ky^-1 * kx) + (RT * (H * Ky^-1 * HT)^-1 * R)
    predVar = kxx - kxy + khxy;
end

