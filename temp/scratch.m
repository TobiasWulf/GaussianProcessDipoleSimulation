% clear and clean
clearvars
clc

% load path var
load config.mat PathVariables

% scan for training dataset
trainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));

% scan for test dataset
testFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));

% load training dataset
trainDS = load(fullfile(trainFiles(1).folder, trainFiles(1).name));

% load test dataset
testDS = load(fullfile(testFiles(1).folder, testFiles(1).name));

% build reference for training data angulars
% in degree
angles = trainDS.Data.angles;
cosRef = cosd(trainDS.Data.angles);
sinRef = sind(trainDS.Data.angles);

% get needed training dataset infos to reconstruct angles by output
% voltages
Voff = trainDS.Info.SensorArrayOptions.Voff;