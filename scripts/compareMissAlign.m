%% compareMissAlign
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
% * <initGPR.html initGPR>
% * <tuneGPR.html tuneGPR>
% * <optimGPR.html optimGPR>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on May 06. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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
disp('Start GPR module demonstration ...');
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

disp('Set reference datasets (1) ...');
RefTrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
RefTestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));

disp('Set drift kind ...');
drift = input('Drift in: ', 's');

switch drift
    case {'x', 'y', 'z'}
        unit = 'mm';
    case 'phi'
        unit = '$^\circ$';
    otherwise
        error('Use x, y, z or phi as drift.');
end

fprintf('Set drift unit to %s ...\n', unit);

%% Train Model on Reference Datasets
disp('Train model in reference position ...')
RefMdl = optimGPR(RefTrainDS, RefTestDS, GPROptions, 0);
close all;

%% Load Datasets in a Loop and Measure Model Errors and Retrain Model
mError = zeros(nDatasets, 2);
xError = zeros(nDatasets, 2);
driftParam =zeros(nDatasets, 1);

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
    
    switch drift
        case 'x'
            driftParam(i) = TrainDS.Info.UseOptions.xPos;
        case 'y'
            driftParam(i) = TrainDS.Info.UseOptions.yPos;
        case 'z'
            driftParam(i) = TrainDS.Info.UseOptions.zPos;
        case 'phi'
        	driftParam(i) = TrainDS.Info.UseOptions.tilt;
        otherwise
            error('Use x, y, z or phi as drift.');
    end
    fprintf('Read drift param %s: %.2f\n', drift, driftParam(i));
    
    disp('Measure error on reference model ...');
    refError = lossDS(RefMdl, TestDS);
    mError(i, 1) = mean(refError);
    xError(i, 1) = max(refError);
    
    disp('Retrain model on current drift position ...');
    RetrainMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
    close all;
    
    disp('Measure error on retrained model ...');
    retrainError = lossDS(RetrainMdl, TestDS);
    mError(i, 2) = mean(retrainError);
    xError(i, 2) = max(retrainError);
    
end

%% Plot Timings and Errors
driftTick = 1:nDatasets;

switch drift
    case {'x', 'y', 'z'}
        xLabels = sprintf('$%s$ in %s', drift, unit);
    case 'phi'
        xLabels = sprintf('$\\%s$ in $%s$', drift, unit);
    otherwise
        error('Use x, y, z or phi as drift.');
end

figure('Name', 'Drift vs. Retraining', ...
    'Units', 'normalize', 'OuterPosition', [0 0 1 1]);

tiledlayout(2, 1, 'TileSpacing', 'normal');

% plot mean errors
nexttile;

hold on;
plot(driftTick, mError(:, 1), '-*');
plot(driftTick, mError(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(driftTick);
xticklabels(driftParam);
xlabel(xLabels);
ylabel('$\mu(\epsilon_{abs})$ in $^\circ$');
title('a) Mean Error by 720 Test Angles');
legend({'Reference', 'Retrained'});

% plot max errors
nexttile

hold on;
plot(driftTick, xError(:, 1), '-*');
plot(driftTick, xError(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(driftTick);
xticklabels(driftParam);
xlabel(xLabels);
ylabel('$\max\epsilon_{abs}$ in $^\circ$');
title('b) Max Error by 720 Test Angles');
legend({'Reference', 'Retrained'});

