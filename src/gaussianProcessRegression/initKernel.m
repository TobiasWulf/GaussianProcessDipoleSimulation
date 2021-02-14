%% initKernel
% Initiates kernel and choose from set options GPR model struct. Attaches the
% rigth kernel mean functions depending on options. Adjusts training data if
% approximation kernels are used in model.
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
function Mdl = initKernel(Mdl)
    
    % set covariance function and input function to respect covariance function
    % serve with right format of data, sets mean function which belongs to the
    % corresponding kernel model
    switch Mdl.kernel
        case 'QFC'
            Mdl = initQFC(Mdl);
            
        case 'QFCAPX'
            Mdl = initQFCAPX(Mdl);
            
        % end kernel select
        otherwise
            error('Unknown kernel function %.', Mdl.kernel);
    end
end

