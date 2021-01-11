%===============================================================================
% [MagField] = calcMagFieldRotSensor(Dipol, Magnet, Sensor, plotActive)
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
%
%   author : thorben schuethe 
%   Mail    : thorben.schuethe@haw-hamburg.de
%   date    : 29.11.2017
%   Changelog: change the function to rotate the sensor array in all
%   directions so that we can compute all cases 
%===============================================================================
function [MagField] = calcMagFieldRotSensor(Dipol, Magnet, Sensor, plotActive)
  MagField.Bx = zeros(Sensor.resolution(2),Sensor.resolution(1));
  MagField.By = zeros(Sensor.resolution(2),Sensor.resolution(1));
  MagField.Bz = zeros(Sensor.resolution(2),Sensor.resolution(1));
  for ii = 1:length(Dipol.positionX)
        calcDipolField   = [	Sensor.pointsX(1) - Dipol.positionX(ii) +Sensor.pointsX(end) - Dipol.positionX(ii);...     % Defines the calculated dipol field
                                Sensor.pointsY(1) - Dipol.positionY(ii) +Sensor.pointsY(end) - Dipol.positionY(ii);...
                             	Sensor.pointsZ(1) - Dipol.positionZ(ii) +Sensor.pointsZ(end) - Dipol.positionZ(ii);];
        
%%
 
        x           = linspace(calcDipolField(1,1),calcDipolField(1,2),Sensor.resolution);
        y           = linspace(calcDipolField(2,1),calcDipolField(2,2),Sensor.resolution);
        z           = linspace(calcDipolField(3,1),calcDipolField(3,2),Sensor.resolution);
        
        [xx,yy,zz]  = meshgrid(x,y,z);
        
        Betrag      = sqrt(xx.^2 + yy.^2 + zz.^2);
        Skalar      = Magnet.mue(1)*xx + Magnet.mue(2)*yy + Magnet.mue(3)*zz;
        Bx          = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * xx .* (Skalar) - Magnet.mue(1) .* Betrag.^2) ./ Betrag.^3;
        By          = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * yy .* (Skalar) - Magnet.mue(2) .* Betrag.^2) ./ Betrag.^3;
        Bz          = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * zz .* (Skalar) - Magnet.mue(3) .* Betrag.^2) ./ Betrag.^3;

        Bx(isnan(Bx)==1)  = 0;
        By(isnan(By)==1)  = 0;
        Bz(isnan(Bz)==1)  = 0;
                         
                         
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