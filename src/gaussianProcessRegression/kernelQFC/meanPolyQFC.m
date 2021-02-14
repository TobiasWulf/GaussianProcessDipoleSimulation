%% meanPolyQFC
% Basis or trend function to compute the H matrix as set of h(x) vectors for each
% predictor to apply a mean feature space as polynom approximated mean with beta coefficients.
% Compute H matrix to estimate beta.
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
function H = meanPolyQFC(X, degree)
    % get number of observations
    [~, ~, N] = size(X);
    
    % returns only ones if p = 0
    H = ones(degree + 1, N);
    
    % compute polynom for degrees > 0
    if degree > 0
        for n = 1:N
            H(2,n) = frobeniusNorm(X(:,:,n), false);
        end
    end
    
    % compute none linear polynoms if degree > 1
    if degree > 1
        for p = 2:degree
            H(p+1,:) = H(2,:).^p;
        end
    end
end
