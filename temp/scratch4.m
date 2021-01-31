% Created on January 11. 2021 by Tobias Wulf. Tobias Wulf 2021.
% start script
clearvars
clc
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data files with training observations and test data for a full
% rotation

load config.mat PathVariables GPROptions
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get number of test points
Ntest = testDS.Info.UseOptions.nAngles;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sigma2F = 1;
sigmaL = D;
sigma2N = 1e-5;
% theta = [sigma2F, sigmaL];
theta = [30.3711 100];
offset = [mean2(Xcos), mean2(Xsin)];
%offset = [off, off];

% yatan2 = atan2(ysin, ycos);
%y = [atan2(ysin, ycos); 0];

%Xcos = cat(3, Xcos, Xcos(:,:,1));
%Xsin = cat(3, Xsin, Xsin(:,:,1));

% HAtan2 = featureAtan2(Xcos, Xsin, offset);
% HCos = featureMean(Xcos);
% HSin = featureMean(Xsin);

Kf = quadraticFrobeniusCovariance(Xcos, Xcos, Xsin, Xsin, theta);

Ky = addNoise2Covariance(Kf, sigma2N);

[L, logDetKy] = decomposeChol(Ky);

% betaAtan2 = estimateBeta(HAtan2, L , yatan2);
% betaCos = estimateBeta(HCos, L , ycos);
% betaSin = estimateBeta(HSin, L , ysin);

% alphaAtan2 = computeAlphaWeights(L, yatan2, HAtan2, betaAtan2);
alphaCos = computeAlphaWeights(L, ycos, 0, 0);
alphaSin = computeAlphaWeights(L, ysin, 0, 0);

% logLikelihoodAtan2 = computeLogLikelihood(yatan2, HAtan2, betaAtan2, alphaAtan2, logDetKy, N);
logLikelihoodCos = computeLogLikelihood(ycos, 0, 0, alphaCos, logDetKy, N);
logLikelihoodSin = computeLogLikelihood(ysin, 0, 0, alphaSin, logDetKy, N);

% fMeanAtan2 = zeros(Ntest, 1);
% VfAtan2 = zeros(Ntest, 1);
fMeanCos = zeros(Ntest, 1);
VfCos = zeros(Ntest, 1);
fMeanSin = zeros(Ntest, 1);
VfSin = zeros(Ntest, 1);

% predict angle by angle
for n = 1:Ntest
    % load test point for cosine and sine for n-th angle
    XtestCos = testDS.Data.Vcos(:,:,n);
    XtestSin = testDS.Data.Vsin(:,:,n);
    
%     [fMeanAtan2(n), VfAtan2(n)] = predictSingle(XtestCos, XtestSin, ...
%     Xcos, Xsin, offset, HAtan2, L, alphaAtan2, betaAtan2, theta, 'atan2');

    [fMeanCos(n), VfCos(n)] = predictSingle(XtestCos, XtestSin, ...
    Xcos, Xsin, 0, 0, L, alphaCos, 0, theta, 'none');
    
    [fMeanSin(n), VfSin(n)] = predictSingle(XtestCos, XtestSin, ...
    Xcos, Xsin, 0, 0, L, alphaSin, 0, theta, 'none');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
