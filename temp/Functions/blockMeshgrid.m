%===============================================================================
% [Dipol] = blockMeshgrid(Magnet)
% Description:
%             
% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 12.01.2017
%===============================================================================
function [Dipol] = blockMeshgrid(Magnet)
  x   = linspace( -Magnet.a/2+Magnet.translate(1), Magnet.a/2+Magnet.translate(1), Magnet.an);
  y   = linspace( -Magnet.b/2+Magnet.translate(2), Magnet.b/2+Magnet.translate(2), Magnet.bn);
  z   = linspace( -Magnet.c/2+Magnet.translate(3), Magnet.c/2+Magnet.translate(3), Magnet.cn);
  
  Dipol.positionX = repmat(x,Magnet.bn,1);
  Dipol.positionY = repmat(y,1,Magnet.an);
  
  Dipol.positionX = Dipol.positionX(:); 
  Dipol.positionY = Dipol.positionY(:);
  
  Dipol.positionX = repmat(Dipol.positionX,Magnet.cn,1);
  Dipol.positionY = repmat(Dipol.positionY,Magnet.cn,1);
  Dipol.positionZ = repmat(z,length(Dipol.positionX)/Magnet.cn,1); 
  Dipol.positionZ = Dipol.positionZ(:);
  
  if (Magnet.rotate(1) == 0) || (Magnet.rotate(2) == 0) || (Magnet.rotate(3) == 0)
    rotPos = rotMatrix([Dipol.positionX';Dipol.positionY';Dipol.positionZ'],Magnet.rotate(1),Magnet.rotate(2),Magnet.rotate(3));
    Dipol.positionX=rotPos(1,:);
    Dipol.positionY=rotPos(2,:);
    Dipol.positionZ=rotPos(3,:);
  end
    %===============================================================================
%  figure;
%  scatter3(Dipol.positionX,Dipol.positionY,Dipol.positionZ);
%  set(gca,'DataAspectRatio',[1 1 1]);
%  grid on;
%  title('Verteilung der Dipole');
%  xlabel("x-Koordinate");
%  ylabel("y-Koordinate");
end