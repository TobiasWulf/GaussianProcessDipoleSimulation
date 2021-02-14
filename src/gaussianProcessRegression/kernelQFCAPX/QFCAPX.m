%% QFCAPX
% Approximates QFC with triangle inequation, norming is pulled out to input
% stage kernel is feeded with norm vectors or scalars instead of matrices.
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
function K = QFCAPX(ax, bx, ay, by, theta)
    
    
    % get number of observations for each dataset, cosine and sine 
    M = length(ax);
    N = length(bx);
    
    % expand covariance parameters, variance and lengthscale
    c2 = 2 * theta(2)^2; % 2*sl^2
    c1 = theta(1) * c2;   % s2f * c
    
    % allocate memory for K
    K = zeros(M, N);
    
    % loop through observation points and compute the covariance for each
    % observation against another
    for m = 1:M
        for n = 1:N
            % get distance between m-th and n-th observation
            % compute distance with quadratic frobenius normed vectors
            r2 = (ax(m) - bx(n))^2 + (ay(m) - by(n))^2;
            
            % engage lengthscale and variance on distance
            K(m,n) = c1 / (c2 + r2);
            
        end
    end
end

