%% computeInverseMAtrixProduct
% Computes the product of an inverted matrix K^-1 and a vector y to get a weight
% vector alpha by solving the linear system by cholesky decomposed lower
% triangle matrix L of matrix K.
%
function alpha = computeInverseMatrixProduct(L, y)
    opts1.LT = true;
    opts2.UT = true;
    alpha = linsolve(L, y, opts1);
    alpha = linsolve(L', alpha , opts2);
end
