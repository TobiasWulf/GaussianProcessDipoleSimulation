%% initGPR
% Initializes GPR model by passed trainings dataset and GPR options struct.
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