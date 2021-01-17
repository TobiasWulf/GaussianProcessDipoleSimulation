%% estimateBeta
% Find beta coefficients to feature matrix H and the current set of
% hyperparameters theta as vector of sigma2F and sigmaL, sigma2N represented by
% the current inverse of noisy covariance matrix Ky^-1 and the feature target
% vector y of the observations. It calculates several inverse Matrix products so
% instead passing the current Ky the function uses the infront decomposed lower
% triangle matrix L of Ky.
%
function beta = estimateBeta(H, L, y)
    alpha0 = computeInverseMatrixProduct(L, y);
    Alpha1 = zeros(size(H'));
    for n=1:length(H')
        Alpha1(:,n) = computeInverseMatrixProduct(L, H(n,:)');
    end
    Alpha2 = H * Alpha1;
    beta = Alpha2;
end
