%% computeAlphaWeights
% Computes alpha weights from feature space product HT*beta and target vector y
% as porduct with inverse covariance matrix with additve noise Ky^-1 represented
% by its cholesky decomposed lower triangle matrix L. Ky^-1 * (y - m(x)).
%
function alpha = computeAlphaWeights(L, y, m)
    residual = y - m;
    alpha = computeInverseMatrixProduct(L, residual);
end

