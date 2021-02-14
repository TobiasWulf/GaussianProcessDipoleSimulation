%% computeTransposeInverseProduct
% Compute the product of an inverse matrix A with a vector or matrix b and its
% transpose C = BT * A^-1 * B = V' * V by linear solve the V = L\B with
% L * LT = A. L is the lower triangle matrix of the cholesky decomposed A
% matrix.
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
function C = computeTransposeInverseProduct(L, B)
    opts.LT = true;
    [M, N] = size(B);
    V = zeros(M, N);
    for n=1:N
        V(:,n) = linsolve(L, B(:,n), opts);
    end
    C = V' * V;
end

