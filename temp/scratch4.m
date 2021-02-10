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
TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% init GPR model
Mdl = initGPR(TrainDS, GPROptions);

% tune kernel
Mdl = tuneKernel(Mdl);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% predict angles in rads not in degrees
[fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
