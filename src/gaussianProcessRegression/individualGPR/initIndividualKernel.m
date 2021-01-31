%% initIndividualKernel
% Init individual GPR model on current kernel parameters, computes covariance
% matrix and depending kernel values.
%

function Mdl = initIndividualKernel(Mdl)
    % compute covariance matrix in two steps first without noise
    KfCos = Mdl.kernel(Mdl.Xcos, Mdl.Xcos, Mdl.Xsin, Mdl.Xsin, Mdl.thetaCos);
    %KfSin = Mdl.kernel(Mdl.Xcos, Mdl.Xcos, Mdl.Xsin, Mdl.Xsin, Mdl.thetaSin);
    
    % second step add noise
    Mdl.KyCos = addNoise2Covariance(KfCos, Mdl.s2nCos);
    %Mdl.KySin = addNoise2Covariance(KfSin, Mdl.s2nSin);
    
    % decompose Ky and get lower trinagle matrix and log determinate
    [Mdl.Lcos, Mdl.logDetCos] = decomposeChol(Mdl.KyCos);
    %[Mdl.Lsin, Mdl.logDetSin] = cholDecomposeA2L(Mdl.KySin);
    
    % compute feature matrix
    Mdl.Hcos = Mdl.feature(Mdl.Xcos);
    Mdl.Hsin = Mdl.feature(Mdl.Xsin);
    
    % compute beta coefficients to fit feature matrix
    Mdl.betaCos = estimateBeta(Mdl.Hcos, Mdl.Lcos, Mdl.Ycos);
    %Mdl.betaSin = estimateBeta(Mdl.Hsin, Mdl.Lsin, Mdl.Ysin);
    Mdl.betaSin = estimateBeta(Mdl.Hsin, Mdl.Lcos, Mdl.Ysin);
    
    % compute weights for cosine and sine
    Mdl.Acos = computeAlphaWeights(Mdl.Lcos, Mdl.Ycos, Mdl.Hcos, Mdl.betaCos);
    %Mdl.Asin = computeAlphaWeights(Mdl.Lsin, Mdl.Ysin, Mdl.Hsin, Mdl.betaSin);
    Mdl.Asin = computeAlphaWeights(Mdl.Lcos, Mdl.Ysin, Mdl.Hsin, Mdl.betaSin);
    
    % compute log likelihoods for each cosine and sine
    Mdl.LMLcos = computeLogLikelihood(Mdl.Ycos, Mdl.Hcos, Mdl.betaCos, ...
        Mdl.Acos, Mdl.logDetCos, Mdl.N);
    %Mdl.LMLsin = computeLogLikelihood(Mdl.Ysin, Mdl.Hsin, Mdl.betaSin, ...
    %    Mdl.Asin, Mdl.logDetSin, Mdl.N);
    Mdl.LMLsin = computeLogLikelihood(Mdl.Ysin, Mdl.Hsin, Mdl.betaSin, ...
        Mdl.Asin, Mdl.logDetCos, Mdl.N);
end

