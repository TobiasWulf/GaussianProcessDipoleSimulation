clear all
close all

% sensor array geometry, distance to dipole and size
nSensors = 8;
sensorArraySize = 2;

% relative sensor array position from dipole sphere in a position vector p
xPosition = 0;
yPosition = 0;
zPosition = 5;
p = [xPosition; yPosition; zPosition];

% sensor supply voltage and offset voltage
Vcc = 3.3;
Voff = 1.65;

% sensor characterization output is in mV/V so it needs a norming factor to
% supply voltage to get mV outputs after load
Vnorm = 1e3;

% sphere radius arround the dipole in mm
sphereRadius = 2;

% calculate magnetic moments for a subset of angles
% the moment amplitude to huge value to prevent numeric failure
m0 = 1e6;

% number of angles to observe, even from 0 to 360 degree
nTheta = 15;

% tilt angle in z-axes
phi = 0;

% angele resolution of rotation (full scale)
thetaResolution = 0.5;

% H-amplitude, multiply after norming the field results in kA/m
HAmp = 8.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% scale sensor array grid
[X, Y, Z] = generateSensorArraySquareGrid(nSensors, sensorArraySize, ...
    p, sphereRadius);

% compute moments
[M, theta, index] = generateDipoleRotationMoments(m0, nTheta, phi, thetaResolution);

% calculate the H-field magnitude for the dipole in zero position to get a
% norm factor to relative positions in the sensor array to calculate
% this means only z-component in r and only x-component in eliminates most
% of field formulat term to constants with x-componet to simple eqaution
H0norm = HAmp / abs(m0 / 4 / pi / (abs(sphereRadius)^3));


% https://en.wikipedia.org/wiki/Magnetic_dipole
% https://en.wikipedia.org/wiki/Magnetic_moment
% https://en.wikipedia.org/wiki/Unit_vector
% position of each sensor reshape grid to radius vectors 3xN^2 x,y,z column
R = [X(:), Y(:), Z(:)]';
% magnitude of radius
Rabs = sqrt(sum(R.^2, 1));
% unit vector to simplify the H field calculation
Runit = R ./ Rabs;
% calculate h-field with unit vector of r to simplify the field formular
H = zeros(3, nSensors^2);
Hx = zeros(nSensors, nSensors, nTheta);
Hy = zeros(nSensors, nSensors, nTheta);
Hz = zeros(nSensors, nSensors, nTheta);
for i = 1:nTheta
    % calculate H-field of one rotation step for all positions, this allows
    % singel positions too, the field is normed to zero position magnitude
    H = H0norm * (3 * Runit .* (M(:,i)' * Runit) - M(:,i)) / 4 / pi ./ Rabs.^3;
    % separate parts or field in axes direction/ components
    Hx(:,:,i) = reshape(H(1,:), nSensors, nSensors);
    Hy(:,:,i) = reshape(H(2,:), nSensors, nSensors);
    Hz(:,:,i) = reshape(H(2,:), nSensors, nSensors);
end

% Reference data from TDK chracterization dataset use rise characterization
% because of its big linear plateau
TDK = load('data/TDK_TAS2141_Characterization_2020-10-22_18-12-16-827.mat');
% Hx and Hy scales of 2D characterization bridge output data
HxScale = TDK.Data.MagneticField.hx;
HyScale = TDK.Data.MagneticField.hy;
% cosinus and sinus characteriazation bridge data in mV/V so multiply with
% voltage norm factor build by supply voltage and offset voltage
VcosRef = TDK.Data.SensorOutput.CosinusBridge.Rise .* (Vcc / Vnorm) + Voff;
VsinRef = TDK.Data.SensorOutput.SinusBridge.Rise .* (Vcc / Vnorm) + Voff;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot scratch for rotation
f = figure('units','normalized','outerposition',[0 0 1 1]);
t = tiledlayout(2, 2);
ax1 = nexttile;
scatter(ax1, X(:), Y(:), 10, 'filled')
ax1.NextPlot = 'add';
scatter(ax1, 0, 0, 18, 'k', 'filled')
quiver(ax1, X, Y, Vcos(:,:,1) - Voff, Vsin(:,:,1) - Voff, 'r');
axis square xy;
grid on;
minXLim = -(sensorArraySize + abs(xPosition));
minYLim = -(sensorArraySize + abs(yPosition));
maxXLim = sensorArraySize + abs(xPosition);
maxYLim = sensorArraySize + abs(yPosition);
xlim([minXLim, maxXLim])
ylim([minYLim, maxYLim])
ax1.NextPlot = 'replaceChildren';

ax2 = nexttile;
scatter(ax2, X(:), Y(:), 10, 'filled')
ax2.NextPlot = 'add';
scatter(ax2, 0, 0, 18, 'k', 'filled')
quiver(ax2, X, Y, Hx(:,:,1), Hy(:,:,1), 'r');
axis square xy;
grid on;
xlim([minXLim, maxXLim])
ylim([minYLim, maxYLim])
ax2.NextPlot = 'replaceChildren';

ax3 = nexttile;
immX = [min(HxScale) max(HxScale)];
immY = [min(HyScale) max(HyScale)];
p=imagesc(ax3, immX, immY, VcosRef);
set(p, 'AlphaData', ~isnan(VcosRef));
ax3.NextPlot = 'add';
scatter(ax3, reshape(Hx(:,:,1),1,nSensors^2), reshape(Hy(:,:,1),1,nSensors^2), 13, 'kx');
axis square xy;
ax3.NextPlot = 'replaceChildren';

ax4 = nexttile;
p=imagesc(ax4, immX, immY, VsinRef);
set(p, 'AlphaData', ~isnan(VsinRef));
ax4.NextPlot = 'add';
scatter(ax4, reshape(Hx(:,:,1),1,nSensors^2), reshape(Hy(:,:,1),1,nSensors^2), 13, 'kx');
axis square xy;
ax4.NextPlot = 'replaceChildren';

Frames(nTheta) = struct('cdata',[],'colormap',[]);
f.Visible = 'off';
for i = 1:nTheta
    fprintf('Render frame %d\n', i)
    scatter(ax1, X(:), Y(:), 10, 'filled')
    ax1.NextPlot = 'add';
    scatter(ax1, 0, 0, 18, 'k', 'filled')
    quiver(ax1, X, Y, Vcos(:,:,i) - Voff, Vsin(:,:,i) - Voff, 'r');
    ax1.NextPlot = 'replaceChildren';

    scatter(ax2, X(:), Y(:), 10, 'filled')
    ax2.NextPlot = 'add';
    scatter(ax2, 0, 0, 18, 'k', 'filled')
    quiver(ax2, X, Y, Hx(:,:,i), Hy(:,:,i), 'r');
    ax2.NextPlot = 'replaceChildren';
    
    p=imagesc(ax3, immX, immY, VcosRef);
    set(p, 'AlphaData', ~isnan(VcosRef));
    ax3.NextPlot = 'add';
    scatter(ax3, reshape(Hx(:,:,i),1,nSensors^2), reshape(Hy(:,:,i),1,nSensors^2), 13, 'kx');
    ax3.NextPlot = 'replaceChildren';
    
    p=imagesc(ax4, immX, immY, VsinRef);
    set(p, 'AlphaData', ~isnan(VsinRef));
    ax4.NextPlot = 'add';
    scatter(ax4, reshape(Hx(:,:,i),1,nSensors^2), reshape(Hy(:,:,i),1,nSensors^2), 13, 'kx');
    ax4.NextPlot = 'replaceChildren';
    
    %drawnow
    Frames(i) = getframe(f);
end
f.Visible = 'on';
movie(f, Frames, 3);
