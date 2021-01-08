%===============================================================================
% [Dipol] = cylindricalMeshgrid2(Magnet)
% Description:
%             Creates a zylindric meshgrid. Returns a structure with 3 members.
%             
% Input:
%           radius      : radius of the circle
%           nCricles    : number of circles
%           innerCircN  : number of dipols in the inner circles
%           zLayerPos   : number of circle layer
%           rotate      : array 3x1 [rotX rotY rotZ] in degree
% Output:
%           Dipol       : structure with the positions of every Dipol 
%                          Dipol.positionX
%                          Dipol.positionY
%                          Dipol.positionZ 
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 22.03.2017
%===============================================================================
function [Dipol] = cylindricalMeshgrid2(Magnet)
    n = Magnet.n;
    radius = Magnet.radius;
    x   = linspace(-radius,radius,n);
    y   = linspace(-radius,radius,n);
    z   = linspace(-Magnet.height/2,Magnet.height/2,n);
    [xx,yy,zz]    = meshgrid(x,y,z);

    Betrag = sqrt(xx.^2 + yy.^2);
    xx(Betrag>radius)=NaN;
    yy(Betrag>radius)=NaN;
    zz(isnan(xx)==1)=NaN;
    xx = xx(:);
    yy = yy(:);
    zz = zz(:);
    yy(isnan(xx)==1)=[];
    zz(isnan(xx)==1)=[];
    xx(isnan(xx)==1)=[];
    Dipol.positionX = xx;
    Dipol.positionY = yy;
    Dipol.positionZ = zz;
  
end