%% computeAlphaWeights
% Computes alpha weights from feature space product HT*beta and target vector y
% as porduct with inverse covariance matrix with additve noise Ky^-1 represented
% by its cholesky decomposed lower triangle matrix L. Ky^-1 * (y - m(x)).
%
%
%% Syntax
%   alpha = computeAlphaWeights(L, y, m)
%
%
%% Description
% *alpha = computeAlphaWeights(L, y, m)* prepare data and forward it to
% matrix computation.
%
%
%% Input Argurments
% *L* lower triangle matrix of cholesky decomposed K matrix.
%
% *y* regression target vector.
%
% *m* regression mean vector.
%
%
%% Output Argurments
% *alpha* regression weights.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: computeInverseMatrixProduct
% * MAT-files required: None
%
%
%% See Also
% * <decomposeChol.html decomposeChol>
% * <computeInverseMatrixProduct.html computeInverseMatrixProduct>
% * <initKernelParameters.html initKernelParameters>
%
%
% Created on November 06. 2019 by Klaus Juenemann. Copyright Klaus Juenemann 2019.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on January 05. 2021 by Tobias Wulf: Own function and add residual.
% Edited on January 05. 2021 by Tobias Wulf: Add argument validation.
% -->
% </html>
%
function alpha = computeAlphaWeights(L, y, m)
    % get residual
    residual = y - m;
    % L and residual is validated in computation below, get weights
    alpha = computeInverseMatrixProduct(L, residual);
end

