% Created on January 11. 2021 by Tobias Wulf. Tobias Wulf 2021.
% start script
clearvars
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data files with training observations and test data for a full
% rotation

load config.mat PathVariables
trainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
testFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
trainDS = load(fullfile(trainFiles(1).folder, trainFiles(1).name));
testDS = load(fullfile(testFiles(1).folder, testFiles(1).name));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load and get training dataset sizes and obersavation points

% D sensor array square dimension of DxD sensor array
D = trainDS.Info.SensorArrayOptions.dimension;

% P number of sensor array members (predictors)
P = trainDS.Info.SensorArrayOptions.SensorCount;

% N number of angles
N = trainDS.Info.UseOptions.nAngles;

% voltages, offset and bridge outputs and norm on angle resolution
beta1 = D / trainDS.Data.angleStep;
beta2 = D / trainDS.Data.angleStep;
off = trainDS.Info.SensorArrayOptions.Voff;
Xcos = trainDS.Data.Vcos;
Xsin = trainDS.Data.Vsin;

% angles in training and test data (column vectors)
ydeg = trainDS.Data.angles';
yrad = ydeg * pi/180;
switch trainDS.Info.UseOptions.BaseReference
    case 'KMZ60'
        pf = 2;
    otherwise
        pf = 1;
end
[ysin, ycos] = angles2sinoids(yrad, true, 1, pf);
ysin = ysin'; ycos = ycos';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute covariance matrix on training observations kernel parameters sigma2F
% as variance and sigmaL as lengthscale parameter. This is the noise free
% covariance matrix Kf.
sigma2F = 1;
sigmaL = D;
Kf = quadraticFrobeniusCovariance(Xcos, Xcos, Xsin, Xsin, [sigma2F, sigmaL]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Attach noise to noise free covariance matrix Kf to get noisy observation
% covariance matrix Ky with adding noise variance parameter sigma2N to diagonal
% of the noise free covariance matrix Kf. Begin with small noise values.
sigma2N = 0.00001;
Ky = Kf + sigma2N * eye(N);
assert(issymmetric(Ky));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the lower triangle matrix L of Ky and log determinat of Ky as diagonal
% sum of the lower triangle matrix times 2.
[L, success] = chol(Ky, 'lower');
% [R, success] = chol(Ky, 'upper');
% check on Ky was symmetric, positive, definite
assert(success == 0); 
logDetKy = 2 * sum(log(diag(L)));
% logDetKy = 2 * sum(log(diag(R)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve linear equation system to compute alpha weights for cosine and sine
% prediction with lower triangle matrix L. Do this in two steps for L with lower
% triangle matrix and as second transposed L as upper triangle matrix

% alphaCos = L' \ (L \ ycos);
% alphaSin = L' \ (L \ ysin);

opts1.LT = true;
opts2.UT = true;
alphaCos = linsolve(L', linsolve(L, ycos - squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta1, opts1), opts2);
alphaSin = linsolve(L', linsolve(L, ysin - squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta2, opts1), opts2);
alphaTan = linsolve(L', linsolve(L, atan2(ysin, ycos) - atan2(squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta2, squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta1), opts1), opts2);

% alphaCos = R \ (R' \ ycos);
% alphaSin = R \ (R' \ ysin);

% opts1.LT = true;
% opts2.UT = true;
% alphaCos = linsolve(R, linsolve(R', ycos, opts1), opts2);
% alphaSin = linsolve(R, linsolve(R', ysin, opts1), opts2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute log marginal likelihood for cosine and sine prediction each depended
% on the alpha weights.
lmllCos = -0.5 * ((ycos - squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta1)' * alphaCos + logDetKy + N * log(2 * pi));
lmllSin = -0.5 * ((ysin - squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta2)' * alphaSin + logDetKy + N * log(2 * pi));
lmllTan = -0.5 * ((atan2(ysin, ycos) - atan2(squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta2, squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta1))' * alphaTan + logDetKy + N * log(2 * pi));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load test datasets angle by angle and predict cosine and sine with additional
% variances of predictions

% get number of test points
Ntest = testDS.Info.UseOptions.nAngles;

% allocate memory for prediction results
fMeanCos = zeros(Ntest, 1);
fMeanSin = zeros(Ntest, 1);
fMeanTan = zeros(Ntest, 1);
Vf = zeros(Ntest, 1);

% predict angle by angle
for n = 1:Ntest
    % load test point for cosine and sine for n-th angle
    XtestCos = testDS.Data.Vcos(:,:,n);
    XtestSin = testDS.Data.Vsin(:,:,n);
    
    % compute covariance vector of test point to training observations
    kx = quadraticFrobeniusCovariance(Xcos, XtestCos, Xsin,  XtestSin,...
        [sigma2F, sigmaL]);
    
    % compute predictive mean for cosine and sine
    fMeanCos(n) = (mean(XtestCos, 1) - off) * ones(D,1) * beta1 + kx' * alphaCos;
    fMeanSin(n) = (mean(XtestSin, 1) - off) * ones(D,1) * beta2 + kx' * alphaSin;
    hTbeta = atan2((mean(XtestSin, 1) - off) * ones(D,1) * beta2, (mean(XtestCos, 1) - off) * ones(D,1) * beta1);
    fMeanTan(n) =  hTbeta+ kx' * alphaTan;

    % compute predictive variance
    opts.LT = true;
    v = linsolve(L, kx, opts);
    kxx = quadraticFrobeniusCovariance(XtestCos, XtestCos, ...
        XtestSin,  XtestSin,...
        [sigma2F, sigmaL]);
    Vf(n) = kxx - v' * v;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = featureAtan2(Xcos, Xsin);

L1 = cholDecomposeA2L(Ky);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
