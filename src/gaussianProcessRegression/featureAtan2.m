%% featureAtan2
% Mean or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of atan2 function.
%
function H = featureAtan2(Xcos, Xsin)
    assert(all(size(Xcos) == size(Xsin)));
    [~, ~, N] = size(Xcos);
    H = ones(2, N);
    for n = 1:N
        H(2, n) = atan2(mean2(Xsin(:,:,n)), mean2(Xcos(:,:,n)));
    end
end
