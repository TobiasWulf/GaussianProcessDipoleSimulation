%===============================================================================
% [Dipol] =  sphereMeshgrid(Magnet)
% Description:  Creates a sphere meshgrid.
%             
% Input:  Magnet          : Structure with following variables
%         Magnet.radius   : Is the radius of the sphere
%         Magnet.layer    : Defines how many layers are in the sphere
%         Magnet.phiInc   : Defines the increment for phi
%         Magnet.thetaInc : Defines the increment for theta
% Output:
%         Dipol           : Structure with following variables
%         Dipol.positionX : x position
%         Dipol.positionY : y position
%         Dipol.positionZ : z position
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 13.02.2017
%===============================================================================
function [Dipol] = sphereMeshgrid(Magnet)
  a   = 1;  % count value
  for r = Magnet.radius/Magnet.layer : Magnet.radius/Magnet.layer : Magnet.radius
    for phi = pi/(Magnet.phiInc) : pi/(Magnet.phiInc) : pi-pi/(Magnet.phiInc)
      for theta = 0 : 2*pi/(Magnet.thetaInc) : 2*pi-2*pi/(Magnet.thetaInc)
        x(a)  = r * sin(phi) * cos(theta);
        y(a)  = r * sin(phi) * sin(theta);
        z(a)  = r * cos(phi);        
        a = a + 1;
      end   
    end
  end
  x(end+1) = 0;
  y(end+1) = 0;
  z(end+1) = Magnet.radius;
  x(end+1) = 0;
  y(end+1) = 0;
  z(end+1) = -Magnet.radius;
  Dipol.positionX = x;
  Dipol.positionY = y;
  Dipol.positionZ = z;
end







