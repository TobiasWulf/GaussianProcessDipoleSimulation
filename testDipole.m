% sensor array geometry, distance to dipole and size
nSensors = 8;
sensorArraySize = 2;
sensorArrayHalfSize = sensorArraySize / 2;
sensorArrayResolution = sensorArraySize / (nSensors -1);

% sensor supply voltage and offset voltage
Vcc = 3.3;
Voff = Vcc / 2;

% sensor characterization output is in mV/V so it needs a norming factor to
% supply voltage to get mV outputs after load
Vnorm = Vcc / 1e3 + Voff;

% sphere radius arround dipole in mm
sphereRadius = 2;

% relative sensor array position from dipole center
xPosition = 0;
yPosition = 0;
zPosition = -(0 + sphereRadius);

% sensor array grid
gridVector = -sensorArrayHalfSize:sensorArrayResolution:sensorArrayHalfSize;
[X, Y] = meshgrid(gridVector, gridVector);
X = X + xPosition;
Y = Y + yPosition;
Z = zeros(nSensors, nSensors) + zPosition;

% position of each sensor dot reshape grid to position radius 3xN^2 x,y,z column
R = [X(:), Y(:), Z(:)]';

% magnitude of radius
Rabs = sqrt(sum(R.^2, 1));

% unit vector to simplify the H field calculation
Runit = R ./ Rabs;

% H-amplitude, multiply after norming the field results in kA/m
HAmp = 8.5;

% calculate magnetic moments for a subset of angles
% the moment amplitude to huge value to prevent numeric failure
mAmp = 1e6;
% number of angles to observe, even from 0 to 360 degree
nTheta = 7;
% tilt angle in z-axes
phi = 0;
% angele resolution of rotation (full scale)
thetaResolution = 0.5;
% compute moments
[M, theta, index] = generateDipoleRotationMoments(mAmp, nTheta, phi, thetaResolution);

% calculate the H-field magnitude for the dipole in zero position to get a
% norm factor to relative positions in the sensor array to calculate
% this means only z-component in r and only x-component in eliminates most
% of field formulat term to constants with x-componet to simple eqaution
Hnorm = abs(mAmp / 4 / pi / (abs(zPosition)^3));

% https://en.wikipedia.org/wiki/Magnetic_dipole
% https://en.wikipedia.org/wiki/Magnetic_moment
% https://en.wikipedia.org/wiki/Unit_vector
% calculate h-field with unit vector of r to simplify the field formular
H = zeros(3, nSensors^2);
Hx = zeros(nSensors, nSensors, nTheta);
Hy = zeros(nSensors, nSensors, nTheta);
Hz = zeros(nSensors, nSensors, nTheta);
for i = 1:nTheta
    % calculate H-field of one rotation step for all positions, this allows
    % singel positions too
    H = HAmp * (3 * Runit .* (M(:,i)' * Runit) - M(:,i)) / Hnorm / 4 / pi ./ Rabs.^3;
    % separate parts or field in axes direction/ components
    Hx(:,:,i) = reshape(H(1,:), nSensors, nSensors);
    Hy(:,:,i) = reshape(H(2,:), nSensors, nSensors);
    Hz(:,:,i) = reshape(H(2,:), nSensors, nSensors);
end

% Reference data from TDK chracterization dataset use rise characterization
% because of its big linear plateau
TDK = load('data/TDK_TAS2141_Characterization_2019-07-24.mat');
% Hx and Hy scales of 2D characterization bridge output data
HxScale = TDK.Data.MagneticField.hx;
HyScale = TDK.Data.MagneticField.hy;
% cosinus and sinus characteriazation bridge data in mV/V so multiply with
% voltage norm factor build by supply voltage and offset voltage
VcosRef = TDK.Data.SensorOutput.CosinusBridge.Rise .* Vnorm;
VsinRef = TDK.Data.SensorOutput.SinusBridge.Rise .* Vnorm;

% generate from H-field scale vectors field grid which coordinates
% reference bridge data to get nearest references from grid 
[HxGrid, HyGrid] = meshgrid(HxScale, HyScale);

% cross pick references from grid, the Hx and Hy queries can be served as
% matrix as long they have same size and orientation the nearest neigbhor
% interpolation returns of same size and related to orientation, for
% outlayers return NaN, do this for every angle
Vcos = zeros(nSensors, nSensors, nTheta);
Vsin = zeros(nSensors, nSensors, nTheta);
for i = 1:nTheta
    Vcos(:,:,i) = interp2(HxGrid, HyGrid, VcosRef, Hx(:,:,i), Hy(:,:,i));
    Vsin(:,:,i) = interp2(HxGrid, HyGrid, VsinRef, Hx(:,:,i), Hy(:,:,i));
end
