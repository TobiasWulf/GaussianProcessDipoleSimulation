%% tuneZeroMeanGRP
% Tunes zero mean GPR model hyperparameter s2f and sl as vector 
% theta = [s2n, sl]. Uses the negative sum of cosine and sine marginal log
% likelihoods as function minimum constraint.
%
function Mdl = tuneZeroMeanGPR(Mdl)

    % define options for minimum search
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    
    % setup problem for minimum solver use problem structure to feed fmincon
    problem.solver = 'fmincon';
    problem.options = options;
    
    % apply objective function and start values
    problem.objective = @(x) objective(x, Mdl);
    problem.x0 = Mdl.theta;
    
    % apply bounds to prevent overfitting
    problem.lb = [1, 1] * Mdl.thetaLU(1);
    problem.ub = [1, 1] * Mdl.thetaLU(2);
    
    % solve problem
    [Mdl.theta] = fmincon(problem);
    
    % reinit model
    Mdl = initZeroMeanKernel(Mdl);
end


% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative sum of both log liklihoods of the current model parameters.
% No assignments on model, just recalculate function evaluation minimum
function feval = objective(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta = theta;
    Mdl = initZeroMeanKernel(Mdl);
    
    % return function evaluation as neg. sum of likelihoods
    feval = -1 * (Mdl.LMLcos + Mdl.LMLsin);
end