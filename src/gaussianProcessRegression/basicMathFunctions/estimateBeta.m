%% estimateBeta
% Find beta coefficients to feature matrix H and the current set of
% hyperparameters theta as vector of sigma2F and sigmaL, sigma2N represented by
% the current inverse of noisy covariance matrix Ky^-1 and the feature target
% vector y of the observations. It calculates several inverse Matrix products so
% instead passing the current Ky the function uses the infront decomposed lower
% triangle matrix L of Ky.
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
function [beta, alpha0]= estimateBeta(H, L, y)
    % Ky^-1 * y
    alpha0 = computeInverseMatrixProduct(L, y);
    
    % H * Ky^-1 * HT
    alpha1 = computeTransposeInverseProduct(L, H');
     
    % (H * Ky^-1 * HT)^-1 * H
    L1 = chol(alpha1, 'lower');
    alpha2 = computeInverseMatrixProduct(L1, H);
    
    % ((H * (Ky^-1 * HT))^-1 * H) * (Ky^-1 * y)
    beta = alpha2 * alpha0;
end
