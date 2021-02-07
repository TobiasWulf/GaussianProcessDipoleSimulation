%% predictSingle
% Predicts single
function [frad, fcos, fsin, fradius, fcov] = predFrame(Mdl, Xcos, Xsin)
    
    % adjust inputs if needed
    Xcos = Mdl.inputFun(Xcos);
    Xsin = Mdl.inputFun(Xsin);
    
    % compute covariance between observations and test point
    k = Mdl.kernelFun(Mdl.Xcos, Xcos, Mdl.Xsin, Xsin, Mdl.theta);
    
    % compute the mean test point depending on mean option
    switch Mdl.mean
        % set means to zero
        case 'zero'
            Mcos = Mdl.meanFun(0);
            Msin = Mdl.meanFun(0);
            Mradius = Mdl.meanFun(0);
            
        otherwise
            error('Unsupported mean model in prediction %s', Mdl.mean);
    end
    
    % compute the predictive means
    fcos = Mcos + k' * Mdl.AlphaCos;
    fsin = Msin + k' * Mdl.AlphaSin;
    fradius = Mradius + k' * Mdl.AlphaRadius;
    
    % compute angle in rad from sinoid results
    frad = sinoids2angles(fsin, fcos, false, true, Mdl.PF);
    
    % compute predictiv variance as the difference between test point covariance
    % which should be Mdl.theta(1) = s2f  product of the covariance between 
    % observations and test points
    % compute the covariance of test point itself means distance is zero which
    % implies that result must be the variance s2f
    fcov = Mdl.kernelFun(Xcos, Xcos, Xsin, Xsin, Mdl.theta);
    assert(fcov == Mdl.theta(1));
    
    % now add variance from additives
    fcov = fcov - computeTransposeInverseProduct(Mdl.L, k);
    
end

