%% tuneKernel
% Tunes kernel hyperparameters of GPR model. Tune both parameters in theta if
% s2f = theta(1) not equal to 1.
%
function Mdl = tuneKernel(Mdl)

    % define options for minimum search
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    
    % setup problem for minimum solver use problem structure to feed fmincon
    problem.solver = 'fmincon';
    problem.options = options;
    
    % check if s2f is equal to 1 or not an initialize the problem
    if Mdl.theta(1) == 1
        % apply bounds to prevent overfitting
        problem.lb = Mdl.thetaBounds(1);
        problem.ub = Mdl.thetaBounds(2);
        
        % set sl start value
        problem.x0 = Mdl.theta(2);
        
        % apply objective function and start values
        problem.objective = @(x) tuneLengthScale(x, Mdl);
        
        % solve problem
        [Mdl.theta(2)] = fmincon(problem);
    
    else
        % apply bounds to prevent overfitting
        problem.lb = [1 1] * Mdl.thetaBounds(1);
        problem.ub = [1 1] * Mdl.thetaBounds(2);
        
        % set sl start value
        problem.x0 = Mdl.theta;
        
        % apply objective function and start values
        problem.objective = @(x) tuneBothScales(x, Mdl);
        
        % solve problem
        [Mdl.theta] = fmincon(problem);
    end
    
    % reinit kernel with tuned parameters
    Mdl = initKernelParameters(Mdl);
end


% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative log liklihoods of the current model parameters.
% No assignments on model, just recalculate function evaluation minimum.
function feval = tuneLengthScale(sl, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta(2) = sl;
    Mdl = initKernelParameters(Mdl);
    
    % return function evaluation as neg. likelihood of radius
    feval = -1 * (Mdl.LMLsin + Mdl.LMLcos);
end

function feval = tuneBothScales(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta = theta;
    Mdl = initKernelParameters(Mdl);
    
    % return function evaluation as neg. likelihood of radius
    feval = -1 * (Mdl.LMLsin + Mdl.LMLcos);
end
