%===============================================================================
% [Bx,By,Bz,xx,yy] = calcBField2D(calcField, mue, mue0, resolution)
% Description:
%             Calculate B-field with the equation of a magnetic Dipol. 
%             https://en.wikipedia.org/wiki/Magnetic_dipole
%             The calcculated field is defined by the matrix calcField.
%             The magnetic dipol is defined with the magnetic moment mue. 
% Input:
%           calcField    : Calc B in this field [xmin xmax; ymin ymax; Sensor.zPos 0]
%           mue          : Vector of magnetic moment [ µx ; µy ; µz]
%           mue0         : Magnetic field constant
%           resolution   : 
% Output:
%           Bx            : X-Component mxnxp
%           By            : Y-Component mxnxp
%           xx            : matrix with 2D grid
%           yy            : matrix with 2D grid
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 05.01.2017
%===============================================================================
function [Bx,By,Bz,xx,yy] = calcBField2D(calcField, mue, mue0, resolution)
    x           = linspace(calcField(1,1),calcField(1,2),resolution(1));
    y           = linspace(calcField(2,1),calcField(2,2),resolution(2));
    z           = calcField(3,1);
    [xx,yy]     = meshgrid(x,y);
    Betrag      = sqrt(xx.^2 + yy.^2 + z^2);
    Skalar      = mue(1)*xx + mue(2)*yy + mue(3)*z;
    Bx          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * xx .* (Skalar) - mue(1) .* Betrag.^2) ./ Betrag.^3;
    By          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * yy .* (Skalar) - mue(2) .* Betrag.^2) ./ Betrag.^3;
    Bz          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * z  .* (Skalar) - mue(3) .* Betrag.^2) ./ Betrag.^3;
    
    Bx(isnan(Bx)==1)  = 0;
    By(isnan(By)==1)  = 0;
end