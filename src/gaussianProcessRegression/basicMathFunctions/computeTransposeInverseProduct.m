%% computeTransposeInverseProduct
% Compute the product of an inverse matrix A with a vector or matrix b and its
% transpose C = BT * A^-1 * B = V' * V by linear solve the V = L\B with
% L * LT = A. L is the lower triangle matrix of the cholesky decomposed A
% matrix.
%
function C = computeTransposeInverseProduct(L, B)
    opts.LT = true;
    [M, N] = size(B);
    V = zeros(M, N);
    for n=1:N
        V(:,n) = linsolve(L, B(:,n), opts);
    end
    C = V' * V;
end

