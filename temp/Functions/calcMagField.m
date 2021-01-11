%===============================================================================
% [MagField] = calcMagField(Dipol, Magnet, Sensor, plotActive)
% Description:
%             This function overlays the fields of many magnetic Dipols
% Input:
%               Dipol   : Structure with following variables
%                       positionX   :   X-coordinates from the Dipols
%                       positionY   :   y-coordinates from the Dipols
%                       positionZ   :   z-coordinates from the Dipols
%               Magnet  : Structure with following variables
%                       mue         : Vector of magnetic moment [ µx ; µy ; µz]
%                       mue0        : Magnetic field constant
%               Sensor  : Structure with following variables
%                       resolution  : resolution of the sensor
%                       pointsX     : X-Coodinates of the sensor
%                       pointsY     : Y-Coodinates of the sensor
%                       zPos        : Z-Coordinate of the sensor
%               plotActive  : Plots the magnet and the Sensor with magnetic
%               fieldlines
% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 12.01.2017
%===============================================================================
function [MagField] = calcMagField(Dipol, Magnet, Sensor, plotActive)
  MagField.Bx = zeros(Sensor.resolution(2),Sensor.resolution(1));
  MagField.By = zeros(Sensor.resolution(2),Sensor.resolution(1));
  MagField.Bz = zeros(Sensor.resolution(2),Sensor.resolution(1));
  for ii = 1:length(Dipol.positionX)
        calcDipolField   = [  Sensor.pointsX(1) - Dipol.positionX(ii) +Sensor.pointsX(end) - Dipol.positionX(ii);...     % Defines the calculated dipol field
                             Sensor.pointsY(1) - Dipol.positionY(ii) +Sensor.pointsY(end) - Dipol.positionY(ii);...
                             +Sensor.zPos + Dipol.positionZ(ii) 0];
        
        [Bx, By, Bz,xx,yy]  = calcBField2D(calcDipolField, Magnet.mue, Magnet.mue0, Sensor.resolution);  % calculate the dipol field
        MagField.Bx = MagField.Bx + Bx;
        MagField.By = MagField.By + By;
        MagField.Bz = MagField.Bz + Bz;
  end

  if plotActive == 1
    [xx,yy]     = meshgrid(Sensor.pointsX,Sensor.pointsY); 
    zz          = ones(length(yy(:,1)),length(xx(1,:)))*Sensor.zPos;
    figure;
    quiver3(xx,yy,zz, MagField.Bx,MagField.By,zeros(length(By(:,1)),length(Bx(1,:))));
    hold on;
    scatter3(Dipol.positionX,Dipol.positionY,Dipol.positionZ);
    hold off;
    set(gca,'DataAspectRatio',[1 1 1]);
    grid on;
    xlabel('x-Koordinate'),ylabel('y-Koordinate');
  end

end