%% sinoids2angles
% Computes angles in rad or degree by passed sinoids and radius. The angle
% calculation is asigned in two steps. At first compute bare angles by acos and
% asin functions. Divide therfore the corresponding sinoid by the radius.
% Furhter on the result from acos is used with an interval correction given by
% the second results from the asin function. The amplitudes of the sinoids must
% be one or near to one.
%
%
%% Syntax
%   [fang, fc, fs] = sinoids2angles(fsin, fcos, frad, rad)
%
%
%% Description
% *[fang, fc, fs] = sinoids2angles(fsin, fcos, frad, rad)* returns angles in rad
% or degrees given by corresponding sinoids and radius. Set rad flag to false if
% angles in degrees are needed.
%
%
%% Examples
%   phi = linspace(0, 2*pi, 100);
%   fsin = sin(phi);
%   fcos = cos(phi);
%   frad = sqrt(fsin.^2 + fcos.^2);
%   [fang, fc, fs] = sinoids2angles(fsin, fcos, frad, true)
%
%
%% Input Argurments
% *fsin* is a scalar or vector with sine information to corresponding angle. 
%
% *fcos* is a scalar or vector with cosine information to corresponding angle.
%
% *frad* is a scalar or vector which represents the radius of each sine and
% cosine position.
%
% *rad* is a boolean flag. If it is false the resulting angles are converted
% into degrees. If it is true fang is returned in rad. Default is true.
%
%
%% Output Argurments
% *fang* is a scalar or vector with angles in rad or degree corresponding to the
% sine and cosine inputs.
%
% *fc* is a scalar or vector with angles directly computed by cosine and radius. 
%
% *fs* is a scalar or vector with angles directly computed by sine and radius. 
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: acos, asin
% * MAT-files required: None
%
%
%% See Also
% * <angles2sinoids.html angles2sinoids>
%
%
% Created on December 31. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [fang, fc, fs] = sinoids2angles(fsin, fcos, frad, rad)
    arguments
        % validate sinoids and radius as scalar or vector of the same size
        fsin (:,1) double {mustBeReal}
        fcos (:,1) double {mustBeReal, mustBeEqualSize(fsin, fcos)}
        frad (:,1) double {mustBeReal, mustBeEqualSize(fsin, frad)}
        % validate rad as boolean flag with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
    end
    
    % compute angles by cosine, sine and radius
    fc = acos(fcos ./ frad);
    fs = asin(fsin ./ frad);
    
    % get indices for interval > 180°
    idx = fs < 0;
    
    % angles from cosine
    fang = fc;
    
    % correct 180° interval
    fang(idx) = -1 * fang(idx) + 2 * pi;
    
    % return degrees if not rad
    if ~rad, fang = 180 / pi * fang; end
end

% Custom validation function
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of first input must equal size of second input.';
        throwAsCaller(MException(eid,msg))
    end
end