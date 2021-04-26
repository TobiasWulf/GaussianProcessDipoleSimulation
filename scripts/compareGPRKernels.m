%% compareGPRKernels
% This script compares the implemented kernel function with each and another. It
% initiates each kernel with different kernel parameters and in a row and
% compares them in two plots for kernel functions and covariance matrix.
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
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on April 11. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%

%% Load Datasets
clear all;
close all;
disp('Load config ...');
load config.mat PathVariables GPROptions;
TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
assert(~isempty(TrainFiles), 'No training datasets found.');
assert(~isempty(TestFiles), 'No test datasets found.');

disp('Load first found datasets ...');
try
    TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
    TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));

catch ME
    rethrow(ME)
end

%% Initiate Kernels with different Kernelparameters
ma11 = initGPR(TrainDS, GPROptions);

GPROptions.theta = [1 2];
ma12 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [1 0.5];
ma105 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [1 4];
ma14 = initGPR(TrainDS, GPROptions);


GPROptions.theta = [2 1];
mc21 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [0.5 1];
mc051 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [4 1];
mc41 = initGPR(TrainDS, GPROptions);

GPROptions.kernel = 'QFCAPX';
GPROptions.theta = [1 1];
mb11 = initGPR(TrainDS, GPROptions);

GPROptions.theta = [1 2];
mb12 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [1 0.5];
mb105 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [1 4];
mb14 = initGPR(TrainDS, GPROptions);

GPROptions.theta = [2 1];
md21 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [0.5 1];
md051 = initGPR(TrainDS, GPROptions);
GPROptions.theta = [4 1];
md41 = initGPR(TrainDS, GPROptions);


%% Compute Losses for each Kernel with Length Variation
[~, ma11SLLA, ma11SLLR] = lossDS(ma11, TestDS);
[~, ma105SLLA, ma105SLLR] = lossDS(ma105, TestDS);
[~, ma12SLLA, ma12SLLR] = lossDS(ma12, TestDS);
[~, ma14SLLA, ma14SLLR] = lossDS(ma14, TestDS);

[~, mb11SLLA, mb11SLLR] = lossDS(mb11, TestDS);
[~, mb105SLLA, mb105SLLR] = lossDS(mb105, TestDS);
[~, mb12SLLA, mb12SLLR] = lossDS(mb12, TestDS);
[~, mb14SLLA, mb14SLLR] = lossDS(mb14, TestDS);

%% Plot Area

% plot covariance slice for first covariance sample
figure;
tiledlayout(2,2);

nexttile;

hold on;

p1 = plot(1:ma11.N, ma11.Ky(1,:), 'k');
p2 = plot(1:ma12.N, ma12.Ky(1,:), 'b-.');
p3 = plot(1:ma105.N, ma105.Ky(1,:), 'r-.');
p4 = plot(1:ma14.N, ma14.Ky(1,:), 'g-.');
xlim([1, ma11.N]);
%ylim([min(Mdl1.Ky, [], 'all'), max(Mdl1.Ky, [], 'all')]);
legend([p1, p2, p3, p4], ...
    {'$\theta = (1,1)$', ...
    '$\theta = (1,2)$', ...
    '$\theta = (1,0.5)$', ...
    '$\theta = (1,4)$'}, 'Location', 'north');
xlabel('$j-tes$ Sample');
title('a) $k(X_1, X_j|\theta)$ f. $d_F^2$, $\theta_1 = konst.$');

nexttile;

hold on;

p1 = plot(1:mb11.N, mb11.Ky(1,:), 'k');
p2 = plot(1:mb12.N, mb12.Ky(1,:), 'b-.');
p3 = plot(1:mb105.N, mb105.Ky(1,:), 'r-.');
p4 = plot(1:mb14.N, mb14.Ky(1,:), 'g-.');
xlim([1, mb11.N]);
%ylim([min(Mdl1.Ky, [], 'all'), max(Mdl1.Ky, [], 'all')]);
legend([p1, p2, p3, p4], ...
    {'$\theta = (1,1)$', ...
    '$\theta = (1,2)$', ...
    '$\theta = (1,0.5)$', ...
    '$\theta = (1,4)$'}, 'Location', 'north');
xlabel('$j-tes$ Sample');
title('b) $k(X_1, X_j|\theta)$ f. $d_E^2$, $\theta_1 = konst.$');

nexttile;

hold on;

p1 = plot(1:ma11.N, ma11.Ky(1,:), 'k');
p2 = plot(1:mc21.N, mc21.Ky(1,:), 'b-.');
p3 = plot(1:mc051.N, mc051.Ky(1,:), 'r-.');
p4 = plot(1:mc41.N, mc41.Ky(1,:), 'g-.');
xlim([1, ma11.N]);
%ylim([min(Mdl1.Ky, [], 'all'), max(Mdl1.Ky, [], 'all')]);
legend([p1, p2, p3, p4], ...
    {'$\theta = (1,1)$', ...
    '$\theta = (2,1)$', ...
    '$\theta = (0.5,1)$', ...
    '$\theta = (4,1)$'}, 'Location', 'north');
