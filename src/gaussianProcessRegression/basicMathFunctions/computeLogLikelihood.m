%% computeLogLikelihood
% Comuputes the marginal log likelihood as evidence of the current trained model
% parameter by solving the equation
% log p(y|X, alpha, log|Ky|) = -1/2 * (y - m)T * alpha - 1/2 log|Ky| - N/2 log(2pi)
% where alpha is the inverse matrix product of alpha = Ky^-1 * (y - m).
%
function lml = computeLogLikelihood(y, m, alpha, logDet, N)
    residual = y - m;
    lml = -0.5 * (residual' * alpha + logDet + N * log(2 * pi));
end

