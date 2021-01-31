%% initGPR
% Initializes GPR model by passed trainings dataset and GPR options struct.
%
function Mdl = initGPR(DS, options)
    
    % create model struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Mdl = struct();
    
    % set model parameters from training dataset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % N number of angles
    Mdl.N = DS.Info.UseOptions.nAngles;
    
    % D sensor array square dimension of DxD sensor array
    Mdl.D = DS.Info.SensorArrayOptions.dimension;
    
    % P number of predictors in sensor array
    Mdl.P = DS.Info.SensorArrayOptions.SensorCount;
    
    % get sensor type from dataset
    Mdl.Sensor = DS.Info.UseOptions.BaseReference;
    
    % training data dependencies %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    Mdl.Degs = DS.Data.angles';

    % get sinoid target vectors depending period factor, transpose because
    % angles2sinoids works with row vectors
    [Mdl.Ysin, Mdl.Ycos, Mdl.Rads] = angles2sinoids(Mdl.Degs, ...
        false, Mdl.PF);
    
    % attach training data fro cosine and sine to model
    Mdl.Xcos = DS.Data.Vcos;
    Mdl.Xsin = DS.Data.Vsin;
    
    % attach options to model struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % enable disable mean function and correction
    if isfield(options, 'mean')
        Mdl.mean = options.mean;
    else
        Mdl.mean = 'zero';
    end
    
    % set mean function to compute cosine and sine H matrix
    switch Mdl.mean
        case 'zero'
            Mdl.meanFun = @(X) zeros(size(X,3), 1);
            
        case 'linear'
            Mdl.meanFun = @meanLinear;
            
        otherwise
            error('Unknown mean function %.', Mdl.mean);
    end
            
    % set kernel function option 
    if isfield(options, 'kernel')
        Mdl.kernel = options.kernel;
    else
        Mdl.kernel = 'QFC';
    end
    
    % set covariance function to compute covariance matrix
    switch Mdl.kernel
        case 'QFC'
            Mdl.kernelFun = @quadraticFrobenius;
            
        otherwise
            error('Unknown kernel function %.', Mdl.kernel);
    end
    
    % attach hyperparameters to model and bounds for tuning and model
    % optimization
    % theta covariance function parameter theta = [s2f, sl]
    if isfield(options, 'theta')
        Mdl.theta = options.theta;
    else
        Mdl.theta = [Mdl.D, Mdl.P];
    end
    
    % lower and upper bound for tuning theta
    if isfield(options, 'thetaBounds')
        Mdl.thetaBounds = options.thetaBounds;
    else
        Mdl.thetaBounds = [1e-2, 1e2];
    end
    
    % noise variance s2n to predict noisy observations
    if isfield(options, 's2n')
        Mdl.s2n = options.s2n;
    else
        Mdl.s2n = 1e-5;
    end
    
    % lower and upper bounds for optimizing s2n
    if isfield(options, 's2nBounds')
        Mdl.s2nBounds = options.s2nBounds;
    else
        Mdl.s2nBounds = [1e-4, 10];
    end
    
    % init model kernel with current hyperparameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
end