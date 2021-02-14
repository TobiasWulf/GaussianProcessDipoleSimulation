%% computeSquareLogLoss
% Compute SLL loss between test targets and predictive mean dependend on
% predictive variance plus used variance for noisy covariance matrix as variance
% of normal distriubtion over predictive means s2 = fcov + s2n. The pred
% functions returns the standard deviation s so sqrt of the variance. 
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
function [SLL, SE, s2] = computeSquareLogLoss(y, fmean, s)
    
    % squared error
    SE = (y - fmean).^2;
    
    % s as standard deviation of nomal destributed fmean so square it for
    % variance.
    s2 = s.^2;
    
    % logaritmic error
    SLL = 0.5 * (log(2 * pi * s2) + SE ./ s2);
end

