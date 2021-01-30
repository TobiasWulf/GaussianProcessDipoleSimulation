%% initIndividualGPR
% Initiates individual mean GPR model from passed training datset.
%
function Mdl = initIndividualGPR(DS)
    
    % set model type
    Mdl.Type = 'individualGPR';
    
    % N number of angles
    Mdl.N = DS.Info.UseOptions.nAngles;
    
    % D sensor array square dimension of DxD sensor array
    Mdl.D = DS.Info.SensorArrayOptions.dimension;
    
    % P number of predictors in sensor array
    Mdl.P = DS.Info.SensorArrayOptions.SensorCount;
    
    % get sensor type from dataset
    Mdl.Sensor = DS.Info.UseOptions.BaseReference;
    
    % choose period factor depending on sensor type
    % how many sinoid periods are abstract on a full rotation by 360°
    switch Mdl.Sensor
        case 'TDK'
            Mdl.pf = 1;
        
        case 'KMZ60'
            Mdl.pf = 2;
        
        otherwise
            error('Unkown Sensor %s.', Mdl.Sensor);
    end
    
    % get reference angles in degree and transpose to column vector
    Mdl.Degs = DS.Data.angles';

    % get sinoid target vectors depending period factor, transpose because
    % angles2sinoids works with row vectors
    [Mdl.Ysin, Mdl.Ycos, Mdl.Rads] = angles2sinoids(Mdl.Degs, ...
        false, Mdl.pf);
    
    % attach training data fro cosine and sine to model
    Mdl.Xcos = DS.Data.Vcos;
    Mdl.Xsin = DS.Data.Vsin;
    
    % initial model hyperparameters as parameter row vector for covariance
    % function params argument, first s2f and as second sl
    Mdl.thetaCos = [Mdl.D, Mdl.P];
    %Mdl.thetaSin = [Mdl.D, Mdl.P];
    
    % set lower and upper bounds for tuning theta to prevent overfitting 
    Mdl.thetaLU = [1e-3 , 1e2];
    
    % initial noise variance to generalize the covariance matrix
    Mdl.s2nCos = 1e-5;
    %Mdl.s2nSin = 1e-5;
    
    % set lower and upper bounds for tuning noise s2n to prevent overfitting 
    Mdl.s2nLU = [1e-4 , 1e1];
    
    % attach kernel function to model
    Mdl.kernel = @quadraticFrobeniusCovariance;
    
    % attach feature function to model
    Mdl.feature = @featureMean;
    
    % init kernel with set parameters
    Mdl = initIndividualKernel(Mdl);
end

