%% tuneKernel
% Tunes kernel hyperparameters of GPR model.
%
function Mdl = tuneKernel(Mdl)

    % define options for minimum search
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    
    % setup problem for minimum solver use problem structure to feed fmincon
    problem.solver = 'fmincon';
    problem.options = options;
    
    % apply objective function and start values
    problem.objective = @(x) objectiveFun(x, Mdl);
    problem.x0 = Mdl.theta(2);
    
    % apply bounds to prevent overfitting
    problem.lb = Mdl.thetaBounds(1);
    problem.ub = Mdl.thetaBounds(2);
    
    % solve problem
    [Mdl.theta(2)] = fmincon(problem);
    
    % reinit kernel with tuned parameters
    Mdl = initKernelParameters(Mdl);
end


% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative log liklihoods of the current model parameters.
% No assignments on model, just recalculate function evaluation minimum.
function feval = objectiveFun(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta(2) = theta;
    Mdl = initKernelParameters(Mdl);
    
    % return function evaluation as neg. likelihood of radius
    feval = -1 * (Mdl.LMLsin + Mdl.LMLcos);
end
