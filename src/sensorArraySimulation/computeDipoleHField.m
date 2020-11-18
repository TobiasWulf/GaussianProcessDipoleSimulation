%% computeDipoleHField
% Computes the magnetic field strength H of a dipole magnet dependent of
% position and magnetic moment and imprint a field strength magnitude on the
% resultating field by passing a norm factor which relates to the rest position
% of the dipole magnet. The resultating field strength has field components in
% x, y and z direction.
%
% The magnetic dipole moment w must be a column vector or shape
%
% $$\vec{m} = \left[ \matrix{m_x \cr m_y \cr m_z} \right]$$
%
% so that the magnetic moment corresponds to a position vector
%
% $$\vec{r} = \left[ \matrix{x \cr y \cr z} \right]$$
%
% with coordinates for x, y and z in 3D coordinate system which can be taken
% part of its unit vector and its magnitude.
%
% $$\vec{r} = \hat{r} \cdot |\vec{r}|$$
%
% It computes the field strenght at this position with the current magnetic
% moment for field compents in the same orientation.
%
% $$\vec{H}(\vec{r}) = \left[ \matrix{H_x \cr H_y \cr H_z} \right]$$
%
% The originally equation of the magnetic dipole is known as
%
% $$\vec{H} = \frac{\vec{B}}{\my_0} = \frac{1}{4\pi} \cdot \frac{}{}$$
% 
%
%% Syntax
%   H = nName(positionalArg)
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
% * Subfunctions: mustBeEqualSize
% * MAT-files required: None
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on November 11. 2020 by Tobias Wulf. Copyright Tobias Wulf.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [H] = computeDipoleHField(x, y, z, m, H0norm)
    arguments
        % validate position, can be any size but must be same size of
        x (:,:,:) double {mustBeReal}
        y (:,:,:) double {mustBeReal, mustBeEqualSize(x, y)}
        z (:,:,:) double {mustBeNumeric, mustBeReal, mustBeEqualSize(y, z)}
        % validate magnetic moment as 3 x 1 vector
        m (3,1) double {mustBeReal, mustBeVector}
        % validate norm factor as scalar
        H0norm (1,1) double {mustBeReal}
    end
    
    % unify positions to column vector or matrix of column vectors if positions
    % are not passed as column vectors or scalar, resulting size of position R
    % is 3 x length(X), a indication if is column vector is not needed because
    % x(:) is returning all content as column vector. Transpose to match shape.
    r = [x(:), y(:), z(:)]';
    
    % calculate the magnitude of all positions
    rabs = sqrt(sum(r.^2, 1));
    
    % calculate the the unit vector of all positions
    rhat = r ./ rabs;
        
    % calculate H-field of current magnetic moment for all passed positions
    % calculate constants in eqution once in the first bracket term, all vector
    % products in the second term and finially divide by related magnitude ^3
    H = (H0norm / 4 / pi) * (3 * rhat .* (m' * rhat) - m) ./ rabs.^3;
end

% Custom validation function
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'X Y Z positions must be the same size and orientation.';
        throwAsCaller(MException(eid,msg))
    end
end
