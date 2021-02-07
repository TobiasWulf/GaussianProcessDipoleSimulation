%% initTrainDS
% Initiates needed data from training dataset to GPR model struct. Builds target
% vectors GPR depending on sensor used sensor type in training dataset
%
function Mdl = initTrainDS(Mdl, TrainDS)
    
    % set model parameters from training dataset and training data dependencies
    % N number of angles
    Mdl.N = TrainDS.Info.UseOptions.nAngles;
    
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
    [Mdl.Ysin, Mdl.Ycos, Mdl.Yrads] = angles2sinoids(TrainDS.Data.angles', ...
        false, Mdl.PF);
    
    % the angular prediction is working on unit circle so cricle niveau must be
    % one for all angles sin^2 + cos^2 = 1
    Mdl.Yradius = ones(Mdl.N, 1);

    % attach training data fro cosine and sine to model
    Mdl.Xcos = TrainDS.Data.Vcos;
    Mdl.Xsin = TrainDS.Data.Vsin;
end

