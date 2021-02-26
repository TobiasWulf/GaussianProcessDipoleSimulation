% Created on January 11. 2021 by Tobias Wulf. Tobias Wulf 2021.
% start script
%clearvars
clc
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data files with training observations and test data for a full
% rotation

load config.mat PathVariables GPROptions
TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init GPR model
Mdl1 = initGPR(TrainDS, GPROptions);

% tune kernel
Mdl2 = tuneKernel(Mdl1, 0);

Mdl3 = optimGPR(TrainDS, TestDS, GPROptions, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predict angles in rads not in degrees
[fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl3, TestDS);

% compute log losses and squared erros
% AAED - Absolute Angular Error in Degrees
% SLLA - Squared Log Loss Angular
% SLLR - Squared Log Loss Radius
% SEA  - Squared Error Angular
% SER  - Squared Error Radius
% SEC  - Squared Error Cosine
% SES  - Squared Error Sine
[AAED, SLLA, SLLR, SEA, SER, SEC, SES] = lossDS(Mdl3, TestDS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
