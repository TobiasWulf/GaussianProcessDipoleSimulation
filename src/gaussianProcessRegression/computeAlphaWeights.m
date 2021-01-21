%% computeAlphaWeights
% Computes alpha weights from feature space product HT*beta and target vector y
% as porduct with inverse covariance matrix with additve noise Ky^-1 represented
% by its cholesky decomposed lower triangle matrix L. Ky^-1 * (y - HT * beta).
%
function alpha = computeAlphaWeights(L, y, H, beta)
    residual = y - H' * beta;
    alpha = computeInverseMatrixProduct(L, residual);
end

