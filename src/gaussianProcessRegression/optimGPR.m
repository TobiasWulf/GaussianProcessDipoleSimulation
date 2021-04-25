%% optimGPR
% Noise level optimization that implements optimized model by embedded kernel
% tuning process.
%
%
%% Syntax
%   Mdl = optimGPR(TrainDS, TestDS, GPROptions, verbose)
%
%
%% Description
% *Mdl = optimGPR(TrainDS, TestDS, GPROptions, verbose)* intiates regression
% model by training data and passed options. Solves min search via bayesopt for
% optimizing noise level. At each process step buit model is reinitiated and
% tuned to fit best on training data. The noise optimization can be performed by
% SLLA ans SLLR. Depends configuration of GPROptions. The loss computation is
% done on all forwarded test data.
%
%
%% Examples
%   load config.mat PathVariables GPROptions;
%   TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
%   TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
%   assert(~isempty(TrainFiles), 'No training datasets found.');
%   assert(~isempty(TestFiles), 'No test datasets found.');
%   try
%       TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
%       TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));
%   catch ME
%       rethrow(ME)
%   end
%   Mdl = optimGPR(TrainDS, TestDS, GPROptions, verbose);
%   [fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS)
%   [AAED, SLLA, SLLR, SEA, SER, SEC, SES] = lossDS(Mdl, TestDS);
%
%
%
%% Input Argurments
% *TrainDS* loaded training data by infront processesed sensor array simulation.
%
% *TestDS* loaded test data by infront processesed sensor array simulation.
%
% *GPROptions* loaded parameter group from config.mat. Struct with options.
%
% *verbose* activates prompt for true or 1. Vice versa for false or 0.
%
%
%% Output Argurments
% *Mdl* fully optimized model struct with tuned hyperparameters and optimized
% noise level.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: initGPR, tuneKernel, computeOptimCriteria, lossDS,
%   optimizableVariable, bayesopt
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'stats/bayesopt.html')) bayesopt>
% * <matlab:web(fullfile(docroot,'stats/optimizablevariable.html')) optimizablevariable>
% * <initGPR.html initGPR>
% * <tuneKernel.html tuneKernel>
% * <computeOptimCriteria.html computeOptimCriteria>
% * <lossDS.html lossDS>
%
%
% Created on March 05. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function Mdl = optimGPR(TrainDS, TestDS, GPROptions, verbose)
    
    % init model by training data and initial options
    Mdl = initGPR(TrainDS, GPROptions);
    
    % create noise variance s2n used in GPR with bounds 
    s2n = optimizableVariable('s2n', GPROptions.s2nBounds, 'Transform', 'log');
    
    % create function handle for bayes optimization
    SLL = GPROptions.SLL;
    fun = @(OptVar) computeOptimCriteria(OptVar, Mdl, TestDS, SLL, verbose);
    
    % perform bayes noise optimization
    results = bayesopt(fun, s2n, ...
        'Verbose', verbose, ...
        'MaxObjectiveEvaluations', GPROptions.OptimRuns, ...
        'AcquisitionFunctionName', 'expected-improvement-per-second');
    
    % update options with results and reinit model and tune to final model
    Mdl.s2n  = results.XAtMinObjective.s2n;
    Mdl = tuneKernel(Mdl, verbose);
    
    % compute final loss and get mean log loss for angles and radius as
    % indicator of model total model fit
    [~, SLLA, SLLR] = lossDS(Mdl, TestDS);
    Mdl.MSLLA = mean(SLLA);
    Mdl.MSLLR = mean(SLLR);
    
end
