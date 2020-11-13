%% rotate3DVector
% Rotate a 3 dimensional vector with x-, y- and z-components in 3 dimensional
% coordinate system along the x-, y- and z-axes. Using rotation matrix for x-,
% y- and z-axes. Angle must be served in degree. Vector must be a column vector
% 3 x 1 or matrix related x-, y-, z-components 3 x N.
%
% This function was originally created by Thorben Schüthe is ported into source
% code under improvements and including Matlab built-in functions.
% Function rewritten.
%
%% Syntax
%   rotated = rotate3DVector(vector, alphaX, betaY, gammaZ)
%
%
%% Description
% *rotated = rotate3DVector(vector, alphaX, betaY, gammaZ)* returns a rotated
% vector which is rotated by given angles on related axes. alphaX rotates along
% the x-axes, betaY along the y-axes and gammaZ along the z-axes. Therfore each
% rotations is described by belonging rotation matrix. The resulting rotation of
% the vector is computed by the matrix and vector multiplacation of the rotation
% matrices and the input vecotor.
%
% $$v' = A v = R_z(\gamma) R_y(\beta) R_x(\alpha) v$$
%
%
%% Examples
%   % rotate a vector along z-axes by 45°
%   vector = [1; 0; 0]
%   rotated = rotate3DVector(vector, 0, 0, 45)
%
%   % rotate a vector along z-axes by 35° with a tilt in x-axes by 1°
%   vector = [1; 0; 0]
%   rotated = rotate3DVector(vector, 1, 0, 35)
%
%   % rotate a vector along z-axes by 35° with a tilt in x-axes by 1° and a
%   % tilt in y-axes by 5°
%   vector = [1; 0; 0]
%   rotated = rotate3DVector(vector, 1, 5, 35)
%
%
%% Input Arguments
% *vector* is a 3 x N column vector of real numbers which representates the a
% vector in a 3D coordinate system with x-, y- and z-components.
%
% *alphaX* is a scalar angular value in degree and rotates the vector in the
% x-axes.
%
% *betaY* is a scalar angular value in degree and rotates the vector in the
% y-axes.
%
% *gammaZ* is a scalar angular value in degree and rotates the vector in the
% z-axes.
%
%
%% Output Arguments
% *rotated* is rotation of vector by passed axes related angles.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: rotx, roty, rotz
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'phased/ref/rotx.html')) rotx>
% * <matlab:web(fullfile(docroot,'phased/ref/roty.html')) roty>
% * <matlab:web(fullfile(docroot,'phased/ref/rotz.html')) rotz>
% * <https://de.wikipedia.org/wiki/Drehmatrix Wikipedia Drehmatrix>
%
%
% Created on August 03. 2016 by Thorben Schüthe. Copyright Thorben Schüthe 2016.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on November 04. 2020 by Tobias Wulf: Import and rewrite with built-ins.
% Edited on November 04. 2020 by Tobias Wulf: Write documentaion header, comment.
% -->
% </html>
%
function [rotated] = rotate3DVector(vector, alphaX, betaY, gammaZ)
    arguments
        % validate as vecotor or matrix of size 3 x N
        vector (3,:) double {mustBeReal}
        % validate angles as scalar
        alphaX (1,1) double {mustBeReal}
        betaY (1,1) double {mustBeReal}
        gammaZ (1,1) double {mustBeReal}
    end
    
    % rotate vector or vector field as 3 x N matrix counterclockwise by given
    % angles along axes, calculate rotation matrices for each axes and
    % multiplicate with input vector
    rotated = rotz(gammaZ) * roty(betaY) * rotx(alphaX) * vector(:, 1:end);
end

