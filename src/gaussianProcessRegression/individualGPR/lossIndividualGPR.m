%% lossIndividualGPR
% Predicts all angles of passed test dataset to with given model and computes
% prediction loss with as SLL and SE. Returns in addition predicted sinoids, 
% angle in degree, predictive variance, 
%
function [SLLC, SEC, SLLS, SES, fcovCos, fcovSin, fcos, fsin] = lossIndividualGPR(Mdl, DS)
    
    % get number of angles in dataset
    N = DS.Info.UseOptions.nAngles;
    
    % get simulated cosin and sine references from dataset angles in degrees
    % and transpose to column vector
    [ysin, ycos] = angles2sinoids(DS.Data.angles', false, Mdl.pf);
        
    % allocate memory for results
    fcos = zeros(N, 1);
    fsin = zeros(N, 1);
    fcovCos = zeros(N, 1);
    fcovSin = zeros(N, 1);
    
    % predict angle by angle from dataset
    for n = 1:N
        % get cosine and sine at n-th angle
        Xcos = DS.Data.Vcos(:,:,n);
        Xsin = DS.Data.Vsin(:,:,n);
        
        % predict cosine, sine and variance of prediction
        [fcos(n), fsin(n), fcovCos(n), fcovSin(n)] = predIndividualGPR(Mdl, Xcos, Xsin);
    end
    
    % compute loss and error
    [SLLC, SEC] = computeSquareLogLoss(ycos, fcos, fcovCos, Mdl.s2nCos);
    %[SLLS, SES] = computeSquareLogLoss(ysin, fsin, fcovSin, Mdl.s2nSin);
    [SLLS, SES] = computeSquareLogLoss(ysin, fsin, fcovCos, Mdl.s2nCos);
    
end

