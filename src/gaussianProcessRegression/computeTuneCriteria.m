%% computeTuneCriteria
% objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation estimates the minimum of
% the negative log liklihoods of the current model parameters.
% No assignments on model, just recalculate function evaluation minimum.
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
function feval = computeTuneCriteria(theta, Mdl)
    % reinit kernel on new theta kernel parameters
    Mdl.theta = theta;
    Mdl = initKernelParameters(Mdl);
    
    % return function evaluation as neg. likelihood of radius
    feval = -1 * (Mdl.LMLsin + Mdl.LMLcos);
end