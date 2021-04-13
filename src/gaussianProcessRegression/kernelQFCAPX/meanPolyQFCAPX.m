%% meanPolyQFCAPX
% Basis or trend function to compute the H matrix as set of h(x) vectors for 
% each predictor to apply a mean feature space as polynom approximated mean with
% beta coefficients. Compute H matrix to estimate beta. Vectors instead of
% matrices norming is place at input stage.
%
%
%% Syntax
%   H = meanPolyQFCAPX(X, degree)
%
%
%% Description
% *H = meanPolyQFCaPX(X, degree)* build polynom by passed data.
%
%
%% Input Argurments
% *X* vector data.
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
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <initQFCAPX.html initQFCAPX>
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
function H = meanPolyQFCAPX(X, degree)
    % get number of observations
    N = length(X);
    
    % returns only ones if p = 0
    H = ones(degree + 1, N);
    
    % compute polynom for degrees > 0
    if degree > 0
        H(2,:) = X';
    end
    
    % compute none linear polynoms if degree > 1
    if degree > 1
        for p = 2:degree
            H(p+1,:) = X'.^p;
        end
    end
end
