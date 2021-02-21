%% angles2sinoids
% Converts angles (rad or degree) to sine and cosine waves with respect to a
% period factor which gives the abillity to apstract higher periodicity.
% Additionally the angles are recalculated according to passed period factor.
%
% Computes sine and cosine by product of angle in rad multiplied by period
% factor.
%
% $$f_{sin} = \sin(p_f \cdot f_{ang})$$
%
% $$f_{cos} = \cos(p_f \cdot f_{ang})$$
%
% If needed a recomputation of the given angels takes place by computed sinoids.
%
%
%% Syntax
%   [fsin, fcos, fang] = angles2sinoids(fang, rad, pf)
%
%
%% Description
% *[fsin, fcos, fang] = angles2sinoids(fang, rad, pf)* computes sinoids from
% passed angles in rad or degree with respect to periodicity of angles. The flag
% rad converts input angles from degree to rad if set to false.
%
%
%% Examples
%   fang = linspace(0, 360, 100);
%   [fsin, fcos, fang] = angles2sinoids(fang, true, 1)
%
%
%% Input Argurments
% *fang* is a scalar of vector of angles in rad or degree.
%
% *rad* is a boolean flag. Input angles are converted to rad if set to false.
%
% *pf* is a positive integer factor. The period factor describes the periodicity
% of angles in data.
%
%
%% Output Argurments
% *fsin* is a scalar or vector of sine values corresponding to passed angles
% with respect of the periodicity of angles.
%
% *fcos* is a scalar or vector of cosine values corresponding to passed angles
% with respect of the periodicity of angles.
%
% *fang* is a scalar or vector of recalculated angles with respect of
% periodicity.
%
%
%% Requirements
% * Other m-files required: sinoids2angles
% * Subfunctions: sin, cos
% * MAT-files required: None
%
%
%% See Also
% * <sinoids2angles.html sinoids2angles>
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
function [fsin, fcos, fang] = angles2sinoids(fang, rad, pf)
    arguments
        % validate angles as scalar or vector
        fang (:,1) double {mustBeReal}
        % validate rad as boolean flag with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate period factor as positive scalar with default 1
        pf (1,1) double {mustBeInteger, mustBePositive} = 1
    end
    
    % if rad flag is false and angles in degree convert to rad
    if ~rad, fang = fang * pi / 180; end
    
    % calculate sinoids
    fsin = sin(pf * fang);
    fcos = cos(pf * fang);
    
    % compute radius
    frad = sqrt(fcos.^2 + fsin.^2);
    
    % recalculate angles to corrected sinoids in rad
    if nargout > 2, fang = sinoids2angles(fsin, fcos, frad); end
end
