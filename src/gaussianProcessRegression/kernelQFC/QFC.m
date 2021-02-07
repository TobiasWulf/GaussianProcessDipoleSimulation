%% QFC
% Kernel, covariance function for 3 dimensional matrices DxDxN where N is
% the dimension of observeration and DxD is a matrix of P predictors at
% each observation. Each for cosine and sine observation. It is needed to
% establish a combined kernel function because cosine and sine function are
% not independent from each and another. They are a separated
% representation of same tangent angle one the unit circle so each
% predictor variance should be additive correalate in each cosine and sine
% representation. Cosine and sine are orthogonal vectors of the same
% system. Therfore the Matrix norm aims the distance of the tangence function
% decomposed as vector field norm of its orthoganl components as sum of two
% matrix norm represented by a norm of cosine and sine.
% The sensor array implements the predictors in a square array shape so it
% is needed to norm the distances between observations with matrix norm and
% with eucledian norms which distances between points. So it is possible to
% the quadratic Frobeniusnorm to norm matrices distance.
% Quadratic to ommit complex values in results.
% In fact the kernel or covariance function is a sum of 2 quadratic
% frobenius norm distances each for cosine and sine for n-th observation
% with same length scale sigmaL and variance sigmaF2 to engage the
% dependency of cosine and sine orthogonality.
% The function must be producing a NxN positive symmetric covariance matrix
% K in the training phase to apply cholesky decomposition on it to compute
% the inverse of the matrix and solve the linear system to generates alpha
% vectors for cosine and sine prediction each. In the prediction phase
% (application) it computes the MxN matrix K for test inputs of size DxDxM
% and training points size of DxDxN. If it is a single test point so DxDx1
% matrix the function computes the covariance vector of size 1xN of the
% test to each training observation. Computes noise free covariances.
%
function K = QFC(Ax, Bx, Ay, By, theta)
    
    
    % get number of observations for each dataset, cosine and sine matrices have
    % equal sizes just extract size from one
    [~, ~, M] = size(Ax);
    [~, ~, N] = size(Bx);
    
    % expand covariance parameters, variance and lengthscale
    c = 2 * theta(2)^2; % 2*sl^2
    a = theta(1) * c;   % s2f * c
    
    % allocate memory for K
    K = zeros(M, N);
    
    % loop through observation points and compute the covariance for each
    % observation against another
    for m = 1:M
        for n = 1:N
            % get distance between m-th and n-th observation
            distCos = Ax(:,:,m) - Bx(:,:,n);
            distSin = Ay(:,:,m) - By(:,:,n);
            
            % compute quadratic frobenius norm of tan distance as separated
            % distances of cosine and sine, norm of vector fields
            r2 = sum(distCos .^ 2 , 'all') + sum(distSin .^ 2 , 'all');
            
            % engage lengthscale and variance on distance
            K(m,n) = a / (c + r2);
            
        end
    end
end

