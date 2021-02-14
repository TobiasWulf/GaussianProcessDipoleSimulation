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
function [sine, cosine, angles] = angles2sinoids(angles, rad, pf)
    
    
    % if rad flag is false and angles in degree convert to rad
    if ~rad, angles = angles * pi / 180; end
    
    % calculate sinoids
    sine = sin(pf * angles);
    cosine = cos(pf * angles);
    
    % recalculate angles to corrected sinoids in rad
    angles = sinoids2angles(sine, cosine, sqrt(cosine.^2 + sine.^2), true);
