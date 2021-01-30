%% tuneIndividualGRP
% Tunes individual GPR model hyperparameter s2f and sl as vector 
% theta = [s2n, sl]. Uses the negative sum of cosine and sine marginal log
% likelihoods as function minimum constraint.
%
function Mdl = tuneIndividualGPR(Mdl)

    % define options for minimum search
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm', 'sqp');
    
    % setup problem for minimum solver use problem structure to feed fmincon
    problem.solver = 'fmincon';
    problem.options = options;
    
    % apply objective function and start values
    problem.objective = @(x) objectiveCos(x, Mdl);
    problem.x0 = Mdl.thetaCos;
    
    % apply bounds to prevent overfitting
    problem.lb = [1, 1] * Mdl.thetaLU(1);
    problem.ub = [1, 1] * Mdl.thetaLU(2);
    
    % solve problem
    [Mdl.thetaCos] = fmincon(problem);
    
    % redo for sine
    %problem.objective = @(x) objectiveSin(x, Mdl);
    %problem.x0 = Mdl.thetaSin;
    %[Mdl.thetaSin] = fmincon(problem);
    
    % reinit model
    Mdl = initIndividualKernel(Mdl);
end


% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative log liklihoods of the current model parameters for cosine.
% No assignments on model, just recalculate function evaluation minimum
function feval = objectiveCos(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.thetaCos = theta;
    Mdl = initIndividualKernel(Mdl);
    
    % return function evaluation as neg. sum of likelihoods
    feval = -1 * (Mdl.LMLsin + Mdl.LMLcos);
end

% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative log liklihoods of the current model parameters for sine.
% No assignments on model, just recalculate function evaluation minimum
function feval = objectiveSin(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.thetaSin = theta;
    Mdl = initIndividualKernel(Mdl);
    
    % return function evaluation as neg. sum of likelihoods
    feval = -1 * Mdl.LMLsin;
end