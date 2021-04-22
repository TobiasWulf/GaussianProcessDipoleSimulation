%% computeTuneCriteria
% Objective function to solve minimum constraint problem, delivers negative
% function values to search minimum function evaluation. Estimates the minimum
% of the negative logaritmic marginal liklihoods for current model parameters.
% No assignments on model, just recalculate function evaluation minimum.
%
%
%% Syntax
%   feval = computeTuneCriteria(theta, Mdl)
%
%
%% Description
% *feval = computeTuneCriteria(theta, Mdl)* sets new kernel parameter,
% reinitiates model and calculates min criteria by likelihoods.
%
%
%% Input Argurments
% *theta* kernel parameter vector.
%
% *Mdl* model struct to reinitiate.
%
%
%% Output Argurments
% *feval* function evaluation value.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: initKernelParameters
% * MAT-files required: None
%
%
%% See Also
% * <tuneKernel.html tuneKernel>
% * <initKernelParameters.html initKernelParameters>
%
%
% Created on March 03. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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