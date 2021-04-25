%% meanPolyQFC
% Basis or trend function to compute the H matrix as set of h(x) vectors for
% each predictor to apply a mean feature space as polynom approximated mean 
% with beta coefficients. Compute H matrix to estimate beta.
%
%
%% Syntax
%   H = meanPolyQFC(X, degree)
%
%
%% Description
% *H = meanPolyQFC(X, degree)* build polynom by passed data. Fires Frobenius
% Norm on matrix data.
%
%
%% Input Argurments
% *X* matrix data.
%
% *degree* polynom degree.
%
%
%% Output Argurments
% *H* polynom.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: frobeniusNorm
% * MAT-files required: None
%
%
%% See Also
% * <initQFC.html initQFC>
% * <frobeniusNorm.html frobeniusNorm>
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
