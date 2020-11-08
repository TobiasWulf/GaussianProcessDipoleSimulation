% sensor array geometry, distance to dipole and size
nSensors = 8;
sensorArraySize = 2;
sensorArrayHalfSize = sensorArraySize / 2;
sensorArrayResolution = sensorArraySize / (nSensors -1);

% sphere radius arround dipole in mm
sphereRadius = 2;

% relative sensor array position from dipole center
xPosition = 0;
yPosition = 0;
zPosition = 0;

% sensor array grid
X = meshgrid(-sensorArrayHalfSize:sensorArrayResolution:sensorArrayHalfSize) - xPosition;
Y = meshgrid(-sensorArrayHalfSize:sensorArrayResolution:sensorArrayHalfSize) - yPosition;
Z = zeros(nSensors, nSensors) - sphereRadius - zPosition;

% position of each sensor dot reshape grid to position radius 3xN^2 x,y,z column
R = [X(:), Y(:), Z(:)]';

% magnitude of radius
Rabs = sqrt(sum(R.^2, 1));

% unit vector to simplify the H field calculation
Runit = R ./ Rabs;

% H-amplitude, multiply after norming the field results
HAmp = 8.477e3;

% calculate magnetic moments for a subset of angles
% the moment amplitude to huge value to prevent numeric failure
mAmp = 1e6;
% number of angles to observe, even from 0 to 360 degree
nTheta = 8;
% tilt angle in z-axes
phi = 0;
% angele resolution of rotation (full scale)
thetaResolution = 0.5;
% compute moments
[M, theta, index] = generateDipoleRotationMoments(mAmp, nTheta, phi, thetaResolution);

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
    H = (3 * Runit .* (M(:,1)' * Runit) - M(:,1)) / 4 / pi ./ Rabs.^3;
    % separate parts or field in axes direction/ components
    Hx(:,:,i) = reshape(H(1,:), nSensors, nSensors);
    Hy(:,:,i) = reshape(H(2,:), nSensors, nSensors);
    Hz(:,:,i) = reshape(H(2,:), nSensors, nSensors);
end

% get absolute magnitude maximum for all roataion elements, at least it is the
% last rotation part but because the dipole decribes a circle roation and the
% geoemetry of the sensor array is a square and even distributed it is allowed
% to get it from on rotation instead over all.
Habs = sqrt(sum(H.^2, 1));
HabsMax = max(Habs,[],'all');

