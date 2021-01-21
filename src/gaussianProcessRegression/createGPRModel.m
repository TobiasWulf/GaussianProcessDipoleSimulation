%% createGPRModel
% Create and tune GPR model depend on feature and how many target vectors are
% passed in Y. If more than one vector is passed in Y the first one corresponds
% to Xcos and second one to Xsin. For feature atan2 only one target vector must
% be passed. If two target vectors are passed Y for each column must have a
% corresponding sigma as row vector otherwise pass a scalar for sigma.
%
function Model = createGPRModel(XtrainCos, XtrainSin, Ytrain, sigma, feature)
    % create Model struct
    Model = struct();
    
    % add training observations to model
    Model.XtrainCos = XtrainCos;
    Model.XtrainSin = XtrainSin;
    Model.Ytrain = Ytrain;
    
    % add dimensions of observations to model
    all(size(XtrainCos) == size(XtrainSin));
    [Model.mX, Model.nX, Model.nY] = size(XtrainCos);
    Model.mY = size(Ytrain, 2); 
    assert(Model.nY == size(Ytrain, 1));
       
    % covariance function to model
    Model.covFun = @(XcosM, XcosN, XsinM, XsinN, params) ...
        quadraticFrobeniusCovariance(XcosM, XcosN, XsinM, XsinN, params);
    
    % define model feature space if its runs to mean or trend functions or none
    % set initial hyperparemters to each case
    switch feature
        % compute GPR with m(x) = 0
        case 'none'
            Model.feature = feature;
            Model.beta = 0;
            Model.H = 0;
            Model.featureFun = @(x) 0;
            Model.theta = [1, Model.mX];
            Model.sigma = sigma(1);
            Model.Ky = zeros(Model.nY);
            Model.logDetKy = 0;
            Model.L = zeros(Model.nY);
            Model.alpha = zeros(Model.nY, Model.mY);
            Model.logLikelihood = zeros(1, Model.mY);
            
        otherwise
            msg = "Unknown feature: %s. Use " + ...
                "none, " + ...
                "combined, " + ...
                "individual " + ...
                "or atan2.";
            error(msg, feature)
    end
end

