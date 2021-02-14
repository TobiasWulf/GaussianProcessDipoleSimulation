%% computeInverseMAtrixProduct
% Computes the product of an inverted matrix K^-1 and a vector or matrix Y 
% to get a weight vectors alpha by solving the linear system by cholesky
% decomposed lower triangle matrix L of matrix K with L*LT = K.
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
function alpha = computeInverseMatrixProduct(L, Y)
    opts1.LT = true;
    opts2.UT = true;
    [M, N] = size(Y);
    alpha = zeros(M, N);
    for n = 1:N
         v = linsolve(L, Y(:,n), opts1);
         alpha(:,n) = linsolve(L', v, opts2);
    end
end
