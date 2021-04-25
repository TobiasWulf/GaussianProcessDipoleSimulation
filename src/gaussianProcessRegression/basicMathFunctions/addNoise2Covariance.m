%% addNoise2Covariance
% Add noise to covarianc matrix for noisy observations. Add noise along matrix
% diagonal.
%
%
%% Syntax
%   Ky = addNoise2Covariance(K, s2n)
%
%
%% Description
% *Ky = addNoise2Covariance(K, s2n)* witch on additive noise on covariance
% matrix diagonal. Uses eye matrix as mask.
%
%
%% Examples
%   addNoise2Covariance(zeros(4), 2)
%
%
%% Input Argurments
% *K* N x N covariance matrix. Noise free.
%
% *s2n* real scalar value.
%
%
%% Output Argurments
% *Ky* covariance matrix for noisy observations.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: eye, mustBeSquareMatrix
% * MAT-files required: None
%
%
%% See Also
% * <initKernelParameters.html initKernelParameters>
%
%
% Created on November 06. 2019 by Klaus Jünemann. Copyright Klaus Jünemann 2019.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on January 05. 2021 by Tobias Wulf: Own function.
% Edited on January 05. 2021 by Tobias Wulf: Add argument validation.
% -->
% </html>
%
function Ky = addNoise2Covariance(K, s2n)
    arguments
        % validate K as square matrix
        K (:,:) double {mustBeReal, mustBeSquareMatrix(K)}
        % validate s2n as scalar value
        s2n (1,1) double {mustBeReal}
    end
    
    % add noise with eye matrix
    Ky = K + s2n * eye(size(K));
end

% Custom validation functions
function mustBeSquareMatrix(K)
    % Test for N x N
    if ~isequal(size(K,1), size(K, 2))
        eid = 'Size:notEqual';
        msg = 'K is not size of N x N.';
        throwAsCaller(MException(eid,msg))
    end
end