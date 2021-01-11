%===============================================================================
% phi = calcAngle(Bx,By,position,unitX,unitY)
% Description:  Calculate the angle of a magnet. 
%             
% Input:    Bx          : x-component of the field
%           By          : y-component of the field
%           position    : position of the magnet
%           unitX       : unit of the sensor between two Sensors
%           unitY       : unit of the sensor between two Sensors
%
% Output:
%         phi           : Calculated angle
%
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 05.05.2017
%===============================================================================
function [phiBsum, phiSum] = calcAngle(Bx,By,position,unitX,unitY)
    p   = ceil(position(1,1)/unitX)-position(1,1)/unitX;
    q   = ceil(position(1,2)/unitY)-position(1,2)/unitY;
    % choose pixel one
    positionX1 = ceil(position(1,1)/unitX);
    positionY1 = ceil(position(1,2)/unitY);
    % choose pixel two
    positionX2 = floor(position(1,1)/unitX);
    positionY2 = ceil(position(1,2)/unitY);
    % choose pixel three
    positionX3 = floor(position(1,1)/unitX);
    positionY3 = floor(position(1,2)/unitY);
    % choose pixel four
    positionX4 = ceil(position(1,1)/unitX);
    positionY4 = floor(position(1,2)/unitY);
    
    phiBsum = atan2d(By(positionY1,positionX1)*((1-p)+(1-q)) + By(positionY2,positionX2)*(p+(1-q)) + By(positionY3,positionX3)*(p+q) + By(positionY4,positionX4)*(1-p+q),...
                 Bx(positionY1,positionX1)*((1-p)+(1-q)) + Bx(positionY2,positionX2)*(p+(1-q)) + Bx(positionY3,positionX3)*(p+q) + Bx(positionY4,positionX4)*(1-p+q));
             
    phiSum  = (atan2d(By(positionY1,positionX1),Bx(positionY1,positionX1))*((1-p)+(1-q)) + atan2d(By(positionY2,positionX2),Bx(positionY2,positionX2))*(p+(1-q))...
                        + atan2d(By(positionY3,positionX3),Bx(positionY3,positionX3))*(p+q) + atan2d(By(positionY4,positionX4),Bx(positionY4,positionX4))*(1-p+q))/4;
end