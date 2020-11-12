% create a dipole with constant sphere radius in rest position and relative
% to sensor array with position x=0, y=0, z=0
% sphere radius 2mm
r = 2;
% distance in which the field stength is imprinted
z = 5;
% field strengt magnitude to imprint in dipole field on sphere radius kA/m
Hmag = 8.5;
% magnetic moment magnitude which rotates the dipole without tilt
Mmag = 1e6;

% compute norm factor
H0norm = computeDipoleH0Norm(Hmag, Mmag, z, r);
Comp = 4 * pi * abs(z + r)^3 * Hmag / abs(Mmag);

%% Test 1: positive scalar factor
assert(isscalar(H0norm))
assert(H0norm > 0)
assert(H0norm == Comp)
