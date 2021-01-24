%% addNoise2Covariance
% Add noise to covarianc matrix for noisy observations. Add noise along matrix
% diagonal.
%
function Ky = addNoise2Covariance(K, sigma2N)
    Ky = K + sigma2N * eye(size(K));
end