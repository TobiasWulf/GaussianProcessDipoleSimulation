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
    fig = PathVariables.saveFiguresPath;
    svg = fullfile(PathVariables.saveImagesPath, 'svg');
    eps = fullfile(PathVariables.saveImagesPath, 'eps');
    pdf = fullfile(PathVariables.saveImagesPath, 'pdf');
    avi = fullfile(PathVariables.saveImagesPath, 'avi');
catch ME
    rethrow(ME)
end

%% Delete Dataset Plots
% Delete datasets plots from image path and figure path with certain
% file pattern.
% path
pth = [fig svg eps pdf avi];
% extension
ext = ["fig" "svg" "eps" "pdf" "avi"];
% file patterns
pat = ["*"];

for i = 1:length(pth)
    disp(pth(i));
    for p = pat
        asw = removeFilesFromDir(pth(i), join([p, ext(i)], "."));
        fprintf('Deleted pattern %s.%s %s\n', p, ext(i), string(asw));
    end
end

