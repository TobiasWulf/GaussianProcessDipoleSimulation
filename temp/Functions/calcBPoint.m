%===============================================================================
% calcBPoint
% Description:
%             Calculate B-vector at rVec
% Input:
%           rVec    : Calculate B-field at this point
%           mue     : Vector of magnetic moment
%           mue0    : magnetic field constant
% Output:
%           B       : Vector of the magnetic field at rVec
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 18.12.2016
%===============================================================================
function B = calcBPoint(rVec, mue, mue0)

rAbs= norm(rVec);

B = mue0 / (4 * pi * rAbs^2) * (3 * rVec * (mue.' * rVec) - mue * rAbs^2) / rAbs^3 ;

end