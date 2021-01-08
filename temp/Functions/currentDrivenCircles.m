function [ MAGNET ] = currentDrivenCircles( radian, nr_points, mulMAG , flagRot)
% MAGNET = CURRENTDRIVENCIRCLES( radian, nr_points, mulMAG )
%
% Generate circles at the defined points of the multipole magnet
%
% Input args: 
%               radian  :       the radian of the circles
%               nrpoint :       holds the number of points for each circle
%               mulMAG  :       Sturcture with 2 input args
%                       -> x    X-Coordinate of the magnet
%                       -> y    Y-Coordinate of the magnet
%                       -> z    Z-Coordinate of the magnet
%                       -> pn   Vector with 1 for positiv magnetization
%                               and 0 for negative magnetizetion
%                       -> PSI  angle in rad from magnet point in 
%                               cylindrical coordinates
%               flagRot  :      rotate x axis (90 deg) if flagRot==1
%==========================================================================
% Output args: 
%               MAGNET  :    
%                       -> normal.xt
%                       -> normal.yt
%                       -> normal.zt
%                       -> nrpoints
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      30.08.2016
%==========================================================================

a           = 1;       	% step index (no specific use)
if  isfield(mulMAG,'pn') == 0
    mulMAG.pn = zeros(1,length(mulMAG.x));
end
if  isfield(mulMAG,'psi') == 0
    mulMAG.psi = zeros(1,length(mulMAG.x));
end
for k = 1 : length(mulMAG.x)
        if mulMAG.pn(k) == 0 
            % positive direction 
            for t = 0:2*pi/(nr_points):2*pi
                MAGNET.normal.xt(a) = radian*cos(t);
                MAGNET.normal.yt(a) = radian*sin(t);
                MAGNET.normal.zt(a) = 0;

                if flagRot == 0 
                    m = rotMatrix([MAGNET.normal.xt(a);...
                               MAGNET.normal.yt(a);...
                               MAGNET.normal.zt(a)],...
                               0,...
                               0,...
                               mulMAG.psi(k)*180/pi);
                else
                    m = rotMatrix([MAGNET.normal.xt(a);...
                               MAGNET.normal.yt(a);...
                               MAGNET.normal.zt(a)],...
                               90,...
                               0,...
                               -90);
                end

                MAGNET.normal.xt(a) = m(1)+mulMAG.x(k);
                MAGNET.normal.yt(a) = m(2)+mulMAG.y(k);
                MAGNET.normal.zt(a) = m(3)+mulMAG.z(k);      
                clear('m')
                a = a+1; 
            end
            MAGNET.normal.xt(a) = NaN; 
            MAGNET.normal.yt(a) = NaN; 
            MAGNET.normal.zt(a) = NaN; 
            a = a+1;
        else
             % negative direction 
            for t = 2*pi:-2*pi/(nr_points):0
                MAGNET.normal.xt(a) = radian*cos(t);
                MAGNET.normal.yt(a) = radian*sin(t);
                MAGNET.normal.zt(a) = 0;

                if flagRot == 0 
                    m = rotMatrix([MAGNET.normal.xt(a);...
                               MAGNET.normal.yt(a);...
                               MAGNET.normal.zt(a)],...
                               0,...
                               0,...
                               mulMAG.psi(k)*180/pi);
                else
                    m = rotMatrix([MAGNET.normal.xt(a);...
                               MAGNET.normal.yt(a);...
                               MAGNET.normal.zt(a)],...
                               90,...
                               0,...
                               mulMAG.psi(k)*180/pi);
                end

                MAGNET.normal.xt(a) = m(1)+mulMAG.x(k);
                MAGNET.normal.yt(a) = m(2)+mulMAG.y(k);
                MAGNET.normal.zt(a) = m(3)+mulMAG.z(k);        
                clear('m')
                a = a+1; 
            end
            MAGNET.normal.xt(a) = NaN; 
            MAGNET.normal.yt(a) = NaN; 
            MAGNET.normal.zt(a) = NaN; 
            a = a+1;
        end
end

MAGNET.nrpoints = length(MAGNET.normal.xt);

end

