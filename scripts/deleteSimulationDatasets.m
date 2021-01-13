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
% * <Project_Structure.html Project Structure>
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
answer = removeFilesFromDir(PathVariables.testDataPath, '*.mat');
fprintf('Delete test datasets: %s\n', string(answer));
