%% addNoise2Covariance
% Add noise to covarianc matrix for noisy observations. Add noise along matrix
% diagonal.
%
function Ky = addNoise2Covariance(K, s2n)
    Ky = K + s2n * eye(size(K));
end