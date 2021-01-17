%% cholDecomposeA2L
% Compute the Cholesky decomposition of a symmetrix positive definite matrix A
% and calculate the log determinate as side product of the decomposition. 
% Compute the lower triangle matrix L.
%
function [L, logDet] = cholDecomposeA2L(A)
    [L, flag] = chol(A, 'lower');
    assert(flag == 0);
    
    if nargout > 1
        logDet = 2 * sum(log(diag(L)));
    end
end