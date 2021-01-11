%===============================================================================
% [Dipol] = blockMeshgrid2(Magnet)
% Description:
%             
% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 12.01.2017
%===============================================================================
function [Dipol] = blockMeshgrid2(Magnet)
  x   = linspace( -Magnet.a/2, Magnet.a/2, Magnet.an);
  y   = linspace( -Magnet.b/2, Magnet.b/2, Magnet.bn);
  z   = linspace( -Magnet.c/2, Magnet.c/2, Magnet.cn);
  [xx,yy,zz] = meshgrid(x,y,z);
  
  Dipol.positionX = xx(:);
  Dipol.positionY = yy(:);
  Dipol.positionZ = zz(:);
  
  if (Magnet.rotate(1) ~= 0) || (Magnet.rotate(2) ~= 0) || (Magnet.rotate(3) ~= 0)
    rotPos = rotMatrix([Dipol.positionX';Dipol.positionY';Dipol.positionZ'],Magnet.rotate(1),Magnet.rotate(2),Magnet.rotate(3));
    Dipol.positionX=rotPos(1,:);
    Dipol.positionY=rotPos(2,:);
    Dipol.positionZ=rotPos(3,:);
  end

  Dipol.positionX = Dipol.positionX+Magnet.translate(1);
  Dipol.positionY = Dipol.positionY+Magnet.translate(2);
  Dipol.positionZ = Dipol.positionZ+Magnet.translate(3);
  
end