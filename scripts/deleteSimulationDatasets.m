%% deleteSimulationDatasets
% Delete simulation dataset from data/training and data/test path at once.
%
%
%% Requirements
% * Other m-files required: removeFilesFromDir.m
% * Subfunctions: None
% * MAT-files required: config.mat
%
%
%% See Also
% * <removeFilesFromDir.html removeFilesFromDir>
% * <generateConfigMat.html gernerateConfigMat>
% * <Project_Structure.html Project_Structure>
%
%
% Created on November 25. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%
%% Load Path to Clean Up
% Load path from config.mat and where to find training and test datasets.
try
    clearvars;
    close all;
    load('config.mat', 'PathVariables')
    disp('Delete from ...')
    disp(PathVariables.trainingDataPath);
    disp(PathVariables.testDataPath);
catch ME
    rethrow(ME)
end

%% Delete Datasets
% Delete datasets from training dataset path and test dataset path with certain
% file pattern.
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.mat');
fprintf('Delete training datasets: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.avi');
fprintf('Delete training movies: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.fig');
fprintf('Delete training figures: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.eps');
fprintf('Delete training eps: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.svg');
fprintf('Delete training svg: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.trainingDataPath, '*.pdf');
fprintf('Delete training pdf: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.mat');
fprintf('Delete test datasets: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.avi');
fprintf('Delete test movies: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.fig');
fprintf('Delete test figures: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.eps');
fprintf('Delete test eps: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.svg');
fprintf('Delete test svg: %s\n', string(answer));
answer = removeFilesFromDir(PathVariables.testDataPath, '*.pdf');
fprintf('Delete test pdf: %s\n', string(answer));
