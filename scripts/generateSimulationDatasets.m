%% generateSimulationDatasets
% Generate sensor array simulation datasets for training and test applications.
% Loads needed configurations from config.mat and characterization data from
% defined characterization dataset (current: PathVariables.tdkDatasetPath).
% Simulated dataset are saved to data/training and data/test path. Generate
% dataset for a predefined configuration at once. Best use is to generate
% simulation data, do wish application or evaluation on it and save results.
% Delete datasets, edit configuration and rerun for a new set of datasets.
% 
%
%% Requirements
% * Other m-files required: simulateDipoleSquareSensorArray.m
% * Subfunctions: None
% * MAT-files required: config.mat, TDK_TAS2141_Characterization_2020-10-22_18-12-16-827.mat
%
%
%% See Also
% * <sensorArraySimulation.html sensorArraySimulation>
% * <simulateDipoleSquareSensorArray.html simulateDipoleSquareSensorArray>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on November 25. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%
%% Load Configuration and Characterization Dataset
% Load configuration to generate dataset from config.mat and defined
% characterization dataset.
try
    clearvars;
    close all;
    disp('Load configuration ...');
    load('config.mat', 'GeneralOptions', 'PathVariables', 'SensorArrayOptions', ...
        'DipoleOptions', 'TrainingOptions', 'TestOptions');
    disp('Load characterization dataset ...');
    TDK = load(PathVariables.tdkDatasetPath);
catch ME
    rethrow(ME)
end


%% Generate Training Datasets
% Generate training dataset from configuration and characterization dataset.
disp('Generate training datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TrainingOptions, TDK)


%% Generate Test Datasets
% Generate test dataset from configuration and characterization dataset.
disp('Generate test datasets ...');
simulateDipoleSquareSensorArray(GeneralOptions, PathVariables, ...
    SensorArrayOptions, DipoleOptions, TestOptions, TDK)
