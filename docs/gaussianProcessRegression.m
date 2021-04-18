%% gaussianProcessRegression
% Function module which implements regression models with Gaussian Process.
% Implemented regression models posses the abillity to process training and test
% datasets bt sensor array simulation. The model creation can be bind into
% scripts by use of initGPR and tuneKernel for simple optimized models. A fully
% generalized regression model is supported by use of optimGPR to create models
% which are tuned on training data and generalized on test data.
%
% * *Model struct:*
%
% * kernel: Indicator which kernel implementation is used QFC or QFCAPX.
% * theta: Kernel parameter vector.
% * s2fBounds: Lower and upper bounds for theta(1).
% * slBounds: Lower and upper bounds for theta(2).
% * s2n: Noise level.
% * s2nBounds: Lower and upper bounds for s2n.
% * mean: Indicator if mean computation in GPR is active (poly) or not (zero).
% * polyDegree: Polynom degree if mean is set to poly. Up degree of 4 is working
%   valid.
% * N: Number of reference angles.
% * Angles: Column vector of reference angles.
% * D: Number of sensor array pixels at each array edge.
% * P: Number of predictors or number of sensor array pixels.
% * Sensor: Indicator of which characterization was used sensor array datasets.
% * PF: Periodicity of angular data depending on characterization dataset.
% * Ysin: Column vector of sine regression targets by reference angles.
% * Ycos: Column vector of cosine regression targets by reference angles.
% * Xcos: Cosine training data.
% * Xsin: Sine training data.
% * kernelFun: Function handle to loaded covariance function by kernel
%   indicator.
% * inputFun: Function handle to loaded input function by kernel indicator.
%   Preprocesses training and test data infront of regression computations.
% * basisFun: Function handle to loaded polynom function by kernel indicator.
% * Ky: Covariance Matrix for noisy observations.
% * L: Lower triangle matrix of cholesky decomposed Ky.
% * logDet: Logaritmic determinante of Ky.
% * BetaCos: Polynom coefficients for polynomial mean approximation for cosine
%   function as regression mean basis.
% * BetaSin: Polynom coefficients for polynomial mean approximation for sine
%   function as regression mean basis.
% * meanFunCos: Function handle for cosine mean approximation by basisFun and
%   BetaCos coefficients.
% * meanFunSin: Function handle for sine mean approximation by basisFun and
%   BetaSin coefficients.
% * AlphaCos: Regression weights for cosine predictions.
% * AlphaSin: Regression weights for sine predictions.
% * LMLcos: Logaritmic marginal likelihood for cosine prediction.
% * LMLsin: Logaritmic marginal likelihood for sine prediction.
% * MSLLA: Mean standardized logaritmic loss for angles.
% * MSLLR: Mean standardized logaritmic loss for radius.
%
%
%% basicMathFunctions
% Submodule which contains basic math function to module functionanlity.
%
%
%% kernelQFC
% Submodule which contain quadratic fractional covariance implementation.
%
%
%% kernelQFCAPX
% Submodule which contains approximated quadratic fractional covariance
% implementation.
%
%
%% initGPR
% Initializes regression model by training dataset and config dataset. Resulting
% model is not optimized.
%
%
%% initGPROptions
% Attaches configuration to regression model including default parameters and
% bounds.
%
%
%% initTrainDS
% Initiates the training data, refernce angles and regression targets on
% regression model.
%
%
%% initKernel
% Initiates kernel submodules by made configuration.
%
%
%% initKernelParameters
% Initiates the regression model by its set configuration done initiating steps
% before.
%
%
%% tuneKernel
% Tunes initated regression model hyperparameters.
%
%
%% computeTuneCriteria
% Computes min criteria for tuneKernel.
%
%
%% predFrame
% Predicts singel test data frame.
%
%
%% predDS
% Predicts a whole test dataset at once.
%
%
%% lossDS
% Computes prediction losses and errors of a test dataset at once.
%
%
%% optimGPR
% Computes optimized regression model.
%
%
%% computeOptimCriteria
% Computes min criteria for optimGPR.
%
%
%% See Also
% * <generateConfigMat.html generateConfigMat>
% * <demoGPRModule.html demoGPRModule>
% * <investigateKernelParameters.html>
% * <generateSimulationDatasets.html>
%
%
% Created on February 15. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%