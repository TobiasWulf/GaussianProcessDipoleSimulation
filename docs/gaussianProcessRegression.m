%% gaussianProcessRegression
% Function module which implements regression models with Gaussian Process.
% Implemented regression models posses the abillity to process training and test
% datasets bt sensor array simulation. The model creation can be bind into
% scripts by use of initGPR and tuneKernel for simple optimized models. A fully
% generalized regression model is supported by use of optimGPR to create models
% which are tuned on training data and generalized on test data.
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