xlabel('$j-tes$ Sample');
title('c) $k(X_1, X_j|\theta)$ f. $d_F^2$, $\theta_2 = konst.$');

nexttile;

hold on;

p1 = plot(1:mb11.N, mb11.Ky(1,:), 'k');
p2 = plot(1:md21.N, md21.Ky(1,:), 'b-.');
p3 = plot(1:md051.N, md051.Ky(1,:), 'r-.');
p4 = plot(1:md41.N, md41.Ky(1,:), 'g-.');
xlim([1, mb11.N]);
%ylim([min(Mdl1.Ky, [], 'all'), max(Mdl1.Ky, [], 'all')]);
legend([p1, p2, p3, p4], ...
    {'$\theta = (1,1)$', ...
    '$\theta = (2,1)$', ...
    '$\theta = (0.5,1)$', ...
    '$\theta = (4,1)$'}, 'Location', 'north');
xlabel('$j-tes$ Sample');
title('d) $k(X_1, X_j|\theta)$ f. $d_E^2$, $\theta_2 = konst.$');

% plot covariance matrix
figure;
tiledlayout(1,2);
colormap('jet');

nexttile;

imagesc(ma11.Ky);
axis square;
xlabel('$j$');
ylabel('$i$');
title('a) $K(X, X|\theta)$ f. $d_F^2$, $\theta = (1,1)$')

nexttile;

% colormap('jet');
imagesc(mb11.Ky);
axis square;
xlabel('$j$');
ylabel('$i$');
title('a) $K(X, X|\theta)$ f. $d_E^2$, $\theta = (1,1)$')

c = colorbar;
c.TickLabelInterpreter = 'latex';

% plot losses and compare against each kernel and behavior between SLLA and SLLR
figure;
tiledlayout(2,2);
angles = TestDS.Data.angles';

nexttile;

hold on;

plot(angles, ma11SLLA);
plot(angles, ma11SLLR, '-.');
yline(mean(ma11SLLA), 'k', 'LineWidth', 4.5);
yline(mean(ma11SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('a) f. $d_F^2$, $\theta = (1,1)$')


nexttile;

hold on;

plot(angles, ma105SLLA);
plot(angles, ma105SLLR, '-.');
yline(mean(ma105SLLA), 'k', 'LineWidth', 4.5);
yline(mean(ma105SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('b) f. $d_F^2$, $\theta = (1,0.5)$')

nexttile;

hold on;

plot(angles, ma12SLLA);
plot(angles, ma12SLLR, '-.');
yline(mean(ma12SLLA), 'k', 'LineWidth', 4.5);
yline(mean(ma12SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('c) f. $d_F^2$, $\theta = (1,2)$')

nexttile;

hold on;

plot(angles, ma14SLLA);
plot(angles, ma14SLLR, '-.');
yline(mean(ma14SLLA), 'k', 'LineWidth', 4.5);
yline(mean(ma14SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('d) f. $d_F^2$, $\theta = (1,4)$')

legend({'SLLA', 'SLLR', 'MSLLA', 'MSLLR'}, 'Units', 'normalized', ...
    'Orientation', 'horizontal', 'Position', [.37 .48 .25 .04]);

%% second kernel
figure;
tiledlayout(2,2);
angles = TestDS.Data.angles';

nexttile;

hold on;

plot(angles, mb11SLLA);
plot(angles, mb11SLLR, '-.');
yline(mean(mb11SLLA), 'k', 'LineWidth', 4.5);
yline(mean(mb11SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('a) f. $d_E^2$, $\theta = (1,1)$')


nexttile;

hold on;

plot(angles, mb105SLLA);
plot(angles, mb105SLLR, '-.');
yline(mean(mb105SLLA), 'k', 'LineWidth', 4.5);
yline(mean(mb105SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('b) f. $d_E^2$, $\theta = (1,0.5)$')

nexttile;

hold on;

plot(angles, mb12SLLA);
plot(angles, mb12SLLR, '-.');
yline(mean(mb12SLLA), 'k', 'LineWidth', 4.5);
yline(mean(mb12SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('c) f. $d_E^2$, $\theta = (1,2)$')

nexttile;

hold on;

plot(angles, mb14SLLA);
plot(angles, mb14SLLR, '-.');
yline(mean(mb14SLLA), 'k', 'LineWidth', 4.5);
yline(mean(mb14SLLR), 'g-.', 'LineWidth', 4.5);
xlim([0 360]);
xlabel('$\alpha$ in $^\circ$');
ylabel('$SLL$');
title('d) f. $d_E^2$, $\theta = (1,4)$')

legend({'SLLA', 'SLLR', 'MSLLA', 'MSLLR'}, 'Units', 'normalized', ...
    'Orientation', 'horizontal', 'Position', [.37 .48 .25 .04]);
