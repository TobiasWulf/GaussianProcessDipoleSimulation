% Created on January 11. 2021 by Tobias Wulf. Tobias Wulf 2021.
% start script
clearvars
clc
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data files with training observations and test data for a full
% rotation

load config.mat PathVariables
trainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
testFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
trainDS = load(fullfile(trainFiles(1).folder, trainFiles(1).name));
testDS = load(fullfile(testFiles(1).folder, testFiles(1).name));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get dataset sizes and obersavation points

% D sensor array square dimension of DxD sensor array
D = trainDS.Info.SensorArrayOptions.dimension;

% P number of sensor array members (predictors)
P = trainDS.Info.SensorArrayOptions.SensorCount;

% N number of angles
N = trainDS.Info.UseOptions.nAngles;

% voltages, offset and bridge outputs
%Voff = trainDS.Info.SensorArrayOptions.Voff;
Xcos = trainDS.Data.Vcos;
Xsin = trainDS.Data.Vsin;
%VcosTest = testDS.Data.Vcos;
%VsinTest = testDS.Data.Vsin;

% angles in training and test data (column vectors)
ydeg = trainDS.Data.angles';
yrad = ydeg * pi/180;
ycos = cos(yrad);
ysin = sin(yrad);
%refTestDeg = testDS.Data.angles';
%refTestRad = refTestDeg * pi/180;
%refTestCos = cos(refTestRad);
%refTestSin = sin(refTestRad);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kernel, covariance function for 3 dimensional matrices DxDxN where N is
% the dimension of observeration and DxD is a matrix of P predictors at
% each observation. Each for cosine and sine observation. It is needed to
% establish a combined kernel function because cosine and sine function are
% not independent from each and another. They are a separated
% representation of same tangent angle one the unit circle so each
% predictor variance should be additive correalate in each cosine and sine
% representation. Cosine and sine are orthogonal vectors of the same
% system.
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
