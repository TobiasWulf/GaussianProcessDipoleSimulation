% Created on January 06. 2021 by Tobias Wulf. Tobias Wulf 2021.
% start script
clearvars
clc
close all

% load data files
load config.mat PathVariables
trainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
testFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
trainDS = load(fullfile(trainFiles(1).folder, trainFiles(1).name));
testDS = load(fullfile(testFiles(1).folder, testFiles(1).name));

% M number of sensor array members
M = trainDS.Info.SensorArrayOptions.SensorCount;

% N number of angles
N = trainDS.Info.UseOptions.nAngles;

% voltages, offset and bridge outputs
Voff = trainDS.Info.SensorArrayOptions.Voff;
VcosTrain = trainDS.Data.Vcos;
VsinTrain = trainDS.Data.Vsin;
VcosTest = testDS.Data.Vcos;
VsinTest = testDS.Data.Vsin;

% angles in training and test data (column vectors)
refTrainDeg = trainDS.Data.angles';
refTrainRad = refTrainDeg * pi/180;
refTrainCos = cos(refTrainRad);
refTrainSin = sin(refTrainRad);
refTestDeg = testDS.Data.angles';
refTestRad = refTestDeg * pi/180;
refTestCos = cos(refTestRad);
refTestSin = sin(refTestRad);

% reshape training and test data to fit gp model N rows and M columns
XCTrain = zeros(N,M);
XSTrain = zeros(N,M);
%XATrain = zeros(N,M);
for n = 1:N
    XCTrain(n,:) = reshape(VcosTrain(:,:,n),1,M) - Voff;
    XSTrain(n,:) = reshape(VsinTrain(:,:,n),1,M) - Voff;
end
%for m=1:M
%    XATrain(:,m) = refTrainRad;
%end    

% apply atan2 on training data and unwrap
XATrain = unwrap(atan2(XSTrain,XCTrain), [], 1);


% build GP with best fit kernel for atan2
%kernelS = char(BOS.XAtMinObjective.KernelFunction);
%sigmaS = BOS.XAtMinObjective.Sigma;
gpA = fitrgp(XATrain, refTrainRad, ...
    'DistanceMethod', 'accurate', 'Verbose', 1);

% predict test inputs for cosinus and sinus
predA = zeros(length(refTestRad), 1);
for n = 1:length(refTestCos)
    XCTest = reshape(VcosTest(:,:,n),1,M) - Voff;
    XSTest = reshape(VsinTest(:,:,n),1,M) - Voff;
    XATest = atan2(XSTest,XCTest);
    i = XATest < 0;
    XATest(i) = XATest(i) + 2*pi;
    %if n > 360, XATest = XATest + 2*pi;end
    predA(n) = predict(gpA, XATest);
end

