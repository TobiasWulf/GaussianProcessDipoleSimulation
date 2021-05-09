%% compareMissAlign
% # Create reference dataset to compare against drift and retraining. Reference
%   Position.
% # Create same number of drift datasets for each drift in x,y,z and tilt drift.
%   Position drifts in x,y,z must have the same drift steps diverging from the
%   reference position to match a drift plots. Tilt drift is assigned to a
%   separate axis.
% # Execute this script and ensure dataset chaining. First dataset is reference
%   dataset, second bunch must be drift in x, third bunch in drift in y, fourth
%   bunch drift in z and fifth bunch drift in tilt. So loaded file pattern
%   schould have following indices for e.g. 25 drift iterations each:
%
% * (1) reference dataset
% * (2-26) drift in x
% * (27-51) drift in y
% * (52-76) drift in z
% * (77-101) drift in tilt
%
% Script forces simulation to run with TDK characterization dataset. Identifier
% is set manually to TDK.
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
%% Start Script and Clear All
clc;
disp('Start compare miss align ...');
disp('Clear all ...');
clearvars;
close all;
deleteSimulationDatasets;


%% Declare Reference Position and Drift Vectors
disp('Declare reference and drift ...');
refX      = 0;
refY      = 0;
refZ      = 7.5;
refTilt   = 0;
driftX    = -3:0.25:3;
driftY    = -3:0.25:3;
driftZ    = 4.5:0.25:10.5;
driftTilt = 0:0.5:12;


%% Declare Common Variables
disp('Declare common vars ...');
trainPath   = PathVariables.trainingDataPath;
testPath    = PathVariables.testDataPath;
maxErrorTDK = 0.6;
errorTick   = [1e-1 1 10 1e2];


%% Calculated Datasets Indices on Drift Parameter
disp('Numbering drift sets ...');
driftXN    = length(driftX);
driftYN    = length(driftY);
driftZN    = length(driftZ);
driftTiltN = length(driftTilt);
driftAllN  = driftXN + driftYN + driftZN + driftTiltN; 
fprintf('Overall drifts: %d ...', driftAllN);

assert(driftXN == driftYN,    'Inbalance drift in x2y')
assert(driftXN == driftZN,    'Inbalance drift in x2z')
assert(driftXN == driftTiltN, 'Inbalance drift in x2tilt')
disp('Number of drift iterations equals: pass ...');

disp('Index drift set ...');
refIndex       = 1;
driftXIndex    = refIndex + 1       : driftXN    + refIndex;
driftYIndex    = driftXIndex(end) + 1 : driftYN    + driftXIndex(end);
driftZIndex    = driftYIndex(end) + 1 : driftZN    + driftYIndex(end);
driftTiltIndex = driftZIndex(end) + 1 : driftTiltN + driftZIndex(end);


%% Allocate Memory for Error and Parameter Drifts [X, Y, Z, Tilt]
disp('Allocate memory ...');
meanError2Ref       = zeros(driftXN, 4);
maxError2Ref        = zeros(driftXN, 4);
meanError2Retrained = zeros(driftXN, 4);
maxError2Retrained  = zeros(driftXN, 4);
s2nParamDrift       = zeros(driftXN, 4);
s2fParamDrift       = zeros(driftXN, 4);
slParamDrift        = zeros(driftXN, 4);


%% Load Config
disp('Load config ...');
load config.mat PathVariables  GeneralOptions SensorArrayOptions ...
    DipoleOptions TrainingOptions TestOptions GPROptions;


%% Load TDK Characterization Dataset and Set Base Reference in Options
disp('Load TDK characterization dataset ...');

CharDS = load(PathVariables.tdkDatasetPath);

TrainingOptions.BaseReference = 'TDK';
TestOptions.BaseReference     = 'TDK';


%% Generate Reference Datasets
disp('Set reference position ...');
TrainingOptions.xPos = refX;
TrainingOptions.yPos = refY;
TrainingOptions.zPos = refZ;
TrainingOptions.tilt = refTilt;

