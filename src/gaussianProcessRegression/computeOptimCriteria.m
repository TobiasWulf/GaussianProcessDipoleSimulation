%% computeOptimCriteria
% object function to compute the loss of a fully initialized and tuned GPR model
% compute the mean squared log loss of angles MSLLA as function eval value
% perform noise adjustment in cylces in bayesopt
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
function MSLLA = computeOptimCriteria(OptVar, Mdl, TestDS, verbose)
    
    % push current variance value into GPR
    Mdl.s2n = OptVar.s2n;
    
    % tune kernel with new noise variance
    Mdl = tuneKernel(Mdl, verbose);
    
    % get loss on dataset for angular prediction
    [~, SLLA] = lossDS(Mdl, TestDS);
    
    % return mean loss to evaluate optimization run
    MSLLA = mean(SLLA);
end