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
H = featureFunction(Xcos, Xsin);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the product of an inverted matrix K^-1 and a vector y to get a weight
% vector alpha by solving the linear system by cholesky decomposed lower
% triangle matrix L of matrix K.
function alpha = computeInverseMatrixProduct(L, y)
    opts1.LT = true;
    opts2.UT = true;
    alpha = linsolve(L, y, opts1);
    alpha = linsolve(L', alpha , opts2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the Cholesky decomposition of a symmetrix positive definite matrix A
% and calculate the log determinate as side product of the decomposition. 
% Compute the lower triangle matrix L.
function [L, logDet] = cholDecomposeA2L(A)
    [L, flag] = chol(A, 'lower');
    assert(flag == 0);
    logDet = 2 * sum(log(diag(L)));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mean function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of atan2 function.
function H = featureFunction(Xcos, Xsin)
    assert(all(size(Xcos) == size(Xsin)));
    [D1, D2, N] = size(Xcos);
    H = zeros(D1 * D2, N);
    for n = 1:N
        h = atan2(Xsin(:,:,n), Xcos(:,:,n));
        H(:, n) = h(:);
    end
    H = [ones(1,N); H];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add noise to covarianc matrix for noisy observations. Add noise along matrix
% diagonal.
function Ky = addNoise2Covariance(K, sigma2N)
    Ky = K + sigma2N * eye(size(K));
end

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
% test to each training observation. Computes noise free covariances.
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
% helper function to convert angles (rad or degree) to sinus and cosinus waves
% using built in functions cos, and sin, compute with amplitude scale
% factor and which gives the posibility to scale to one, additional returns
% angles in rad if passed in degree and differences to sinus and cosinus if
% compare vectors for each is passed, it is also posible to multiple the periods
% of given angles by period factor.
% varargout 1: angles in rad
% varargout 2: sinus diff
% varargout 3: cosinus diff
function [sinus, cosinus, varargout] = angles2sinoids(angles, rad, amp, pf, namedargs)
    arguments
        % validate angles and origins as row vectors of same length
        angles (1,:) double {mustBeVector, mustBeReal}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate amplitude vector as real scalar factor with default 1
        amp (1,1) double {mustBeReal} = 1
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        namedargs.sinus (1,:) double {mustBeReal, mustBeEqualSize(angles, namedargs.sinus)}
        namedargs.cosinus (1,:) double {mustBeReal, mustBeEqualSize(angles, namedargs.cosinus)}
    end
    
    % if rad flag is false and angles in degree convert to rad
    if ~rad, angles = angles * pi / 180; end
    
    % calculate sinoids
    sinus = amp * sin(pf * angles);
    cosinus = amp * cos(pf * angles);
    
    % angles in rad
    if nargout > 2
        varargout{1} = angles;
    end
    % sinus difference
    if nargout > 3
        if isfield(namedargs, 'sinus')
            varargout{2} = diff([sinus; namedargs.sinus], 1, 1);
        else
            varargout{2} = NaN(1, length(angles));
        end
    end
    % cosinus difference
    if nargout > 4
        if isfield(namedargs, 'cosinus')
            varargout{3} = diff([cosinus; namedargs.cosinus], 1, 1);
        else
            varargout{3} = NaN(1, length(angles));
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% helper function to convert sinus and cosinus values to rad or degree angles
% in compare to origin angular reference, atan2 built and correct negative
% angles along 2pi scale to unwrap atan2 result respective to full rotation
% returns angles in rad and converts origin from degrees to rad if needed
% Origin: Jünemann, Added: Wulf (argument validation, rad flag)
% namedargs: origin: origin angles
% varargout 1: anglesDiff
% varargout 2: originRad
function [angles, varargout] = sinoids2angles(sinus, cosinus, rad, pf, namedargs)
    arguments
        % validate sinus, cosinus and origin as row vectors of the same length
        sinus (1,:) double {mustBeVector, mustBeReal}
        cosinus (1,:) double {mustBeReal, mustBeEqualSize(sinus, cosinus)}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        % validate angles origin as vector of same length as sinoids
        namedargs.origin (1,:) double {mustBeReal, mustBeEqualSize(cosinus, namedargs.origin)}
    end
    
    % convert sinoids vector componets to rad angles, atan2 provides angles
    % btween 0° and 180° and abstracts angles between 180° and  360° to negative
    % quadrant from -180 to 0°
    angles = atan2(sinus, cosinus);
    
    % correct angles from 0° to 360° (0 to 2pi) with period factor if multiple
    % periods abstarcts angles between 0° and 360°
    angles = unwrap(angles) / pf;
    
        
    % calculate difference to origin angular reference
    if nargout > 1
        if isfield(namedargs, 'origin')
            % convert to rad if rad flag is false
            if ~rad, namedargs.origin = namedargs.origin * pi / 180; end
            % claculate difference
            anglesDiff = diff([namedargs.origin; angles], 1, 1);
            % ensure calculated difference matches interval
            idx = anglesDiff > pi;
            anglesDiff(idx) = anglesDiff(idx) - 2 * pi;
            idx = anglesDiff < -pi;
            anglesDiff(idx) = anglesDiff(idx) + 2 * pi;
            varargout{1} = anglesDiff;
        else
            varargout{1} = NaN(1, length(angles));
        end
    end
    
    % origin in rad if passed in degree, converted in nargout > 1, ~rad
    if nargout > 2
        if isfield(namedargs, 'origin')
            varargout{2} = namedargs.origin;
        else
            varargout{2} = NaN(1, length(angles));
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