TestOptions.xPos = TrainingOptions.xPos;
TestOptions.yPos = TrainingOptions.yPos;
TestOptions.zPos = TrainingOptions.zPos;
TestOptions.tilt = TrainingOptions.tilt;

disp('Generate reference datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TrainingOptions, CharDS);
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TestOptions, CharDS);


%% Generate X Drift Datasets
disp('Set x drift positions ...');
TrainingOptions.xPos = driftX;
% TrainingOptions.yPos = refY;
% TrainingOptions.zPos = refZ;
% TrainingOptions.tilt = refTilt;

TestOptions.xPos = TrainingOptions.xPos;
% TestOptions.yPos = TrainingOptions.yPos;
% TestOptions.zPos = TrainingOptions.zPos;
% TestOptions.tilt = TrainingOptions.tilt;

disp('Generate x drift datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TrainingOptions, CharDS);
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TestOptions, CharDS);


%% Generate Y Drift Datasets
disp('Set y drift positions ...');
TrainingOptions.xPos = refX;
TrainingOptions.yPos = driftY;
% TrainingOptions.zPos = refZ;
% TrainingOptions.tilt = refTilt;

TestOptions.xPos = TrainingOptions.xPos;
TestOptions.yPos = TrainingOptions.yPos;
% TestOptions.zPos = TrainingOptions.zPos;
% TestOptions.tilt = TrainingOptions.tilt;

disp('Generate x drift datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TrainingOptions, CharDS);
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TestOptions, CharDS);


%% Generate Z Drift Datasets
disp('Set z drift positions ...');
% TrainingOptions.xPos = refX;
TrainingOptions.yPos = refY;
TrainingOptions.zPos = driftZ;
% TrainingOptions.tilt = refTilt;

% TestOptions.xPos = TrainingOptions.xPos;
TestOptions.yPos = TrainingOptions.yPos;
TestOptions.zPos = TrainingOptions.zPos;
% TestOptions.tilt = TrainingOptions.tilt;

disp('Generate z drift datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TrainingOptions, CharDS);
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TestOptions, CharDS);


%% Generate Tilt Drift Datasets
disp('Set tilt drift positions ...');
% TrainingOptions.xPos = refX;
% TrainingOptions.yPos = refY;
TrainingOptions.zPos = refZ;
% TrainingOptions.tilt = refTilt;

% TestOptions.xPos = TrainingOptions.xPos;
% TestOptions.yPos = TrainingOptions.yPos;
TestOptions.zPos = TrainingOptions.zPos;
% TestOptions.tilt = TrainingOptions.tilt;

disp('Generate tilt drift datasets ...');
for tilt = driftTilt
    TrainingOptions.tilt = tilt;
    TestOptions.tilt     = tilt;
    
    simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
        SensorArrayOptions, DipoleOptions, TrainingOptions, CharDS);
    simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
        SensorArrayOptions, DipoleOptions, TestOptions, CharDS);
end


%% Reload Path of Generated Datasets
disp('Scanning directories ...');
TrainFiles = dir(fullfile(trainPath, 'Training*.mat'));
TestFiles  = dir(fullfile(testPath, 'Test*.mat'));

TrainFilesN = length(TrainFiles);
TestFilesN  = length(TestFiles);

assert(TrainFilesN == TestFilesN, 'Inbalance in files.');
disp('Data is consistent ...');


%% Load Reference Datasets Train Reference Model
fprintf('Load datasets (%d) ...\n', refIndex);
TrainDS = load(fullfile(trainPath, TrainFiles(refIndex).name));
TestDS  = load(fullfile(testPath, TestFiles(refIndex).name));


%% Train Reference Model on Reference Datasets
disp('Train model in reference position ...')
RefMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
close all;


