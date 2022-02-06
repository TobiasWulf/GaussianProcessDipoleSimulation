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

disp('Generate y drift datasets ...');
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

% clc; close all;

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
s1 = scatter(ax1, minMeanErrX, iMeanErrX, 120, 'ys', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

[minMaxErrX, iMaxErrX] = min(maxError2Retrained(:,1));
s2 = scatter(ax1, minMaxErrX, iMaxErrX, 120, 'gs', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

yticks(ax1, driftXTick);
ylim(ax1, [0 driftXN + 1]);
yticklabels(ax1, driftX);
ax1.YTickLabel(2:2:end) = {''};
% ax1.YTickLabel(3:4:end) = {''};

ax1.XAxis.Scale = 'log';
xticks(ax1, errorTick);
xlim(ax1, [0.04 400]);

xlabel(ax1, '$\epsilon_{abs}$ in $^\circ$');
ylabel(ax1, sprintf('Drift from Ref.: $(%.1f,%.1f,%.1f)^T$ mm, $%.1f^\\circ$', ...
    refX, refY, refZ, refTilt)),

subtitle(ax1, 'Drift x in $0.25$ mm Steps');

% plot drift in y
ax2 = axes(t);
ax2.Layout.Tile = 2;
ax2.YAxis.Visible = 'on';
ax2.Box = 'off';

driftYTick = 1:driftYN;

hold on;
yline(ax2, find(driftY == refY), '--', 'LineWidth', 4.5);
xline(ax2, maxErrorTDK, 'r', 'LineWidth', 4.5);

plot(ax2, meanError2Ref(:,2), driftYTick', 'mo:', 'LineWidth', 3.5);
plot(ax2, maxError2Ref(:,2), driftYTick', 'bo:', 'LineWidth', 3.5);
plot(ax2, meanError2Retrained(:,2), driftYTick', 'ms-', 'LineWidth', 3.5);
plot(ax2, maxError2Retrained(:,2), driftYTick', 'bs-', 'LineWidth', 3.5);

[minMeanErrY, iMeanErrY] = min(meanError2Retrained(:,2));
s3 = scatter(ax2, minMeanErrY, iMeanErrY, 140, 'yh', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

[minMaxErrY, iMaxErrY] = min(maxError2Retrained(:,2));
s4 = scatter(ax2, minMaxErrY, iMaxErrY, 140, 'gh', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

yticks(ax2, driftYTick);
ylim(ax2, [0 driftYN + 1]);
yticklabels(ax2, driftY);
ax2.YTickLabel(2:2:end) = {''};
% ax2.YTickLabel(3:4:end) = {''};

ax2.XAxis.Scale = 'log';
xticks(ax2, errorTick);
xlim(ax2, [0.04 400]);

xlabel(ax2, '$\epsilon_{abs}$ in $^\circ$');

subtitle(ax2, 'Drift y in $0.25$ mm Steps');

% Link the axes
linkaxes([ax1 ax2], 'y')

% plot drift in y
ax3 = axes(t);
ax3.Layout.Tile = 3;
ax3.YAxis.Visible = 'on';
ax3.Box = 'off';

driftZTick = 1:driftZN;

hold on;
yline(ax3, find(driftZ == refZ), '--', 'LineWidth', 4.5);
xline(ax3, maxErrorTDK, 'r', 'LineWidth', 4.5);

plot(ax3, meanError2Ref(:,3), driftZTick', 'mo:', 'LineWidth', 3.5);
plot(ax3, maxError2Ref(:,3), driftZTick', 'bo:', 'LineWidth', 3.5);
plot(ax3, meanError2Retrained(:,3), driftZTick', 'ms-', 'LineWidth', 3.5);
plot(ax3, maxError2Retrained(:,3), driftZTick', 'bs-', 'LineWidth', 3.5);

[minMeanErrZ, iMeanErrZ] = min(meanError2Retrained(:,3));
s5 = scatter(ax3, minMeanErrZ, iMeanErrZ, 120, 'yd', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

[minMaxErrZ, iMaxErrZ] = min(maxError2Retrained(:,3));
s6 = scatter(ax3, minMaxErrZ, iMaxErrZ, 120, 'gd', 'filled', 'MarkerEdgeColor', ...
    'k', 'LineWidth', 1);

yticks(ax3, driftZTick);
ylim(ax3, [0 driftZN + 1]);
yticklabels(ax3, driftZ);
ax3.YTickLabel(2:2:end) = {''};
% ax3.YTickLabel(3:4:end) = {''};

ax3.XAxis.Scale = 'log';
xticks(ax3, errorTick);
xlim(ax3, [0.04 400]);

xlabel(ax3, '$\epsilon_{abs}$ in $^\circ$');

subtitle(ax3, 'Drift z in $0.25$ mm Steps');

% plot drift in tilt
ax4 = axes(t);
ax4.Layout.Tile = 4;
ax4.YAxis.Visible = 'on';
ax4.Box = 'off';

driftTiltTick = 1:driftTiltN;

hold on;
l1 = yline(ax4, find(driftTilt == refTilt), '--', 'LineWidth', 4.5);
l2 = xline(ax4, maxErrorTDK, 'r', 'LineWidth', 4.5);

p1 = plot(ax4, meanError2Ref(:,4), driftTiltTick', 'mo:', 'LineWidth', 3.5);
p2 = plot(ax4, maxError2Ref(:,4), driftTiltTick', 'bo:', 'LineWidth', 3.5);
p3 = plot(ax4, meanError2Retrained(:,4), driftTiltTick', 'ms-', 'LineWidth', 3.5);
p4= plot(ax4, maxError2Retrained(:,4), driftTiltTick', 'bs-', 'LineWidth', 3.5);

[minMeanErrTilt, iMeanErrTilt] = min(meanError2Retrained(:,4));
s7 = scatter(ax4, minMeanErrTilt, iMeanErrTilt, 120, 'yo', 'filled', ...
    'MarkerEdgeColor', 'k', 'LineWidth', 1);

[minMaxErrTilt, iMaxErrTilt] = min(maxError2Retrained(:,4));
s8 = scatter(ax4, minMaxErrTilt, iMaxErrTilt, 120, 'go', 'filled', ...
    'MarkerEdgeColor', 'k', 'LineWidth', 1);

yticks(ax4, driftTiltTick);
ylim(ax4, [0 driftTiltN + 1]);
yticklabels(ax4, driftTilt);
ax4.YTickLabel(2:2:end) = {''};
% ax4.YTickLabel(3:4:end) = {''};

ax4.XAxis.Scale = 'log';
xticks(ax4, errorTick);
xlim(ax4, [0.04 400]);

xlabel(ax4, '$\epsilon_{abs}$ in $^\circ$');

subtitle(ax4, 'Drift $\alpha_y$ in $0.5^\circ$ Steps');

legend([l1, l2, p1, p2, p3, p4, s1, s2, s3, s4, s5, s6, s7, s8], ...
    {'Start/Ref', 'TDK Max $\rightarrow 0.6^\circ$', 'Mean to Ref', 'Max to Ref', ...
    'Mean Retrained', 'Max Retrained', ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMeanErrX), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMaxErrX), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMeanErrY), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMaxErrY), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMeanErrZ), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMaxErrZ), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMeanErrTilt), ...
    sprintf('Min $\\rightarrow %.2f^\\circ$', minMaxErrTilt)}, ...
    'Location', 'bestoutside')

%% Plot Model Parameter Drift in X and Y

% clc; close all;

figure('Name', 'Param X Y', 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
t1 = tiledlayout(1, 3);
bgAx1 = axes(t1,'XTick',[],'YTick',[],'Box','off');
bgAx1.Layout.TileSpan = [1 3];
title(bgAx1, 'a) Retrained Model Parameter in Horizontal Drifts')

% plot parameter drift in x and y
ax5 = axes(t1);
ax5.Box = 'off';

hold on;

xline(ax5, 1e-6, 'k-', 'LineWidth', 4.5);
xline(ax5, 1e-4, 'k-', 'LineWidth', 4.5);
xline(ax5, 6e-7, 'r-', 'LineWidth', 4.5);
xline(ax5, 1e-5, 'r-', 'LineWidth', 4.5);
xline(ax5, 3e-4, 'r-.', 'LineWidth', 4.5);
xline(ax5, 3e-7, 'r-.', 'LineWidth', 4.5);
xline(ax5, 1e-7, 'g-', 'LineWidth', 4.5);
xline(ax5, 1e-3, 'g-', 'LineWidth', 4.5);

plot(ax5, s2nParamDrift(:,1), driftXTick', 'bo-', 'LineWidth', 3.5)
plot(ax5, s2nParamDrift(:,2), driftYTick', 'mo-', 'LineWidth', 3.5)
ax5.XAxis.Scale = 'log';
xlabel(ax5, '$\sigma_n^2$');
xlim(ax5, [5e-8 1e-3]);
xticks(ax5, [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]);
ylabel(ax5, 'Horizontal Drift $x$ in mm')
yticks(ax5, driftXTick);
ylim(ax5, [0 driftXN + 1]);
yticklabels(ax5, driftX);
ax5.YTickLabel(2:2:end) = {''};
ax5.YAxis.Color = 'b';
ax5.GridColor = [0.1500    0.1500    0.1500];

ax6 = axes(t1);
ax6.Layout.Tile = 2;
ax6.YAxis.Visible = 'off';
ax6.Box = 'off';

hold on;

xline(ax6, 1e0, 'k-', 'LineWidth', 4.5);
xline(ax6, 1e1, 'k-', 'LineWidth', 4.5);
xline(ax6, 4e-1, 'r-', 'LineWidth', 4.5);
xline(ax6, 2e1, 'r-', 'LineWidth', 4.5);
xline(ax6, 5e-1, 'r-.', 'LineWidth', 4.5);
xline(ax6, 2e2, 'r-.', 'LineWidth', 4.5);
xline(ax6, 1e-1, 'g-', 'LineWidth', 4.5);
xline(ax6, 1e2, 'g-', 'LineWidth', 4.5);

plot(ax6, s2fParamDrift(:,1), driftXTick', 'bo-', 'LineWidth', 3.5)
plot(ax6, s2fParamDrift(:,2), driftYTick', 'mo-', 'LineWidth', 3.5)
ax6.XAxis.Scale = 'log';
xlabel(ax6, '$\sigma_f^2$');
xlim(ax6, [1e-1 2e2]);
xticks(ax6, [1e-1, 1e0, 1e1, 1e2]);
yticks(ax6, driftXTick);
ylim(ax6, [0 driftXN + 1]);

ax7 = axes(t1);
ax7.Layout.Tile = 3;
ax7.YAxis.Visible = 'on';
ax7.Box = 'off';
ax7.YAxisLocation = 'right';
ax7.YAxis.Color = 'm';
ax7.GridColor = [0.1500    0.1500    0.1500];

hold on;

l3 = xline(ax7, 1e1, 'k-', 'LineWidth', 4.5);
xline(ax7, 3e1, 'k-', 'LineWidth', 4.5);
l4 = xline(ax7, 4e0, 'r-', 'LineWidth', 4.5);
xline(ax7, 4e1, 'r-', 'LineWidth', 4.5);
l5 = xline(ax7, 5e0, 'r-.', 'LineWidth', 4.5);
xline(ax7, 9e1, 'r-.', 'LineWidth', 4.5);
l6 = xline(ax7, 1e0, 'g-', 'LineWidth', 4.5);
xline(ax7, 1e2, 'g-', 'LineWidth', 4.5);

plot(ax7, slParamDrift(:,1), driftXTick', 'bo-', 'LineWidth', 3.5);
plot(ax7, slParamDrift(:,2), driftYTick', 'mo-', 'LineWidth', 3.5);
ax7.XAxis.Scale = 'log';
xlabel(ax7, '$\sigma_l$');
xlim(ax7, [1e0 2e2]);
xticks(ax7, [1e0, 1e1, 1e2]);
ylabel(ax7, 'Horizontal Drift $y$ in mm')
yticks(ax7, driftYTick);
ylim(ax7, [0 driftYN + 1]);
yticklabels(ax7, driftY);
ax7.YTickLabel(2:2:end) = {''};

linkaxes([ax5 ax6, ax7], 'y')

legend(ax6, [l3, l4, l5, l6], ...
    {'Limits Reference', ...
     'Limits Horizontal', ...
     'Limits Vertical', ...
     'Limits Experiment',}, ...
    'Location', 'southeast');

%% Plot Model Parameter Drift in Z and Tilt

% clc; close all;

figure('Name', 'Param Z Tilt', 'Units', 'normalize', 'OuterPosition', [0 0 1 1]);
t2 = tiledlayout(1, 3);
bgAx2 = axes(t2,'XTick',[],'YTick',[],'Box','off');
bgAx2.Layout.TileSpan = [1 3];
title(bgAx2, 'b) Retrained Model Parameter in Vertical Drifts')

% plot parameter drift in x and y
ax8 = axes(t2);
ax8.Box = 'off';
ax8.YAxis.Visible = 'on';
ax8.YAxis.Color = 'b';
ax8.GridColor = [0.1500    0.1500    0.1500];

hold on;

xline(ax8, 1e-6, 'k-', 'LineWidth', 4.5);
xline(ax8, 1e-4, 'k-', 'LineWidth', 4.5);
xline(ax8, 6e-7, 'r-', 'LineWidth', 4.5);
xline(ax8, 1e-5, 'r-', 'LineWidth', 4.5);
xline(ax8, 3e-4, 'r-.', 'LineWidth', 4.5);
xline(ax8, 3e-7, 'r-.', 'LineWidth', 4.5);
xline(ax8, 1e-7, 'g-', 'LineWidth', 4.5);
xline(ax8, 1e-3, 'g-', 'LineWidth', 4.5);

plot(ax8, s2nParamDrift(:,3), driftZTick', 'bo-', 'LineWidth', 3.5)
plot(ax8, s2nParamDrift(:,4), driftTiltTick', 'mo-', 'LineWidth', 3.5)
ax8.XAxis.Scale = 'log';
xlabel(ax8, '$\sigma_n^2$');
xlim(ax8, [5e-8 1e-3]);
xticks(ax8, [1e-7, 1e-6, 1e-5, 1e-4, 1e-3]);
ylabel(ax8, 'Vertical Drift $z$ in mm')
yticks(ax8, driftZTick);
ylim(ax8, [0 driftZN + 1]);
yticklabels(ax8, driftZ);
ax8.YTickLabel(2:2:end) = {''};

ax9 = axes(t2);
ax9.Layout.Tile = 2;
ax9.YAxis.Visible = 'off';
ax9.Box = 'off';

hold on;

l7 = xline(ax9, 1e0, 'k-', 'LineWidth', 4.5);
xline(ax9, 1e1, 'k-', 'LineWidth', 4.5);
l8 = xline(ax9, 4e-1, 'r-', 'LineWidth', 4.5);
xline(ax9, 2e1, 'r-', 'LineWidth', 4.5);
l9 = xline(ax9, 5e-1, 'r-.', 'LineWidth', 4.5);
xline(ax9, 2e2, 'r-.', 'LineWidth', 4.5);
l10 = xline(ax9, 1e-1, 'g-', 'LineWidth', 4.5);
xline(ax9, 1e2, 'g-', 'LineWidth', 4.5);

plot(ax9, s2fParamDrift(:,3), driftZTick', 'bo-', 'LineWidth', 3.5)
plot(ax9, s2fParamDrift(:,4), driftTiltTick', 'mo-', 'LineWidth', 3.5)
ax9.XAxis.Scale = 'log';
xlabel(ax9, '$\sigma_f^2$');
xlim(ax9, [1e-1 2e2]);
xticks(ax9, [1e-1, 1e0, 1e1, 1e2]);
yticks(ax9, driftZTick);
ylim(ax9, [0 driftZN + 1]);

ax10 = axes(t2);
ax10.Layout.Tile = 3;
ax10.YAxis.Visible = 'on';
ax10.Box = 'off';
ax10.YAxisLocation = 'right';
ax10.YAxis.Color = 'm';
ax10.GridColor = [0.1500    0.1500    0.1500];

hold on;

xline(ax10, 1e1, 'k-', 'LineWidth', 4.5);
xline(ax10, 3e1, 'k-', 'LineWidth', 4.5);
xline(ax10, 4e0, 'r-', 'LineWidth', 4.5);
xline(ax10, 4e1, 'r-', 'LineWidth', 4.5);
xline(ax10, 5e0, 'r-.', 'LineWidth', 4.5);
xline(ax10, 9e1, 'r-.', 'LineWidth', 4.5);
xline(ax10, 1e0, 'g-', 'LineWidth', 4.5);
xline(ax10, 1e2, 'g-', 'LineWidth', 4.5);

plot(ax10, slParamDrift(:,3), driftZTick', 'bo-', 'LineWidth', 3.5)
plot(ax10, slParamDrift(:,4), driftTiltTick', 'mo-', 'LineWidth', 3.5)
ax10.XAxis.Scale = 'log';
xlabel(ax10, '$\sigma_l$');
xlim(ax10, [1e0 2e2]);
xticks(ax10, [1e0, 1e1, 1e2]);
ylabel(ax10, 'Vertical Drift $\alpha_y$ in $^\circ$')
yticks(ax10, driftTiltTick);
ylim(ax10, [0 driftTiltN + 1]);
yticklabels(ax10, driftTilt);
ax10.YTickLabel(2:2:end) = {''};

linkaxes([ax8 ax9, ax10], 'y')

legend(ax10, [l7, l8, l9, l10], ...
    {'Limits Reference', ...
     'Limits Horizontal', ...
     'Limits Vertical', ...
     'Limits Experiment',}, ...
    'Location', 'southwest');
