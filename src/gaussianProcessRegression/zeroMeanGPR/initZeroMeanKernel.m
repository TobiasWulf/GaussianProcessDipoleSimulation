%% initZeroMeanKernel
% Init zero mean GPR model on current kernel parameters, computes covariance
% matrix and depending kernel values.
%

function Mdl = initZeroMeanKernel(Mdl)
    % compute covariance matrix in two steps first without noise
    Kf = Mdl.kernel(Mdl.Xcos, Mdl.Xcos, Mdl.Xsin, Mdl.Xsin, Mdl.theta);
    
    % second step add noise
    Mdl.Ky = addNoise2Covariance(Kf, Mdl.s2n);
    
    % decompose Ky and get lower trinagle matrix and log determinate
    [Mdl.L, Mdl.logDet] = cholDecomposeA2L(Mdl.Ky);
    
    % compute weights for cosine and sine
    Mdl.Acos = computeAlphaWeights(Mdl.L, Mdl.Ycos, 0, 0);
    Mdl.Asin = computeAlphaWeights(Mdl.L, Mdl.Ysin, 0, 0);
    
    % compute log likelihoods for each cosine and sine
    Mdl.LMLcos = computeLogLikelihood(Mdl.Ycos, 0, 0, Mdl.Acos, Mdl.logDet, ...
        Mdl.N);
    Mdl.LMLsin = computeLogLikelihood(Mdl.Ysin, 0, 0, Mdl.Asin, Mdl.logDet, ...
        Mdl.N);
end

