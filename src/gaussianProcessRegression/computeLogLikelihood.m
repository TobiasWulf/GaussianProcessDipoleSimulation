%% computeLogLikelihood
% Comuputes the marginal log likelihood as evidence of the current trained model
% parameter by solving teh equation
% log p(y|X, alpha, log|Ky|) = -1/2 * (y - HT * beta)T * alpha - 1/2 log|Ky| - N/2 log(2pi)
% where alpha is the inverse matrix product of alpha = Ky^-1 * (y - HT * beta).
%
function lml = computeLogLikelihood(y, H, beta, alpha, logDetKy, N)
    residual = y - H' * beta;
    lml = -0.5 * (residual' * alpha + logDetKy + N * log(2 * pi));
end

