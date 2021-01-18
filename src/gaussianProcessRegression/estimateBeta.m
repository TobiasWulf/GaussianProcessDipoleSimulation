%% estimateBeta
% Find beta coefficients to feature matrix H and the current set of
% hyperparameters theta as vector of sigma2F and sigmaL, sigma2N represented by
% the current inverse of noisy covariance matrix Ky^-1 and the feature target
% vector y of the observations. It calculates several inverse Matrix products so
% instead passing the current Ky the function uses the infront decomposed lower
% triangle matrix L of Ky.
%
function beta = estimateBeta(H, L, y)
    % Ky^-1 * y
    alpha0 = computeInverseMatrixProduct(L, y);
    
    % Ky^-1 * HT
    [P, N] = size(H);
    alpha1 = zeros(N, P);
    for p=1:P
        alpha1(:,p) = computeInverseMatrixProduct(L, H(p,:)');
    end
    
    % H * Ky^-1 * HT
    alpha2 = H * alpha1;
    
    % (H * Ky^-1 * HT)^-1 * H
    L2 = chol(alpha2, 'lower');
    alpha3 = zeros(P, N);
    for n = 1:N
        alpha3(:,n) = computeInverseMatrixProduct(L2, H(:,n));
    end
    
    % ((H * (Ky^-1 * HT))^-1 * H) * (Ky^-1 * y)
    beta = alpha3 * alpha0;
end
