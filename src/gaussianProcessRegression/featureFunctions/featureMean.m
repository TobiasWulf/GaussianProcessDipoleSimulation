%% featureMean
% Mean or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of cos function.
%
function H = featureMean(X)
    [~, ~, N] = size(X);
    H = ones(2, N);
    for n = 1:N
        H(2,n) = mean2(X(:,:,n));
%         H(3,n) = H(2,n)^2;
%         H(4,n) = H(2,n)^3;
%         H(5,n) = H(2,n)^4;
%         H(6,n) = H(2,n)^5;
%         H(7,n) = H(2,n)^6;

    end
end
