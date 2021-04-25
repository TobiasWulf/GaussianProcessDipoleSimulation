%% lossDS
% Predicts all angles of passed test dataset and computes logaritmic losses for
% radius and angles plus several squared errors. 
%
%
%% Syntax
%   [AAED, SLLA, SLLR, SEA, SER, SEC, SES] = lossDS(Mdl, TestDS)
%
%
%% Description
% *[AAED, SLLA, SLLR, SEA, SER, SEC, SES] = lossDS(Mdl, TestDS)* computes losses
% and prediction erros of a whole datasets
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
% *AAED* Absolute Angular Error in Degrees
% *SLLA* Std. Log. Loss Angular
% *SLLR* Std. Log Loss Radius
% *SEA* Squared Error Angular
% *SER* Squared Error Radius
% *SEC* Squared Error Cosine
% *SES* Squared Error Sine
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: angles2sinoids, computeStdLogLoss
% * MAT-files required: None
%
%
%% See Also
% * <predDS.html predDS>
% * <Training_and_Test_Datasets.html Training and Test Datasets>
% * <angles2sinoids.html angles2sinoids>
% * <computeStdLogLoss.html computeStdLogLoss>
%
%
% Created on March 03. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [AAED, SLLA, SLLR, SEA, SER, SEC, SES] = lossDS(Mdl, TestDS)
    
    % get number of angles in dataset
    N = TestDS.Info.UseOptions.nAngles;
    
    % get simulated cosin and sine references from dataset angles in degrees
    % and transpose to column vector, get sinoids and angles in rads
    [ysin, ycos, yang] = angles2sinoids(TestDS.Data.angles', false, Mdl.PF);
    
    % create reference radius of unit cricle, radius must be one for all angles
    yrad = ones(N, 1);
    
    % predict angles in rads not in degrees
    [fang, frad, fcos, fsin, ~, s, ~, ~] = predDS(Mdl, TestDS);
    
    % compute log loss and squared error for angles in rad
    [SLLA, SEA] = computeStdLogLoss(yang, fang, asin(s) * sqrt(2));
    
    % compute abslute angular error in degrees
    AAED = sqrt(SEA) * 180/pi;
    
    % compute log loss and squared error for radius
    [SLLR, SER] = computeStdLogLoss(yrad, frad, sqrt(2) * s);
    
    % compute squared error of sinoids
    SEC = (ycos - fcos).^2;
    SES = (ysin - fsin).^2;
    
end

