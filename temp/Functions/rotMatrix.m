function [ Prot ] = rotMatrix(Pmtx,rotx,roty,rotz)
%[ Prot ] = rotMatrix(Pmtx,rotx,roty,rotz)
%
% Input: 
%           Pmtx:   Matrix or vector with the following structure
%                   
%                   Pmtx = [ x1 x2 x3 ....
%                            y1 y2 y3 ....
%                            z1 z2 z3 ....];
%           rotx:   X-Rotation angle in degree
%           roty:   Y-Rotation angle in degree
%           rotz:   Z-Rotation angle in degree
%
% Output: 
%           Prot:   Rotated Pmtx with the defined angle
%==========================================================================
% Author: Thorben Schüthe
% Company: HAW Hamburg
% Date : 3. August 2016
%==========================================================================

[h,w] = size(Pmtx);

if h==3
    % rotation of the point matrix
    ROTX = [    1           0               0; 
                0           cosd(rotx)      -sind(rotx); 
                0           sind(rotx)      cosd(rotx)]; 
            
    ROTY = [    cosd(roty) 	0               sind(roty); 
                0           1               0; 
                -sind(roty) 0               cosd(roty)]; 
            
	ROTZ = [    cosd(rotz)  -sind(rotz)     0; 
                sind(rotz)  cosd(rotz)      0; 
                0           0               1 ];     % Rz  
%     Prot = ROTX*Pmtx(:,1:end);  
% 	Prot = ROTY*Prot; 
%     Prot = ROTZ*Prot; 

    Prot = ROTZ*ROTY*ROTX*Pmtx(:,1:end); 
else
    Prot = [NaN;NaN;NaN]; 
end
end

