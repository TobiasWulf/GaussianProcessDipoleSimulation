%% computeInverseMAtrixProduct
% Computes the product of an inverted matrix K^-1 and a vector or matrix Y 
% to get a weight vectors alpha by solving the linear system by cholesky
% decomposed lower triangle matrix L of matrix K with L*LT = K.
%
function alpha = computeInverseMatrixProduct(L, Y)
    opts1.LT = true;
    opts2.UT = true;
    [M, N] = size(Y);
    alpha = zeros(M, N);
    for n = 1:N
         v = linsolve(L, Y(:,n), opts1);
         alpha(:,n) = linsolve(L', v, opts2);
    end
end
