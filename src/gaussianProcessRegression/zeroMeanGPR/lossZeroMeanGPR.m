%% lossZeroMeanGPR
% Predicts all angles of passed test dataset to with given model and computes
% prediction loss with as SLL and SE. Returns in addition predicted sinoids, 
% angle in degree, predictive variance, 
%
function [SLLC, SEC, SLLS, SES, fcovsc, fcos, fsin] = lossZeroMeanGPR(Mdl, DS)
    
    % get number of angles in dataset
    N = DS.Info.UseOptions.nAngles;
    
    % get simulated cosin and sine references from dataset angles in degrees
    % and transpose to column vector
    [ysin, ycos] = angles2sinoids(DS.Data.angles', false, Mdl.pf);
        
    % allocate memory for results
    fcos = zeros(N, 1);
    fsin = zeros(N, 1);
    fcovsc = zeros(N, 1);
    
    % predict angle by angle from dataset
    for n = 1:N
        % get cosine and sine at n-th angle
        Xcos = DS.Data.Vcos(:,:,n);
        Xsin = DS.Data.Vsin(:,:,n);
        
        % predict cosine, sine and variance of prediction
        [fcos(n), fsin(n), fcovsc(n)] = predZeroMeanGPR(Mdl, Xcos, Xsin);
    end
    
    % compute loss and error
    [SLLC, SEC] = computeSquareLogLoss(ycos, fcos, fcovsc, Mdl.s2n);
    [SLLS, SES] = computeSquareLogLoss(ysin, fsin, fcovsc, Mdl.s2n);
   
end

