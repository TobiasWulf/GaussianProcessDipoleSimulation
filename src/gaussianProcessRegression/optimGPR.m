%% optimGPR
%
%
%% Syntax
%   outputArg = functionName(positionalArg)
%   outputArg = functionName(positionalArg, optionalArg)
%
%
%% Description
% *outputArg = functionName(positionalArg)* detailed use case description.
%
% *outputArg = functionName(positionalArg, optionalArg)* detailed use case
% description.
%
%
%% Examples
%   Enter example matlab code for each use case.
%
%
%% Input Argurments
% *positionalArg* argurment description.
%
% *optionalArg* argurment description.
%
%
%% Output Argurments
% *outputArg* argurment description.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on Month DD. YYYY by Creator. Copyright Creator YYYY.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function Mdl = optimGPR(TrainDS, TestDS, GPROptions, verbose)
    
    % create noise variance s2n used in GPR with bounds 
    s2n = optimizableVariable('s2n', GPROptions.s2nBounds, 'Transform', 'log');
    
    % create function handle for bayes optimization
    fun = @(x) optimNoise(x, TrainDS, TestDS, GPROptions, verbose);
    
    % perform bayes noise optimization
    results = bayesopt(fun, s2n, ...
        'Verbose', verbose, ...
        'MaxObjectiveEvaluations', 100, ...
        'AcquisitionFunctionName', 'expected-improvement-per-second');
    
    % update options with results and reinit model and tune to final model
    GPROptions.s2n = results.XAtMinObjective.s2n;
    Mdl = initGPR(TrainDS, GPROptions);
    Mdl = tuneKernel(Mdl, verbose);
    
    % compute final loss and get mean log loss for angles and radius as
    % indicator of model total model fit
    [~, SLLA, SLLR] = lossDS(Mdl, TestDS);
    Mdl.MSLLA = mean(SLLA);
    Mdl.MSLLR = mean(SLLR);
    
end

% object function to compute the loss of a fully initialized and tuned GPR model
% compute the mean squared log loss of angles MSLLA as function eval value
% perform noise adjustment in cylces in bayesopt
function MSLLA = optimNoise(OptVar, TrainDS, TestDS, GPROptions, verbose)
    
    % push current variance value into GPR
    GPROptions.s2n = OptVar.s2n;
    Mdl = initGPR(TrainDS, GPROptions);
    
    % tune kernel with new noise variance
    Mdl = tuneKernel(Mdl, verbose);
    
    % get loss on dataset for angular prediction
    [~, SLLA] = lossDS(Mdl, TestDS);
    
    % return mean loss to evaluate optimization run
    MSLLA = mean(SLLA);
end