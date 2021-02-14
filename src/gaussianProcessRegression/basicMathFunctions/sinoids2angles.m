%% sinoids2angles
% 
function [fang, fc, fs] = sinoids2angles(fsin, fcos, frad, rad)
    
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