%% Run Drift in X
disp('Run drift in x');
iDrift = 1;
for iFile = driftXIndex
    fprintf('Load datasets (%d) ...\n', iFile);
    TrainDS = load(fullfile(trainPath, TrainFiles(iFile).name));
    TestDS  = load(fullfile(testPath, TestFiles(iFile).name));
    
    fprintf('Measure errors x drift %.2f to ref ...\n', driftX(iDrift));
    absError2Ref             = lossDS(RefMdl, TestDS);
    meanError2Ref(iDrift, 1) = mean(absError2Ref);
    maxError2Ref(iDrift, 1)  = max(absError2Ref);
    
    disp('Retrain model on drift position ...');
    RetrainedMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
    close all;
    
    disp('Measure errors on retrained model ...')
    absErrorRetrained              = lossDS(RetrainedMdl, TestDS);
    meanError2Retrained(iDrift, 1) = mean(absErrorRetrained);
    maxError2Retrained(iDrift, 1)  = max(absErrorRetrained);
    
    disp('Track model parameters');
    s2nParamDrift(iDrift, 1) = RetrainedMdl.s2n;
    s2fParamDrift(iDrift, 1) = RetrainedMdl.theta(1);
    slParamDrift(iDrift, 1)  = RetrainedMdl.theta(2);
    
    iDrift = iDrift + 1;
end


%% Run Drift in Y
disp('Run drift in y');
iDrift = 1;
for iFile = driftYIndex
    fprintf('Load datasets (%d) ...\n', iFile);
    TrainDS = load(fullfile(trainPath, TrainFiles(iFile).name));
    TestDS  = load(fullfile(testPath, TestFiles(iFile).name));
    
    fprintf('Measure errors y drift %.2f to ref ...\n', driftY(iDrift));
    absError2Ref             = lossDS(RefMdl, TestDS);
    meanError2Ref(iDrift, 2) = mean(absError2Ref);
    maxError2Ref(iDrift, 2)  = max(absError2Ref);
    
    disp('Retrain model on drift position ...');
    RetrainedMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
    close all;
    
    disp('Measure errors on retrained model ...')
    absErrorRetrained              = lossDS(RetrainedMdl, TestDS);
    meanError2Retrained(iDrift, 2) = mean(absErrorRetrained);
    maxError2Retrained(iDrift, 2)  = max(absErrorRetrained);
    
    disp('Track model parameters');
    s2nParamDrift(iDrift, 2) = RetrainedMdl.s2n;
    s2fParamDrift(iDrift, 2) = RetrainedMdl.theta(1);
    slParamDrift(iDrift, 2)  = RetrainedMdl.theta(2);
    
    iDrift = iDrift + 1;
end


%% Run Drift in Z
disp('Run drift in z');
iDrift = 1;
for iFile = driftZIndex
    fprintf('Load datasets (%d) ...\n', iFile);
    TrainDS = load(fullfile(trainPath, TrainFiles(iFile).name));
    TestDS  = load(fullfile(testPath, TestFiles(iFile).name));
    
    fprintf('Measure errors z drift %.2f to ref ...\n', driftZ(iDrift));
    absError2Ref             = lossDS(RefMdl, TestDS);
    meanError2Ref(iDrift, 3) = mean(absError2Ref);
    maxError2Ref(iDrift, 3)  = max(absError2Ref);
    
    disp('Retrain model on drift position ...');
    RetrainedMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
    close all;
    
    disp('Measure errors on retrained model ...')
    absErrorRetrained              = lossDS(RetrainedMdl, TestDS);
    meanError2Retrained(iDrift, 3) = mean(absErrorRetrained);
    maxError2Retrained(iDrift, 3)  = max(absErrorRetrained);
    
    disp('Track model parameters');
    s2nParamDrift(iDrift, 3) = RetrainedMdl.s2n;
    s2fParamDrift(iDrift, 3) = RetrainedMdl.theta(1);
    slParamDrift(iDrift, 3)  = RetrainedMdl.theta(2);
    
    iDrift = iDrift + 1;
end


