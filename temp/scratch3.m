% Created on January 13. 2021 by Tobias Wulf. Tobias Wulf 2021.
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
for n = 1:N
    XCTrain(n,:) = reshape(VcosTrain(:,:,n),1,M) - Voff;
    XSTrain(n,:) = reshape(VsinTrain(:,:,n),1,M) - Voff;
end


% define optimization variables for kernel and sigma (noise adjust)
kernel = optimizableVariable('KernelFunction', ...
    {'exponential','squaredexponential','matern32','matern52', ...
     'rationalquadratic','ardexponential','ardsquaredexponential', ...
     'ardmatern32','ardmatern52','ardrationalquadratic'},...
    'Type','categorical');

sigma = optimizableVariable('Sigma',[1e-4,10],'Transform','log');

% Call bayesopt, capturing the objective function
BO = bayesopt(@(T)objFcn(T, ...
    XCTrain,refTrainCos, ...
    XSTrain,refTrainSin, ...
    VcosTest,refTestCos, ...
    VsinTest,refTestSin, ...
    Voff), ...
    [sigma, kernel], ...
    ... 'AcquisitionFunctionName', 'expected-improvement-per-second', ...
    'MaxObjectiveEvaluations', 100);

% build GP with best fit kernel for cosinus and sinus
kernel = char(BO.XAtMinObjective.KernelFunction);
sigma = BO.XAtMinObjective.Sigma;
gpC = fitrgp(XCTrain, refTrainCos, 'KernelFunction', kernel, 'Sigma', sigma, ...
    'Verbose', 1);

gpS = fitrgp(XSTrain, refTrainSin, 'KernelFunction', kernel, 'Sigma', sigma, ...
    'Verbose', 1);

% predict test inputs for cosinus and sinus
predC = zeros(length(refTestCos), 1);
predS = zeros(length(refTestSin), 1);
for n = 1:length(refTestCos)
    XCTest = reshape(VcosTest(:,:,n),1,M) - Voff;
    predC(n) = predict(gpC, XCTest);
    XSTest = reshape(VsinTest(:,:,n),1,M) - Voff;
    predS(n) = predict(gpS, XSTest);
end

% calculate mean and max erros
ECOS = abs(predC - refTestCos);
ESIN = abs(predS - refTestSin);
EATAN2 = abs(unwrap(atan2(predS, predC) - refTestRad)) * 180 / pi;
MECOS = mean(ECOS);
XECOS = max(ECOS);
MESIN = mean(ESIN);
XESIN = max(ESIN);
MEATAN2 = mean(EATAN2);
XEATAN2 = max(EATAN2);

% plot errors
figure();
plot(ECOS);
xlabel('n');
ylabel('abs');
title(sprintf('Cos Error \\mu = %.3f, max = %.3f', MECOS, XECOS));

figure();
plot(ESIN);
xlabel('n');
ylabel('abs');
title(sprintf('Sin Error \\mu = %.3f, max = %.3f', MESIN, XESIN));

figure();
plot(EATAN2);
xlabel('n');
ylabel('abs [\circ]');
title(sprintf('Atan2 Error \\mu = %.3f^\\circ, max = %.3f^\\circ', MEATAN2, XEATAN2));

% save('temp/WS-scratch2.mat');

% function object to perform bayes optimazation on kernel and simga
function Loss = objFcn(Vars, xc, yc, xs, ys, xcc, ycc, xss, yss, off)
mc = fitrgp(xc, yc, 'KernelFunction', char(Vars.KernelFunction), ...
                 'Sigma', Vars.Sigma, 'ConstantSigma', true);

ms = fitrgp(xs, ys, 'KernelFunction', char(Vars.KernelFunction), ...
                 'Sigma', Vars.Sigma, 'ConstantSigma', true);
             
[M, ~, N] = size(xss);
ysp = zeros(N, 1);
ycp = zeros(N, 1);

for n = 1:N
    xsr = reshape(xss(:,:,n),1,M^2) - off;
    xcr = reshape(xcc(:,:,n),1,M^2) - off;
    ycp(n) = predict(mc, xcr);
    ysp(n) = predict(ms, xsr); 
end
Loss = max(abs(unwrap(atan2(yss,ycc)) - unwrap(atan2(ysp,ycp))));
end
