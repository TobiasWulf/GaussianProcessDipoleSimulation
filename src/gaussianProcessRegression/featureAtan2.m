%% featureAtan2
% Mean or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space of atan2 function.
%
function H = featureAtan2(Xcos, Xsin, offset)
    assert(all(size(Xcos) == size(Xsin)));
    [~, ~, N] = size(Xcos);
    H = ones(2, N);
    for n = 1:N
        y = mean2(Xsin(:,:,n)) - offset(2);
        x = mean2(Xcos(:,:,n)) - offset(1);
        H(2,n) = atan2(y, x);
%         H(3,n) = H(2,n)^2;
%         H(4,n) = H(2,n)^3;
%         H(5,n) = H(2,n)^4;
%         H(6,n) = H(2,n)^5;
%         H(7,n) = H(2,n)^6;

    end
end
