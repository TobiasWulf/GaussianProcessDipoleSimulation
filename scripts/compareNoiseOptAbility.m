%% compareNoiseOptAbility
% This scripts compares the ability in noise level optimization of GPR models
% against max and mean angle errors and number of refernce angles.
%
%
%% Requirements
% * Other m-files required: gaussianProcessRegression module files
% * Subfunctions: none
% * MAT-files required: data/config.mat, corresponding Training and Test dataset
%
%
%% See Also
% * <gaussianProcessRegression.html gaussianProcessRegression>
% * <optimGPR.html optimGPR>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on May 02. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%
%% Start Script, Load Config and Read in Datasets
clc;
disp('Start compare noise optimization ability ...');
clearvars;
close all;

disp('Load config ...');
load config.mat PathVariables GPROptions;

disp('Search for datasets ...');
TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
assert(~isempty(TrainFiles), 'No training datasets found.');
assert(~isempty(TestFiles), 'No test datasets found.');
assert(length(TrainFiles) == length(TestFiles), 'Not equal number of datasets.');

nDatasets = length(TrainFiles);


%% Load Datasets in a Loop and Measure Model Errors and Losses
MSLL = zeros(nDatasets, 2);
mError = zeros(nDatasets, 2);
xError = zeros(nDatasets, 2);
nAngles =zeros(nDatasets, 1);
for i = 1:nDatasets
    fprintf('Load datasets: %d', i);
    try
        TrainDS = load(fullfile(TrainFiles(i).folder, TrainFiles(i).name));
        TestDS = load(fullfile(TestFiles(i).folder, TestFiles(i).name));

    catch ME
        rethrow(ME)
    end

    assert(TrainDS.Info.UseOptions.xPos == TestDS.Info.UseOptions.xPos);
    assert(TrainDS.Info.UseOptions.yPos == TestDS.Info.UseOptions.yPos);
    assert(TrainDS.Info.UseOptions.zPos == TestDS.Info.UseOptions.zPos);
    assert(TrainDS.Info.UseOptions.tilt == TestDS.Info.UseOptions.tilt);
    disp(' check corresponding: pass');
    
    nAngles(i) = TrainDS.Info.UseOptions.nAngles;
        
    disp('Init and rain models ...');
    mdl0 = optimGPR(TrainDS, TestDS, GPROptions, 0);
        
    GPROptions.mean = 'poly';
    GPROptions.polyDegree = 1;
    mdl1 = optimGPR(TrainDS, TestDS, GPROptions, 0);
    
    disp('Compute erros losses ...');
    absErr0 = lossDS(mdl0, TestDS);
    absErr1 = lossDS(mdl1, TestDS);
    MSLL(i,:) = [mdl0.MSLLA, mdl1.MSLLA];
    mError(i,:) = [mean(absErr0), mean(absErr1)];
    xError(i,:) = [max(absErr0), max(absErr1)];
    
    close all;
end

%% Plot Losses and Errors
n = 1:nDatasets;
nLabels = string(nAngles);
nLabels(2:2:end) = nan;

figure('Name', 'MSLL and Errors', ...
    'Units', 'normalize', 'OuterPosition', [0 0 1 1]);

tiledlayout(2, 2, 'TileSpacing', 'normal');

% plot mean std. log. loss
nexttile([1 2]);

hold on;
plot(n, MSLL(:, 1), '-*');
plot(n, MSLL(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(n);
xticklabels(nLabels);
xlabel('$N_{Ref}$');
ylabel('$MSLL$');
title('a) Mean Std. Log. Loss by 720 Angles');

% plot mean errors
nexttile;

hold on;
plot(n, mError(:, 1), '-*');
plot(n, mError(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(n);
xticklabels(nLabels);
xlabel('$N_{Ref}$');
ylabel('$\mu(\epsilon_{abs})$ in $^\circ$');
title('b) Mean Error by 720 Test Angles');

% plot max errors
nexttile

hold on;
plot(n, xError(:, 1), '-*');
plot(n, xError(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(n);
xticklabels(nLabels);
xlabel('$N_{Ref}$');
ylabel('$\max\epsilon_{abs}$ in $^\circ$');
title('c) Max Error by 720 Test Angles');

legend({'Zero Mean GPR', 'Poly Mean GPR'}, 'Units', 'normalized', ...
    'Position', [.85 .48 .125 .07]);

