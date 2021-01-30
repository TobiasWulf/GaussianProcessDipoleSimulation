%% initGPR
% Initializes GPR model by passed trainings dataset and GPR options struct.
%
function Mdl = initGPR(DS, options)
    
    % create model struct
    Mdl = struct();
    
    % attach options to model struct
    % enable disable mean function and correction
    if isfield(options, 'mean')
        Mdl.mean = option.mean;
    else
        Mdl.mean = 'off';
    end
    
    % 
end