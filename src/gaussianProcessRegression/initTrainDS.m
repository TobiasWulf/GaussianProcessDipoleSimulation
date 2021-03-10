%% initTrainDS
% Initiates needed data from training dataset to GPR model struct. Builds target
% vectors GPR depending on sensor used sensor type in training dataset
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
function Mdl = initTrainDS(Mdl, TrainDS)
    
    % set model parameters from training dataset and training data dependencies
    % N number of angles and refernces in degree
    Mdl.N = TrainDS.Info.UseOptions.nAngles;
    Mdl.Angles = TrainDS.Data.angles';
    
    % D sensor array square dimension of DxD sensor array
    Mdl.D = TrainDS.Info.SensorArrayOptions.dimension;
    
    % P number of predictors in sensor array
    Mdl.P = TrainDS.Info.SensorArrayOptions.SensorCount;
    
    % get sensor type from dataset
    Mdl.Sensor = TrainDS.Info.UseOptions.BaseReference;
    
    % choose period factor depending on sensor type
    % how many sinoid periods are abstract on a full rotation by 360°
    switch Mdl.Sensor
        case 'TDK'
            Mdl.PF = 1;
        
        case 'KMZ60'
            Mdl.PF = 2;
        
        otherwise
            error('Unkown Sensor %s.', Mdl.Sensor);
    end
    
    % get reference angles in degree and transpose to column vector
    % get sinoid target vectors depending period factor,
    % transpose because angles2sinoids works with row vectors
    [Mdl.Ysin, Mdl.Ycos] = angles2sinoids(Mdl.Angles, ...
        false, Mdl.PF);
    
    % attach training data fro cosine and sine to model
    Mdl.Xcos = TrainDS.Data.Vcos;
    Mdl.Xsin = TrainDS.Data.Vsin;
end

