%% initKernel
% Initiates kernel and choose from set options GPR model struct. Attaches the
% rigth kernel mean functions depending on options. Adjusts training data if
% approximation kernels are used in model.
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

