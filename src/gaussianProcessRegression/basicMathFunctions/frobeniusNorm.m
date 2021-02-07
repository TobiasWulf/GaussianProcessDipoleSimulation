%% frobeniusNorm
% Norms a matrix with Frobenius Norm. If approx true the Frobenius norm is
% approximated with mean2. Works only for square matrix of size N x N.
%

function nv = frobeniusNorm(A, approx)
    
    % norm matrix
    if approx
        % approximate frobenis with mean and multiply with radicant of RMS
        % frobenius norm is a RMS * sqrt(N x N), RMS >= mean
        nv = mean2(A) * size(A,1);
    else
        % norm with frobenius
        nv = sqrt(sum(A.^2, 'all'));
    end
end