%% Run Drift in Tilt
disp('Run drift in tilt');
iDrift = 1;
for iFile = driftTiltIndex
    fprintf('Load datasets (%d) ...\n', iFile);
    TrainDS = load(fullfile(trainPath, TrainFiles(iFile).name));
    TestDS  = load(fullfile(testPath, TestFiles(iFile).name));
    
    fprintf('Measure errors tilt drift %.2f to ref ...\n', driftTilt(iDrift));
    absError2Ref             = lossDS(RefMdl, TestDS);
    meanError2Ref(iDrift, 4) = mean(absError2Ref);
    maxError2Ref(iDrift, 4)  = max(absError2Ref);
    
    disp('Retrain model on drift position ...');
    RetrainedMdl = optimGPR(TrainDS, TestDS, GPROptions, 0);
    close all;
    
    disp('Measure errors on retrained model ...')
    absErrorRetrained              = lossDS(RetrainedMdl, TestDS);
    meanError2Retrained(iDrift, 4) = mean(absErrorRetrained);
    maxError2Retrained(iDrift, 4)  = max(absErrorRetrained);
    
    disp('Track model parameters');
    s2nParamDrift(iDrift, 4) = RetrainedMdl.s2n;
    s2fParamDrift(iDrift, 4) = RetrainedMdl.theta(1);
    slParamDrift(iDrift, 4)  = RetrainedMdl.theta(2);
    
    iDrift = iDrift + 1;
end


%% Plot Drift Errors
clc;
close all;

figure('Name', 'Errors', 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);

t = tiledlayout(1, 4);
bgAx = axes(t,'XTick',[],'YTick',[],'Box','off');
bgAx.Layout.TileSpan = [1 4];

% plot drift in x
ax1 = axes(t);
ax1.Box = 'off';
driftXTick = 1:driftXN;

hold on;
yline(ax1, find(driftX == refX), '--', 'LineWidth', 4.5);
xline(ax1, maxErrorTDK, 'r', 'LineWidth', 4.5);

