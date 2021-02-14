%% computeLogLikelihood
% Comuputes the marginal log likelihood as evidence of the current trained model
% parameter by solving the equation
% log p(y|X, alpha, log|Ky|) = -1/2 * (y - m)T * alpha - 1/2 log|Ky| - N/2 log(2pi)
% where alpha is the inverse matrix product of alpha = Ky^-1 * (y - m).
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
function lml = computeLogLikelihood(y, m, alpha, logDet, N)
    residual = y - m;
    lml = -0.5 * (residual' * alpha + logDet + N * log(2 * pi));
end

