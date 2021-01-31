%% meanLinear
% Mean or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of cos function.
%
function H = meanLinear(X)
    [~, ~, N] = size(X);
    H = ones(2, N);
    for n = 1:N
        H(2,n) = mean2(X(:,:,n));
    end
end
