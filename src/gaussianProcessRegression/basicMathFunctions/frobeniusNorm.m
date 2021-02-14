%% frobeniusNorm
% Computes the Frobenius Norm of a matrix.
%
%
%% Syntax
%   nv = frobeniusNorm(A, approx)
%
%
%% Description
% *frobeniusNorm(A, approx)* computes Frobenius Norm of M x N matrix. If approx
% is true the Norm is approximated with mean2 function.
%
%
%% Examples
%   A = magic(8);
%   nv = frobeniusNorm(A, approx)
%
%
%% Input Argurments
% *A* is a M x N matrix of real values.
%
% *apporx* is boolean flag. If true the norm is approximated. Default is false.
%
%
%% Output Argurments
% *nv* is a scalar norm value.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: mean2, sqrt, sum
% * MAT-files required: None
%
%
%% See Also
% * <QFCAPX.html QFCAPX>
% * <meanPolyQFC.html meanPolyQFC>
%
%
% Created on January 05. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function nv = frobeniusNorm(A, approx)
    arguments
        % validate A as real matrix
        A (:,:) double {mustBeReal}
        % validate approx as flag with default false
        approx (1,1) logical {mustBeNumericOrLogical} = false
    end
    
    % norm matrix
    if approx
        % approximate frobenis with mean and multiply with radicant of RMS
        % frobenius norm is a RMS * sqrt(N x N), RMS >= mean
        nv = mean2(A) * sqrt(numel(A));
    else
        % norm with frobenius
        nv = sqrt(sum(A.^2, 'all'));
    end
end
