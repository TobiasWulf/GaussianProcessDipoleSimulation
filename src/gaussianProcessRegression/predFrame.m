%% predFrame
% Predicts single test point.
%
%
%% Syntax
%   outputArg = functionName(positionalArg)
%   outputArg = functionName(positionalArg, optionalArg)
%
%
%% Description
% *outputArg = functionName(positionalArg)* detailed use case description.
%
% *outputArg = functionName(positionalArg, optionalArg)* detailed use case
% description.
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
% *outputArg* argurment description.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on Month DD. YYYY by Creator. Copyright Creator YYYY.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predFrame(Mdl, ...
    Xcos, Xsin)
    
    % adjust inputs if needed
    Xcos = Mdl.inputFun(Xcos);
    Xsin = Mdl.inputFun(Xsin);
    
    % compute covariance between observations and test point
    k = Mdl.kernelFun(Mdl.Xcos, Xcos, Mdl.Xsin, Xsin, Mdl.theta);
    
    % compute predictiv variance as the difference between test point covariance
    % which should be Mdl.theta(1) = s2f  product of the covariance between 
    % observations and test points
    % compute the covariance of test point itself means distance is zero which
    % implies that result must be the variance s2f
    c1 = Mdl.kernelFun(Xcos, Xcos, Xsin, Xsin, Mdl.theta);
    % assert(c1 == Mdl.theta(1));
    
    % now add variance from additives
    fcov = c1 - computeTransposeInverseProduct(Mdl.L, k);
    
    % predict depending on model mean function
    switch Mdl.mean
        case 'zero'
             % compute the predictive means directly by covariance vector and
             % alpha weights, mean is zero
            fcos = k' * Mdl.AlphaCos;
            fsin = k' * Mdl.AlphaSin;
        case 'poly'
            % compute 
            fcos = Mdl.meanFunCos(Xcos) + k' * Mdl.AlphaCos;
            fsin = Mdl.meanFunSin(Xsin) + k' * Mdl.AlphaSin;
        otherwise
            error('Unsupported mean function %s in prediction.', Mdl.mean);
    end
    
    % compute radius from sinoid results
    frad = sqrt(fcos^2 + fsin^2);
    
    % compute angle in rad from sinoid results
    fang = sinoids2angles(fsin, fcos, frad, true);
    
    % sigma of the normal distribution over fradius
    s = sqrt(fcov + Mdl.s2n);
    
    % 95% confidence interval over fradius
    ciang = [fang - asin(1.96 * s * sqrt(2)), fang + asin(1.96 * s * sqrt(2))];
    
    % 95% confidence interval over fradius
    cirad = [frad - 1.96 * s * sqrt(2), frad + 1.96 * s * sqrt(2)];
end

