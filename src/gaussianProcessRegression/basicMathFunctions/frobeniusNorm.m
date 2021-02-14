%% frobeniusNorm
% Norms a matrix with Frobenius Norm. If approx true the Frobenius norm is
% approximated with mean2. Works only for square matrix of size N x N.
%
%
%% Syntax
%   outputArg = functionName(positionalArg)
%   outputArg = functionName(positionalArg, optionalArg)
%
%
%% Description
% *outputArg = functionName(positionalArg)* detailed use case description.
%
% *outputArg = functionName(positionalArg, optionalArg)* detailed use case
% description.
%
%
%% Examples
%   Enter example matlab code for each use case.
%
%
%% Input Argurments
% *positionalArg* argurment description.
%
% *optionalArg* argurment description.
%
%
%% Output Argurments
% *outputArg* argurment description.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on Month DD. YYYY by Creator. Copyright Creator YYYY.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
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

