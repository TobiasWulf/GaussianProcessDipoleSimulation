%% tuneKernel
% Tunes kernel hyperparameters of GPR model. Tune both parameters in theta if
% s2f = theta(1) not equal to 1.
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
