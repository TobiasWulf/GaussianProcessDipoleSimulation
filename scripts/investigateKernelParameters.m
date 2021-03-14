%% investigateKernelParameters
% 
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
% * <optimGPR.html>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on March 13. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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
% At first clear all variables from workspace, close all open figures and clean
% prompt. Then loads configuration from config.mat and try to load training and
% test datasets. Finally check datasets for corresponding coordinates. Loading
% the first available datasets in training and test dataset path.
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

disp('Load first found datasets ...');
try
    TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
    TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));

catch ME
    rethrow(ME)
end

disp('Check dataset coordinates corresponds ...');
assert(all(TrainDS.Data.X == TestDS.Data.X, 'all'), 'Wrong X grid.');
assert(all(TrainDS.Data.Y == TestDS.Data.Y, 'all'), 'Wrong Y grid.');
assert(all(TrainDS.Data.Z == TestDS.Data.Z, 'all'), 'Wrong Z grid.');



%% Create GPR Modles for Investigation
disp('Create GPR modles ...');
Mdl1 = initGPR(TrainDS, GPROptions);

%% Screen Kernel Parameters
nEval = 200;
s2f = 1;
sl = linspace(2,30,nEval);
s2n = linspace(1e-9,1e-5,nEval);
[sl, s2n] = meshgrid(sl, s2n);
LML = zeros(nEval, nEval);




parfor i = 1:nEval
    for j = 1:nEval
        LML(i,j) = lmlFun([1 sl(i,j)], s2n(i,j), Mdl1);
    end
    
end

figure;
contourf(sl, s2n, LML, linspace(-10,max(LML,[],'all')-1,10))
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')


%% Evaluation Function by Logarithmic Marginal Likelihood
function lml = lmlFun(theta, s2n, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta = theta;
    Mdl.s2n = s2n;
    Mdl = initKernelParameters(Mdl);
    
    % return function evaluation as neg. likelihood of radius
    lml = (Mdl.LMLsin + Mdl.LMLcos);
end

function msll = msllFun(OptVar, TrainDS, TestDS, GPROptions, verbose)
    
    % push current variance value into GPR
    GPROptions.s2n = OptVar.s2n;
    Mdl = initGPR(TrainDS, GPROptions);
    
    % tune kernel with new noise variance
    Mdl = tuneKernel(Mdl, verbose);
    
    % get loss on dataset for angular prediction
    [~, SLLA] = lossDS(Mdl, TestDS);
    
    % return mean loss to evaluate optimization run
    msll = mean(SLLA);
end
