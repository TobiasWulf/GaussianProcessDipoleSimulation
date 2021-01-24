%% tuneHyperparameters
% Tunes hyperparameters of GPR model and update it in return.
%
function [Model, feval] = tuneHyperparameters(Model)
    % define options for minimum search
    options = optimoptions('fmincon', ...
        'Display', 'iter', ...
        'Algorithm', 'sqp');
    
    problem.solver = 'fmincon';
    problem.options = options;
    problem.objective = @(x) evalNoneCase(x, Model);
    problem.x0 = Model.theta;
    problem.lb = [1e-3, 1e-3];
    problem.ub = [1e2, 1e2];
    [Model.theta, feval] = fmincon(problem);

end

% Eval functions
function fmin = evalNoneCase(theta, Model)
    % compute covariance matrix in two steps first without noise
    Ky = Model.covFun(Model.Xcos, Model.Xcos, Model.XtrainSin, Model.XtrainSin, theta);
    
    % second step add noise
    Ky = addNoise2Covariance(Ky, Model.sigma2N);
    
    % decompose Ky and get lower trinagle matrix and log determinate
    [L, logDetKy] = cholDecomposeA2L(Ky);
    
    % compute weights for cosine and sine
    alphaCos = computeAlphaWeights(L, Model.YtrainCos, 0, 0);
    alphaSin = computeAlphaWeights(L, Model.YtrainSin, 0, 0);
    
    % compute log likelihoods for each cosine and sine
    llCos = computeLogLikelihood(Model.YtrainCos, 0, 0, alphaCos, ...
        logDetKy, Model.N);
    llSin = computeLogLikelihood(Model.YtrainSin, 0, 0, alphaSin, ...
        logDetKy, Model.N);
    
    % take eval function mean as negative sum of both likelihoods
    fmin = -1 * (llCos + llSin);
end