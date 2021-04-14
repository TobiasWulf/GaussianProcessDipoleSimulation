%% initGPR
% Initializes GPR model by passed trainings dataset and GPR options struct.
%
%
%% Syntax
%   Mdl = initGPR(TrainDS, GPROptions)
%
%
%% Description
% *Mdl = initGPR(TrainDS, GPROptions)* sequential initializing.
%
%
%% Examples
%   load config.mat PathVariables GPROptions;
%   TrainFiles = dir(fullfile(PathVariables.trainingDataPath, 'Training*.mat'));
%   TestFiles = dir(fullfile(PathVariables.testDataPath, 'Test*.mat'));
%   assert(~isempty(TrainFiles), 'No training datasets found.');
%   assert(~isempty(TestFiles), 'No test datasets found.');
%   try
%       TrainDS = load(fullfile(TrainFiles(1).folder, TrainFiles(1).name));
%       TestDS = load(fullfile(TestFiles(1).folder, TestFiles(1).name));
%   catch ME
%       rethrow(ME)
%   end
%   Mdl = initGPR(TrainDS, GPROptions);
%   [fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS)
%
%
%% Input Argurments
% *TrainDS* loaded training data by infront processesed sensor array simulation.
%
% *GPROptions* loaded parameter group from config.mat. Struct with options.
%
%
%% Output Argurments
% *Mdl* bare initialized model struct with no further optimization.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: initGPROptions, initTrainDS, initKernel, initKernelParameters
% * MAT-files required: config.mat, Train_*.mat
%
%
%% See Also
% * <initGPROptions.html initGPROptions>
% * <initTrainDS.html initTrainDS>
% * <initKernel.html initKernel>
% * <initKernelParameters.html initKernelParameters>
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