%% compareCpuTimeVsError
% This scripts compares relative computing time of a single test point versus
% max and mean angle erros of a completet rotation to generate a metric which
% estimates a good relation between speed and angle error acceptance. Therefor
% several training datasets with different number of reference angles must be
% generated. The training datasets must correspond to test datasets which must
% correlate in position and tilt. The script runs without noise optimization.
% Set the noise level to noise upper bounds in config script to have widest
% complexity ranges. The script values the inner fmincon kernel optimization.
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
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on May 01. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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
disp('Start compare cpu time vs. error ...');
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
tang = 73;


%% Load Datasets in a Loop and Measure Model Errors and Computation Time
cTime = zeros(nDatasets, 2);
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
    
    fprintf('Get test point: %d\n', tang);
    Xcos = TestDS.Data.Vcos(:,:,tang);
    Xsin = TestDS.Data.Vsin(:,:,tang);
    
    disp('Init and rain models ...');
    mdl0 = initGPR(TrainDS, GPROptions);
    
    fprintf('Zero mean, N = %d\n', mdl0.N);
    mdl0 = tuneKernel(mdl0, 1);
    
    GPROptions.mean = 'poly';
    GPROptions.polyDegree = 1;
    mdl1 = initGPR(TrainDS, GPROptions);
    
    fprintf('Poly mean, N = %d\n', mdl0.N);
    mdl1 = tuneKernel(mdl1, 1);
    
    disp('Measure cpu time ...');
    f0 = @() predFrame(mdl0, Xcos, Xsin);
    f1 = @() predFrame(mdl1, Xcos, Xsin);
    
    cTime(i,1) = timeit(f0);
    cTime(i,2) = timeit(f1);
    
    disp('Compute abs mean and max erros ...');
    absErr0 = lossDS(mdl0, TestDS);
    absErr1 = lossDS(mdl1, TestDS);
    mError(i,:) = [mean(absErr0), mean(absErr1)];
    xError(i,:) = [max(absErr0), max(absErr1)];
end

%% Plot Timings and Errors
close all
n = 1:nDatasets;

figure('Name', 'Timing vs. Errors', ...
    'Units', 'normalize', 'OuterPosition', [0 0 1 1]);

tiledlayout(2, 2, 'TileSpacing', 'normal');

% plot cpu timings
nexttile([1 2]);

hold on;
plot(n, cTime(:, 1), '-*');
plot(n, cTime(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(n);
xticklabels(nAngles);
xlabel('$N_{Ref}$');
ylabel('$t$ in s');
title('a) CPU Time by Single Test Angle');

% plot mean errors
nexttile;

hold on;
plot(n, mError(:, 1), '-*');
plot(n, mError(:, 2), '-*');
xlim([0 nDatasets + 1]);
xticks(n);
xticklabels(nAngles);
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
xticklabels(nAngles);
xlabel('$N_{Ref}$');
ylabel('$\max\epsilon_{abs}$ in $^\circ$');
title('c) Max Error by 720 Test Angles');

legend({'Zero Mean GPR', 'Poly Mean GPR'}, 'Units', 'normalized', ...
    'Position', [.85 .48 .125 .07]);