plot(ax1, meanError2Ref(:,1), driftXTick', 'mo:', 'LineWidth', 3.5);
plot(ax1, maxError2Ref(:,1), driftXTick', 'bo:', 'LineWidth', 3.5);
plot(ax1, meanError2Retrained(:,1), driftXTick', 'ms-', 'LineWidth', 3.5);
plot(ax1, maxError2Retrained(:,1), driftXTick', 'bs-', 'LineWidth', 3.5);

[minMeanErrX, iMeanErrX] = min(meanError2Retrained(:,1));
scatter(ax1, minMeanErrX, iMeanErrX, 120, 'cs', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 2);
text(minMeanErrX, iMeanErrX, sprintf('$\\leftarrow %.2f$', minMeanErrX), 'FontSize', 25, 'Color', 'k');

[minMaxErrX, iMaxErrX] = min(maxError2Retrained(:,1));
scatter(ax1, minMaxErrX, iMaxErrX, 120, 'gs', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 2);

yticks(driftXTick);
ylim([0 driftXN + 1]);
yticklabels(ax1, driftX);
ax1.YTickLabel(2:2:end) = {''};
% ax1.YTickLabel(3:4:end) = {''};

ax1.XAxis.Scale = 'log';
xticks(errorTick);




xlabel(ax1, 'First Interval')

% Create second plot
ax2 = axes(t);
ax2.Layout.Tile = 2;
plot(ax2,maxError2Ref, driftXTick')
%xline(ax2,45,':');
ax2.YAxis.Visible = 'off';

ax2.Box = 'off';
%xlim(ax2,[45 60])
xlabel(ax2,'Second Interval')

% Link the axes
linkaxes([ax1 ax2], 'y')


% driftTick = 1:nDatasets;
% 
% if strcmp(drift, 'tilt'), drift = '\\alpha_y'; end
% titleA = 'a) Drift in $%s$ without Retraining, $\\epsilon_{abs}$ by 720 Test Angles';
% titleB = 'b) Drift in $%s$ with Retraining, $\\epsilon_{abs}$ by 720 Test Angles';
% xLabels = '$%s$ in %s';
% 
% 
% % plot errors
% figure('Name', 'Drift vs. Retraining', ...
%     'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
% 
% %tiledlayout(2, 1, 'TileSpacing', 'normal');
% 
% % plot errors from reference point and retrained
% nexttile;
% 
% hold on;
% plot(driftTick, mError, '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% plot(driftTick, xError, '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% yline(0.8, 'k-.', 'LineWidth', 3.5)
% set(gca, 'YScale', 'log');
% 
% xlim([0 nDatasets + 1]);
% ylim([0.1 500]);
% xticks(driftTick);
% xticklabels(driftParam);
% 
% xlabel(sprintf(xLabels, drift, unit));
% ylabel('$\epsilon_{abs}$ in $^\circ$');
% title(sprintf(titleA, drift));
% legend({'Mean', 'Max', '$\epsilon_{abs} = 0.80^\circ$'});
% 
% % plot retrained errors
% nexttile
% 
% hold on;
% plot(driftTick, mError(:, 2), '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% plot(driftTick, xError(:, 2), '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% yline(0.8, 'k-.', 'LineWidth', 3.5)
% set(gca, 'YScale', 'log');
% 
% xlim([0 nDatasets + 1]);
% ylim([0.01 1]);
% xticks(driftTick);
% xticklabels(driftParam);
% 
% xlabel(sprintf(xLabels, drift, unit));
% ylabel('$\epsilon_{abs}$ in $^\circ$');
% title(sprintf(titleB, drift));
% 
% [mM, iM] = min(mError(:,2));
% scatter(iM, mM, 100, 'co', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 2);
% [mX, iX] = min(xError(:,2));
% scatter(iX, mX, 100, 'mo', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 2);
% 
% legend({'Mean', 'Max', ...
%     '$\epsilon_{abs} = 0.80^\circ$', ...
%     sprintf('min Mean $=  %.2f^\\circ$', round(mM,3)), ...
%     sprintf('min Max $=  %.2f^\\circ$', round(mX,3))});
% 
% 
% % plot parameter drift
% figure('Name', 'Model Params vs. Retraining', ...
%     'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
% 
% tiledlayout(3, 1, 'TileSpacing', 'normal');
% 
% % plot noise level
% nexttile
% 
% hold on;
% plot(driftTick, s2n, '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% yline(RetrainMdl.s2nBounds(1), 'k-.', 'LineWidth', 3.5)
% yline(RetrainMdl.s2nBounds(2), 'k-.', 'LineWidth', 3.5)
% set(gca, 'YScale', 'log');
% 
% xlim([0 nDatasets + 1]);
% xticks(driftTick);
% xticklabels(driftParam);
% 
% xlabel(sprintf(xLabels, drift, unit));
% ylabel('$\sigma_n^2$');
% title('a) Noise Level Drift');
% legend({'Drift', 'Bounds'});
% 
% % plot hight scale
% nexttile
% 
% hold on;
% plot(driftTick, s2f, '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% yline(RetrainMdl.s2fBounds(1), 'k-.', 'LineWidth', 3.5)
% yline(RetrainMdl.s2fBounds(2), 'k-.', 'LineWidth', 3.5)
% set(gca, 'YScale', 'log');
% 
% xlim([0 nDatasets + 1]);
% xticks(driftTick);
% xticklabels(driftParam);
% 
% xlabel(sprintf(xLabels, drift, unit));
% ylabel('$\sigma_f^2$');
% title('b) Hight Scale Drift');
% legend({'Drift', 'Bounds'});
% 
% 
% % plot length scale
% nexttile
% 
% hold on;
% plot(driftTick, sl, '-*', 'LineWidth', 3.5, 'MarkerSize', 8);
% yline(RetrainMdl.slBounds(1), 'k-.', 'LineWidth', 3.5)
% yline(RetrainMdl.slBounds(2), 'k-.', 'LineWidth', 3.5)
% set(gca, 'YScale', 'log');
% 
% xlim([0 nDatasets + 1]);
% xticks(driftTick);
% xticklabels(driftParam);
% 
% xlabel(sprintf(xLabels, drift, unit));
% ylabel('$\sigma_l$');
% title('a) Length Scale Drift');
% legend({'Drift', 'Bounds'});
