%===============================================================================
% [Dipol] =  sphereMeshgrid2(Magnet)
% Description:  Creates a sphere meshgrid.
%             
% Input:  Magnet          : Structure with following variables
%         Magnet.raidius  : 
% Output:
%         Dipol           : Structure with following variables
%         Dipol.positionX : x position
%         Dipol.positionY : y position
%         Dipol.positionZ : z position
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 28.02.2017
%===============================================================================
function [Dipol] = sphereMeshgrid2(Magnet)
    n = Magnet.n;
    radius = Magnet.radius;
    x   = linspace(-radius,radius,n);
    y   = linspace(-radius,radius,n);
    z   = linspace(-radius,radius,n);
    [xx,yy,zz]    = meshgrid(x,y,z);
    Betrag = sqrt(xx.^2 + yy.^2 + zz.^2);
    Betrag = Betrag(:);
    xx = xx(:);
    yy = yy(:);
    zz = zz(:);
    for ii = 1:n^3
        if Betrag(ii) > radius
            xx(ii) = NaN;
            yy(ii) = NaN;
            zz(ii) = NaN;
        end    
    end
    yy(isnan(xx)==1)=[];
    zz(isnan(xx)==1)=[];
    xx(isnan(xx)==1)=[];
    Dipol.positionX = xx;
    Dipol.positionY = yy;
    Dipol.positionZ = zz;
end