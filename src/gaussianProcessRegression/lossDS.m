%% lossDS
% Predicts all angles of passed test dataset and computes logaritmic losses for
% radius and squared angle error.
%
function [SLL, SE] = lossDS(Mdl, TestDS)
    
    % get number of angles in dataset
    N = TestDS.Info.UseOptions.nAngles;
    
    % get simulated cosin and sine references from dataset angles in degrees
    % and transpose to column vector
    [ysin, ycos] = angles2sinoids(TestDS.Data.angles', false, Mdl.pf);
        
    % allocate memory for results
    fcos = zeros(N, 1);
    fsin = zeros(N, 1);
    fcovCos = zeros(N, 1);
    fcovSin = zeros(N, 1);
    
    % predict angle by angle from dataset
    for n = 1:N
        % get cosine and sine at n-th angle
        Xcos = TestDS.Data.Vcos(:,:,n);
        Xsin = TestDS.Data.Vsin(:,:,n);
        
        % predict cosine, sine and variance of prediction
        [fcos(n), fsin(n), fcovCos(n), fcovSin(n)] = predIndividualGPR(Mdl, Xcos, Xsin);
    end
    
    % compute loss and error
    [SLLC, SEC] = computeSquareLogLoss(ycos, fcos, fcovCos, Mdl.s2nCos);
    %[SLLS, SES] = computeSquareLogLoss(ysin, fsin, fcovSin, Mdl.s2nSin);
    [SLLS, SES] = computeSquareLogLoss(ysin, fsin, fcovCos, Mdl.s2nCos);
    
end

