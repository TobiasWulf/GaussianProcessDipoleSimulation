%===============================================================================
% zylindricMeshgrid()
% Description:
%             Creates a zylindric meshgrid. Returns a structure with 3 members.
%             
% Input:
%           radian      : radian of the circle
%           nCricles    : number of circles
%           innerCircN  : number of dipols in the inner circle
%           zLayerPos   : number of circle layer
%           rotate      : array 3x1 [rotX rotY rotZ] in degree
% Output:
%           Dipol       : structure with the positions of every Dipol 
%                          Dipol.positionX
%                          Dipol.positionY
%                          Dipol.positionZ 
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 12.01.2017
%===============================================================================
function [Dipol] = cylindricalMeshgrid(Magnet)
  if Magnet.zLayer < 2
      zLayerPos = 0;
  else
    zLayerPos = linspace(-Magnet.height/2,Magnet.height/2,Magnet.zLayer);
  end
    A     = 0;      
  aOld  = 0;
  for ii = 1:1:Magnet.nCircles
    a = Magnet.innerCircN  * ii ;
    k = 0:2*pi/(a):2*pi-2*pi/(a);
    a = a + aOld;
    A = A + Magnet.radius/Magnet.nCircles;
    Dipol.positionX(aOld+1:a) =  A * cos(k);
    Dipol.positionY(aOld+1:a) =  A * sin(k);
    aOld = a;
  end

  for kk = 1:length(zLayerPos)
    Dipol.positionX(kk,:) = Dipol.positionX(1,:);
    Dipol.positionY(kk,:) = Dipol.positionY(1,:);
    Dipol.positionZ(kk,1:length(Dipol.positionY)) = zLayerPos(kk);
  end

  Dipol.positionX = Dipol.positionX(:)';
  Dipol.positionY = Dipol.positionY(:)';
  Dipol.positionZ = Dipol.positionZ(:)';
  
  if (Magnet.rotate(1) ~= 0) || (Magnet.rotate(2) ~= 0) || (Magnet.rotate(3) ~= 0)
    rotPos = rotMatrix([Dipol.positionX;Dipol.positionY;Dipol.positionZ], Magnet.rotate(1), Magnet.rotate(2), Magnet.rotate(3));
    Dipol.positionX = rotPos(1,:);
    Dipol.positionY = rotPos(2,:);
    Dipol.positionZ = rotPos(3,:);
  end
  
  Dipol.positionX = Dipol.positionX(:) + Magnet.translate(1);
  Dipol.positionY = Dipol.positionY(:) + Magnet.translate(2);
  Dipol.positionZ = Dipol.positionZ(:) + Magnet.translate(3);
%===============================================================================
%   figure;
%   scatter3(Dipol.positionX,Dipol.positionY,Dipol.positionZ);
%   set(gca,'DataAspectRatio',[1 1 1]);
%   grid on;
%   title('Verteilung der Dipole');
%   xlabel('x-Koordinate');
%   ylabel('y-Koordinate');
%   
end