%% deleteSimulationPlots
% Delete plots of simulation dataset from figure and image path at once.
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
% Created on November 02. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
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
    path = PathVariables.saveImagesPath;
catch ME
    rethrow(ME)
end

%% Delete Dataset Plots
% Delete datasets plots from image path and figure path with certain
% file pattern and extensions.
ext = ["fig" "svg" "eps" "pdf" "avi"];
pat = "*";

for e = ext
    asw = removeFilesFromDir(path, join([pat, e], "."));
    fprintf('Deleted pattern %s.%s %s\n', pat, e, string(asw));
end

