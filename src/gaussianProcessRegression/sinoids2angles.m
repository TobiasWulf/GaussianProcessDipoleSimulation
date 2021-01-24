%% sinoids2angles
% helper function to convert sinus and cosinus values to rad or degree angles
% in compare to origin angular reference, atan2 built and correct negative
% angles along 2pi scale to unwrap atan2 result respective to full rotation
% returns angles in rad and converts origin from degrees to rad if needed
% Origin: Jünemann, Added: Wulf (argument validation, rad flag)
% namedargs: origin: origin angles
% varargout 1: anglesDiff
% varargout 2: originRad
%
function [angles, varargout] = sinoids2angles(sine, cosine, uw, rad, pf, ...
    namedargs)
    arguments
        % validate sinus, cosinus and origin as column vectors of the same length
        sine (:,1) double {mustBeVector, mustBeReal}
        cosine (:,1) double {mustBeReal, mustBeEqualSize(sine, cosine)}
        % validate unwrap option flag as boolean with default true
        uw (1,1) logical {mustBeNumericOrLogical} = true
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        % validate angles origin as vector of same length as sinoids
        namedargs.origin (:,1) double {mustBeReal, mustBeEqualSize(cosine, namedargs.origin)}
    end
    
    % convert sinoids vector componets to rad angles, atan2 provides angles
    % btween 0° and 180° and abstracts angles between 180° and  360° to negative
    % quadrant from -180 to 0°
    angles = atan2(sine, cosine);
    
    % correct angles from 0° to 360° (0 to 2pi) with period factor if multiple
    % periods abstarcts angles between 0° and 360°
    if uw, angles = unwrap(angles) / pf; end
    
        
    % calculate difference to origin angular reference
    if nargout > 1
        if isfield(namedargs, 'origin')
            % convert to rad if rad flag is false
            if ~rad, namedargs.origin = namedargs.origin * pi / 180; end
            % claculate difference
            anglesDiff = diff([namedargs.origin, angles], 1, 2);
            % ensure calculated difference matches interval
            idx = anglesDiff > pi;
            anglesDiff(idx) = anglesDiff(idx) - 2 * pi;
            idx = anglesDiff < -pi;
            anglesDiff(idx) = anglesDiff(idx) + 2 * pi;
            varargout{1} = anglesDiff;
        else
            varargout{1} = NaN(length(angles), 1);
        end
    end
    
    % origin in rad if passed in degree, converted in nargout > 1, ~rad
    if nargout > 2
        if isfield(namedargs, 'origin')
            varargout{2} = namedargs.origin;
        else
            varargout{2} = NaN(length(angles), 1);
        end
    end
end

% Custom validation function to match matrix dimensions
function mustBeEqualSize(a,b)
    % Test for equal size
    if ~isequal(size(a),size(b))
        eid = 'Size:notEqual';
        msg = 'Size of sinus, cosinus and angles must be equal.';
        throwAsCaller(MException(eid,msg))
    end
end
