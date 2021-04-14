%% tuneKernel
% Tunes kernel hyperparameters of GPR model. Dismiss tuning for each kernel
% parameter by setting corresponding bounds to equal values.
%
%
%% Syntax
%   Mdl = tuneKernel(Mdl, verbose)
%
%
%% Description
% *Mdl = tuneKernel(Mdl, verbose)* solves the negative marginal logarithmic
% likelihood criteria with fmincon solver.
%
%
%% Input Argurments
% *Mdl* model struct.
%
% *verbose* activates prompt for true or 1. Vice versa for false or 0.
%
%
%% Output Argurments
% *Mdl* optimized hyperparameters and resulting regression model.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: fmincon, optimoptions, computeTuneCriteria,
%   initKernelParameters
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'optim/ug/fmincon.html')) fmincon>
% * <matlab:web(fullfile(docroot,'optim/ug/optim.problemdef.optimizationproblem.optimoptions.html')) optimoptions>
% * <computeTuneCriteria.html computeTuneCriteria>
% * <initKernelParameters.html initKernelParameters>
%
%
% Created on March 03. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function Mdl = tuneKernel(Mdl, verbose)

    % define options for minimum search
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp', ...
        'PlotFcn', {@optimplotx, @optimplotfval});
    
    % display tuning
    if verbose, options.Display = 'iter'; end
    
    % setup problem for minimum solver use problem structure to feed fmincon
    problem.solver = 'fmincon';
    problem.options = options;
    
    % apply bounds to prevent overfitting
    problem.lb = [Mdl.s2fBounds(1) Mdl.slBounds(1)];
    problem.ub = [Mdl.s2fBounds(2) Mdl.slBounds(2)];

    % set sl start value
    problem.x0 = Mdl.theta;

    % apply objective function and start values
    problem.objective = @(x) computeTuneCriteria(x, Mdl);

    % solve problem
    [Mdl.theta] = fmincon(problem);

    
    % reinit kernel with tuned parameters
    Mdl = initKernelParameters(Mdl);
end
