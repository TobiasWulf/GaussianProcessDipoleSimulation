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
beta = D / trainDS.Data.angleStep;
off = trainDS.Info.SensorArrayOptions.Voff;
Xcos = trainDS.Data.Vcos;
Xsin = trainDS.Data.Vsin;

% angles in training and test data (column vectors)
ydeg = trainDS.Data.angles';
yrad = ydeg * pi/180;
ycos = cos(yrad);
ysin = sin(yrad);

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
opts2.UT = false;
alphaCos = linsolve(L', linsolve(L, ycos - squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta, opts1), opts2);
alphaSin = linsolve(L', linsolve(L, ysin - squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta, opts1), opts2);
alphaTan = linsolve(L', linsolve(L, unwrap(atan2(ysin, ycos)) - unwrap(atan2(squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta, squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta)), opts1), opts2);
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
lmllCos = -0.5 * ((ycos - squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta)' * alphaCos + logDetKy + N * log(2 * pi));
lmllSin = -0.5 * ((ysin - squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta)' * alphaSin + logDetKy + N * log(2 * pi));
lmllTan = -0.5 * ((unwrap(atan2(ysin, ycos)) - unwrap(atan2(squeeze(mean(Xsin, 2) - off)' * ones(D,1) * beta, squeeze(mean(Xcos, 2) - off)' * ones(D,1) * beta)))' * alphaSin + logDetKy + N * log(2 * pi));

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
    fMeanCos(n) = (mean(XtestCos, 1) - off) * ones(D,1) * beta + kx' * alphaCos;
    fMeanSin(n) = (mean(XtestSin, 1) - off) * ones(D,1) * beta + kx' * alphaSin;
    hTbeta = atan2((mean(XtestSin, 1) - off) * ones(D,1) * beta, (mean(XtestCos, 1) - off) * ones(D,1) * beta);
    fMeanTan(n) =  hTbeta+ kx' * alphaTan;

    % compute predictive variance
    opts.LT = true;
    v = linsolve(L, kx, opts);
    kxx = quadraticFrobeniusCovariance(XtestCos, XtestCos, ...
        XtestSin,  XtestSin,...
        [sigma2F, sigmaL]);
    Vf(n) = kxx - v' * v;
end




%VcosTest = testDS.Data.Vcos;
%VsinTest = testDS.Data.Vsin;

%refTestDeg = testDS.Data.angles';
%refTestRad = refTestDeg * pi/180;
%refTestCos = cos(refTestRad);
%refTestSin = sin(refTestRad);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kernel, covariance function for 3 dimensional matrices DxDxN where N is
% the dimension of observeration and DxD is a matrix of P predictors at
% each observation. Each for cosine and sine observation. It is needed to
% establish a combined kernel function because cosine and sine function are
% not independent from each and another. They are a separated
% representation of same tangent angle one the unit circle so each
% predictor variance should be additive correalate in each cosine and sine
% representation. Cosine and sine are orthogonal vectors of the same
% system. Therfore the Matrix norm aims the distance of the tangence function
% decomposed as vector field norm of its orthoganl components as sum of two
% matrix norm represented by a norm of cosine and sine.
% The sensor array implements the predictors in a square array shape so it
% is needed to norm the distances between observations with matrix norm and
% with eucledian norms which distances between points. So it is possible to
% the quadratic Frobeniusnorm to norm matrices distance.
% Quadratic to ommit complex values in results.
% In fact the kernel or covariance function is a sum of 2 quadratic
% frobenius norm distances each for cosine and sine for n-th observation
% with same length scale sigmaL and variance sigmaF2 to engage the
% dependency of cosine and sine orthogonality.
% The function must be producing a NxN positive symmetric covariance matrix
% K in the training phase to apply cholesky decomposition on it to compute
% the inverse of the matrix and solve the linear system to generates alpha
% vectors for cosine and sine prediction each. In the prediction phase
% (applicationt) it computes the MxN matrix K for test inputs of size DxDxM
% and training points size of DxDxN. If it is a single test point so DxDx1
% matrix the function computes the covariance vector of size 1xN of the
% test to each training observation. 
function K = quadraticFrobeniusCovariance(XcosM, XcosN, XsinM, XsinN, params)
    arguments
        % validate matrices as real numeric 3D matrices of equal sizes
        XcosM (:,:,:) double {mustBeReal}
        XcosN (:,:,:) double {mustBeReal}
        XsinM (:,:,:) double {mustBeReal, mustBeEqualSize(XcosM, XsinM)}
        XsinN (:,:,:) double {mustBeReal, mustBeEqualSize(XcosN, XsinN)}
        % validate params as two element vector
        params (1,2) double {mustBeReal, mustBeVector}
    end
    
    % get number of observations for each dataset, cosine and sine matrices have
    % equal sizes just extract size from one
    [~, ~, M] = size(XcosM);
    [~, ~, N] = size(XcosN);
    
    % expand covariance parameters, variance and lengthscale
    sigma2F = params(1);
    sigmaL = params(2);
    
    % allocate memory for K
    K = zeros(M, N);
    
    % loop through observation points and compute the covariance for each
    % observation against another
    for m = 1:M
        for n = 1:N
            % get distance between m-th and n-th observation
            distCos = XcosM(:,:,m) - XcosN(:,:,n);
            distSin = XsinM(:,:,m) - XsinN(:,:,n);
            
            % compute quadratic frobenius norm of tan distance as separated
            % distances of cosine and sine, norm of vector fields
            r2 = sum(distCos .^ 2 , 'all') + sum(distSin .^ 2 , 'all');
            
            % engage lengthscale and variance on distance
            K(m,n) = sigma2F / (sigmaL + r2);
            
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom validation function to match matrix dimensions
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of sinus, cosinus and angles must be equal.';
        throwAsCaller(MException(eid,msg))
    end
end