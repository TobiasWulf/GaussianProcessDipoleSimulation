%% angles2sinoids
% helper function to convert angles (rad or degree) to sinus and cosinus waves
% using built in functions cos, and sin, compute with amplitude scale
% factor and which gives the posibility to scale to one, additional returns
% angles in rad if passed in degree and differences to sinus and cosinus if
% compare vectors for each is passed, it is also posible to multiple the periods
% of given angles by period factor.
% varargout 1: angles in rad
% varargout 2: sinus diff
% varargout 3: cosinus diff
%
function [sine, cosine, varargout] = angles2sinoids(angles, rad, pf, amp, namedargs)
    arguments
        % validate angles and origins as column vectors of same length
        angles (:,1) double {mustBeVector, mustBeReal}
        % validate rad option flag as boolean with default true
        rad (1,1) logical {mustBeNumericOrLogical} = true
        % validate period factor as real, positive scalar with default 1
        pf (1,1) double {mustBePositive} = 1
        % validate amplitude vector as real scalar factor with default 1
        amp (1,1) double {mustBeReal} = 1
        namedargs.sine (:,1) double {mustBeReal, mustBeEqualSize(angles, namedargs.sine)}
        namedargs.cosine (:,1) double {mustBeReal, mustBeEqualSize(angles, namedargs.cosine)}
    end
    
    % if rad flag is false and angles in degree convert to rad
    if ~rad, angles = angles * pi / 180; end
    
    % calculate sinoids
    sine = amp * sin(pf * angles);
    cosine = amp * cos(pf * angles);
    
    % angles in rad
    if nargout > 2
        varargout{1} = angles;
    end
    % sinus difference
    if nargout > 3
        if isfield(namedargs, 'sine')
            varargout{2} = diff([sine, namedargs.sine], 1, 2);
        else
            varargout{2} = NaN(length(angles), 1);
        end
    end
    % cosinus difference
    if nargout > 4
        if isfield(namedargs, 'cosine')
            varargout{3} = diff([cosine, namedargs.cosine], 1, 2);
        else
            varargout{3} = NaN(length(angles), 1);
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
