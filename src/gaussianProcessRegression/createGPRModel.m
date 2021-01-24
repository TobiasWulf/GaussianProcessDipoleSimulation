%% createGPRModel
% Create and tune GPR model depend on feature and how many target vectors are
% passed in Y. If more than one vector is passed in Y the first one corresponds
% to Xcos and second one to Xsin. For feature atan2 only one target vector must
% be passed.
%
function Model = createGPRModel(XtrainCos, XtrainSin, YtrainCos, YtrainSin, feature)
    % create Model struct
    Model = struct();
    
    % add training observations to model
    Model.XtrainCos = XtrainCos;
    Model.XtrainSin = XtrainSin;
    Model.YtrainCos = YtrainCos;
    Model.YtrainSin = YtrainSin;
    
    % add dimensions of observations to model n for N observations m for number
    % of observation dimension X observation in 3rd dimension Y  observation as
    % column vectors in 1st dimension
    assert(all(size(XtrainCos) == size(XtrainSin)));
    assert(all(size(YtrainCos) == size(YtrainSin)));
    assert(size(XtrainCos, 3) == size(YtrainCos, 1));
    [Model.D, ~, Model.N] = size(XtrainCos);
    
       
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
            Model.theta = [1, Model.D];
            Model.sigma2N = 1e-5;
            Model.Ky = zeros(Model.N);
            Model.logDetKy = 0;
            Model.L = zeros(Model.N);
            Model.alphaCos = 0;
            Model.alphaSin = 0;
            Model.logLikelihoodCos = 0;
            Model.logLikelihoodSin = 0;
            
        otherwise
            msg = "Unknown feature: %s. Use " + ...
                "none, " + ...
                "combined, " + ...
                "individual " + ...
                "or atan2.";
            error(msg, feature)
    end
end

