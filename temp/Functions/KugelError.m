%===============================================================================
% [e] = KugelError(r,layer,phiInc,thetaInc,zPos)
% Description:  Creates a sphere meshgrid.
%             
% Input:  

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 13.02.2017
%===============================================================================
function [e] = KugelError(r,layer,phiInc,thetaInc,zPos)

  %===============================================================================
  % define Magnet
  %===============================================================================
  Magnet.raidian    = r;        % outer raidian of the sphere
  Magnet.layer      = layer;        % number of sphere-layers
  Magnet.phiInc     = phiInc;        % defines the number of circles of the inner sphere
  Magnet.thetaInc   = thetaInc;        % defines the number/2 of Dipols of one circle in the inner sphere 
  n=0;
  for ii=1:Magnet.layer
    n = n + Magnet.phiInc*(ii^2*Magnet.thetaInc-ii);
  end
  n=n+2;
  Magnet.rotate     = [0 0 0];
  Magnet.translate  = [0 0 0];
  Magnet.mue0       = 1;
  Magnet.mue        = rotMatrix([0;0;1],Magnet.rotate(1),Magnet.rotate(2),Magnet.rotate(3));%[-1;0;0];

  %===============================================================================
  % define Sensor
  %===============================================================================
  Sensor.field      = [4 4];    % size of the sensorfield (edge length)
  Sensor.resolution = [9 9];    % resolution of the sensor field
  Sensor.zPos       = zPos;    % z-Position of the sensor
  Sensor.points     = linspace(-Sensor.field/2, Sensor.field/2, Sensor.resolution);
  Sensor.pointsX     = linspace(-Sensor.field(1)/2, Sensor.field(1)/2, Sensor.resolution(1)); 
  Sensor.pointsY     = linspace(-Sensor.field(2)/2, Sensor.field(2)/2, Sensor.resolution(2));  
  [Sensor.xxGrid,...
   Sensor.yyGrid]   = meshgrid(Sensor.pointsX,Sensor.pointsY); 
   
  %===============================================================================
  % create dipol position
  %===============================================================================
  [Dipol] = KugelMeshgrid(Magnet);

  %===============================================================================
  % calc field
  %===============================================================================
  [MagField] = calcMagField(Dipol, Magnet, Sensor,1);

  %===============================================================================
  % analytic calculation of sphere magnet
  %===============================================================================

  M0z   = Magnet.mue(3) * length(Dipol.positionX) / (4 * pi * Magnet.raidian^3 / 3); 
  Bi    = 2 * Magnet.mue0 / 3 * M0z;
  mueZ  = (4 * pi * Magnet.raidian^3 / 3) * M0z;

  calcField         = [Sensor.field(1)/2 -Sensor.field(1)/2;Sensor.field(2)/2 -Sensor.field(2)/2;-Sensor.zPos 0];
  [Bx By Bz xx yy]  = calcBField2D(calcField,[0;0;mueZ],Magnet.mue0,Sensor.resolution);
  a= MagField.By./By;
  a(isinf(a)==1)=[];
  a(isnan(a)==1)=[];
  
  e = sum(((abs(a)-1).^2)(:));
end