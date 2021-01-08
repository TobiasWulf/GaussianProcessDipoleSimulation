%===============================================================================
% calcBField()
% Description:
%             Calculate B-field with the equation of a magnetic Dipol. https://en.wikipedia.org/wiki/Magnetic_dipole
%             The caculated field is defined by the matrix calcField. The magnetic dipol is defined with the magnetic moment mue. 
% Input:
%           calcField    : calc B in this field [xmin xmax; ymin ymax; zmin zmax]
%           mue          : Vector of magnetic moment [ µx ; µy ; µz]
%           mue0         : magnetic field constant
%           resolution   : 
% Output:
%           Bx            : X-Component mxnxp
%           By            : Y-Component mxnxp
%           Bz            : z-Component mxnxp
%           xx            : matrix with 3D grid
%           yy            : matrix with 3D grid
%           zz            : matrix with 3D grid
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 19.12.2016
%===============================================================================
function [Bx,By,Bz,xx,yy,zz] = calcBField3D(calcField, mue, mue0, resolution)
    x           = linspace(calcField(1,1),calcField(1,2),resolution);
    y           = linspace(calcField(2,1),calcField(2,2),resolution);
    z           = linspace(calcField(3,1),calcField(3,2),resolution);
    [xx,yy,zz]  = meshgrid(x,y,z);
    Betrag      = sqrt(xx.^2 + yy.^2 + zz.^2);
    Skalar      = mue(1)*xx + mue(2)*yy + mue(3)*zz;
    Bx          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * xx .* (Skalar) - mue(1) .* Betrag.^2) ./ Betrag.^3;
    By          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * yy .* (Skalar) - mue(2) .* Betrag.^2) ./ Betrag.^3;
    Bz          = mue0 ./ (4 * pi * Betrag.^2) .* (3 * zz .* (Skalar) - mue(3) .* Betrag.^2) ./ Betrag.^3;
    
    Bx(isnan(Bx)==1)  = 0;
    By(isnan(By)==1)  = 0;
    Bz(isnan(Bz)==1)  = 0;
end
