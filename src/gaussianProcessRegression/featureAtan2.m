%% featureAtan2
% Mean or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of atan2 function.
%
function H = featureAtan2(Xcos, Xsin)
    assert(all(size(Xcos) == size(Xsin)));
    [D1, D2, N] = size(Xcos);
    H = zeros(D1 * D2, N);
    for n = 1:N
        h = atan2(Xsin(:,:,n), Xcos(:,:,n));
        H(:, n) = h(:);
    end
    H = [ones(1,N); H];
end
