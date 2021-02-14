%% initGPR
% Initializes GPR model by passed trainings dataset and GPR options struct.
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
function Mdl = initGPR(TrainDS, GPROptions)
    
    % create model struct
    Mdl = struct();
    
    % init GPROptions on model struct
    Mdl = initGPROptions(Mdl, GPROptions);
    
    % init training data on model
    Mdl = initTrainDS(Mdl, TrainDS);
    
    % init kernel, covariance function, mean function and input transformation
    % function if needed, initGPROptions and initTrainDS must run before
    % initKernel otherwise missing parameters causing an error
    Mdl = initKernel(Mdl);
       
    % init model kernel with current hyperparameters, kernel must be initiated
    % before otherwise nonesens and errors
    Mdl = initKernelParameters(Mdl);
    
end