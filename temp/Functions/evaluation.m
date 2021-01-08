%===============================================================================
% evaluation()
% Description:
%             
% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 12.01.2017
%===============================================================================
function [MagField] = evaluation(Dipol, Magnet, Sensor)
MagField.BxGes = zeros(Sensor.resolution,Sensor.resolution);
MagField.ByGes = zeros(Sensor.resolution,Sensor.resolution);
for ii = 1:length(Dipol.positionX)

      calcDipolField   = [ -Sensor.field/2 - Dipol.positionX(ii) +Sensor.field/2 - Dipol.positionX(ii);...     % Defines the calculated dipol field
                           -Sensor.field/2 - Dipol.positionY(ii) +Sensor.field/2 - Dipol.positionY(ii);...
                           +Sensor.zPos + Dipol.positionZ(ii) 0];

      [Bx, By, xx, yy]  = calcBField2D(calcDipolField, Magnet.mue, Magnet.mue0, Sensor.resolution);  % calculate the dipol field
      MagField.BxGes = MagField.BxGes + Bx;
      MagField.ByGes = MagField.ByGes + By;

      %[magnitude, phase]=plot2DmagnField(Bx,By,Sensor.zPos,xx,yy,Magnet.mue);
endfor

[MagField.magnitude, MagField.phase]=plot2DmagnField(MagField.BxGes, MagField.ByGes, Sensor.zPos, Sensor.xxGrid, Sensor.yyGrid, Magnet.mue);
end