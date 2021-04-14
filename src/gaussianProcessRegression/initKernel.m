%% initKernel
% Initiates kernel and chooses kernel implementation by initiated GPR options.
%
%
%% Syntax
%   Mdl = initKernel(Mdl)
%
%
%% Description
% *Mdl = initKernel(Mdl)* loads kernel submodule by passed identifier.
%
%
%% Input Argurments
% *Mdl* model struct.
%
%
%% Output Argurments
% *Mdl* with attached kernel functionality.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <initGPR.html initGPR>
% * <kernelQFC.html kernelQFC>
% * <kernelQFCAPX.html kernelQFCAPX>
%
%
% Created on February 20. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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

