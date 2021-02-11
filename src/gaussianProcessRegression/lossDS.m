%% lossDS
% Predicts all angles of passed test dataset and computes logaritmic losses for
% radius and squared angle error. 
% AAED = Absolute Angular Error in Degrees
% SLLA - Squared Log Loss Angular
% SLLR - Squared Log Loss Radius
% SEA  - Squared Error Angular
% SER  - Squared Error Radius
% SEC  - Squared Error Cosine
% SES  - Squared Error Sine
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
    [SLLA, SEA] = computeSquareLogLoss(yang, fang, asin(s));
    
    % compute abslute angular error in degrees
    AAED = sqrt(SEA) * 180/pi;
    
    % compute log loss and squared error for radius
    [SLLR, SER] = computeSquareLogLoss(yrad, frad, s);
    
    % compute squared error of sinoids
    SEC = (ycos - fcos).^2;
    SES = (ysin - fsin).^2;
    
end

