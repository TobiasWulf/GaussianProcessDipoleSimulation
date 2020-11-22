clear all
close all

% sensor array geometry, distance to dipole and size
nSensors = 8;
sensorArraySize = 2;

% ArrayPattern = ~logical([0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0; ...
%                          0 0 0 0 0 0 0 0 0]);

% relative sensor array position from dipole sphere in a position vector p
xPosition = 0;
yPosition = 0;
zPosition = 7;
p = [xPosition; yPosition; zPosition];

% sensor supply voltage and offset voltage
Vcc = 3.3;
Voff = 1.65;

% sensor characterization output is in mV/V so it needs a norming factor to
% supply voltage to get mV outputs after load
Vnorm = 1e3;

% sphere radius arround the dipole in mm
sphereRadius = 2;

% distance from sphere surface in mm where H-magnitude value takes effect
z0 = 1;

% calculate magnetic moments for a subset of angles
% set the moment magnitude to a huge value to prevent numeric failures
Mmag = 1e6;

% number of angles to observe, even from 0 to 360 degree
nTheta = 2;

% tilt angle in z-axes
phi = 0;

% angele resolution of rotation (full scale)
thetaResolution = 0.5;

% phase index to perform a shift from start angle
phaseIndex = 0;

% H-magnitured, multiply after norming the field results in kA/m
Hmag = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate sensor array grid
[X, Y, Z] = generateSensorArraySquareGrid(nSensors, sensorArraySize, ...
    p, sphereRadius);

% X(ArrayPattern) = NaN;
% Y(ArrayPattern) = NaN;
% Z(ArrayPattern) = NaN;

% generate magnetic moments
[M, theta, index] = generateDipoleRotationMoments(Mmag, nTheta, phi, ...
    thetaResolution, phaseIndex);

thetaStep = theta(2) - theta(1);

% compute dipole rest position norm to imprint a certain field strength magnitude
r0 = rotate3DVector([0; 0; -(z0 + sphereRadius)], 0, phi, 0);
H0norm = computeDipoleH0Norm(Hmag, M(:,1), r0);


% https://en.wikipedia.org/wiki/Magnetic_dipole
% https://en.wikipedia.org/wiki/Magnetic_moment
% https://en.wikipedia.org/wiki/Unit_vector
% position of each sensor reshape grid to radius vectors 3xN^2 x,y,z column
% calculate h-field with unit vector of r to simplify the field formular
H = zeros(3, nSensors^2);
Habs = zeros(nSensors, nSensors, nTheta);
Hx = zeros(nSensors, nSensors, nTheta);
Hy = zeros(nSensors, nSensors, nTheta);
Hz = zeros(nSensors, nSensors, nTheta);
for i = 1:nTheta
    % calculate H-field of one rotation step for all positions, this allows
    % singel positions too, the field is normed to zero position magnitude
    % H = (H0norm / 4 / pi) * (3 * Runit .* (M(:,i)' * Runit) - M(:,i)) ./ Rabs.^3;
    tic
    H = computeDipoleHField(X, Y, Z, M(:,i), H0norm);
    toc
    % separate parts or field in axes direction/ components
    Hx(:,:,i) = reshape(H(1,:), nSensors, nSensors);
    Hy(:,:,i) = reshape(H(2,:), nSensors, nSensors);
    Hz(:,:,i) = reshape(H(2,:), nSensors, nSensors);
    Habs(:,:,i) = reshape(sqrt(sum(H.^2, 1)), nSensors, nSensors);
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
    Vcos(:,:,i) = interp2(HxGrid, HyGrid, VcosRef, Hx(:,:,i), Hy(:,:,i), 'nearest', NaN);
    Vsin(:,:,i) = interp2(HxGrid, HyGrid, VsinRef, Hx(:,:,i), Hy(:,:,i), 'nearest', NaN);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot scratch for rotation
% f = figure('units','normalized','outerposition',[0 0 1 1]);
sub = [sprintf("Square Array with %d sensors and an edge length of %.1fmm,", ...
       nSensors^2, sensorArraySize); ...
       sprintf("a rel. pos. from magnet $(%.1f, %.1f, %.1f)$ in mm, a magnet tilt of $%.1f^\\circ$", ...
       xPosition, yPosition, -zPosition, phi); ...
       sprintf("and $%d$ rotation angles with step width of $%.1f^\\circ$ and angle resolution of $%.1f^\\circ$.", ...
       nTheta, thetaStep, thetaResolution)];


f = figure('Name', 'Sensor Array', ...
        'NumberTitle' , 'off', ...
        'WindowStyle', 'normal', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none', ...
        'Units', 'centimeters', ...
        'OuterPosition', [0 0 30 30], ...
        'PaperType', 'a4', ...
        'PaperUnits', 'centimeters', ...
        'PaperOrientation', 'landscape', ...
        'PaperPositionMode', 'auto', ...
        'DoubleBuffer', 'on', ...
        'RendererMode', 'manual', ...
        'Renderer', 'painters');

t = tiledlayout(f, 2, 2, ...
    'Padding', 'normal', ...
    'TileSpacing' , 'compact');

title(t, 'Sensor Array Simulation', ...
        'FontWeight', 'normal', ...
        'FontSize', 18, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');

subtitle(t, sub, ...
    'FontWeight', 'normal', ...
    'FontSize', 14, ...
    'FontName', 'Times', ...
    'Interpreter', 'latex');
    
colormap('gray')
ax1 = nexttile;
q1 = quiver(ax1, X, Y, Hx(:,:,1), Hy(:,:,1), 0.5, 'b');
ax1.NextPlot = 'add';
q2 = quiver(ax1, X, Y, Vcos(:,:,1) - Voff, Vsin(:,:,1) - Voff, 0.5, 'r');
scatter(ax1, X(:), Y(:), 18, 'k', 'filled')
scatter(ax1, X(1,1), Y(1,1), 18, 'r', 'filled')
scatter(ax1, X(1,end), Y(1,end), 18, 'g', 'filled')
scatter(ax1, X(end,1), Y(end,1), 18, 'm', 'filled')
scatter(ax1, X(end,end), Y(end,end), 18, 'c', 'filled')
legend([q1, q2], 'quiver(Hx,Hy)', 'quiver(Vcos-Voff,Vsin-Voff)')
xlabel('x in mm', 'FontSize', 12)
ylabel('y in mm', 'FontSize', 12)
axis square xy
axis tight
grid on;

maxXLim = xPosition + sensorArraySize;
maxYLim = yPosition + sensorArraySize;
minXLim = xPosition - sensorArraySize;
minYLim = yPosition - sensorArraySize;
xlim([minXLim, maxXLim])
ylim([minYLim, maxYLim])
title(sprintf('Z-Layer of %d x %d Sensor Array', nSensors, nSensors))
ax1.NextPlot = 'replaceChildren';

nexttile;
polarscatter(theta/180*pi, ones(1, nTheta), 'r');
ax2 = gca;
rticks(1)
rticklabels("")
title('Rotation around Z-Axis')
ax2.NextPlot = 'add';

ax3 = nexttile;
p=imagesc(ax3, HxScale, HyScale, VcosRef);
set(gca, 'YDir', 'normal');
set(p, 'AlphaData', ~isnan(VcosRef));
ax3.NextPlot = 'add';
scatter(ax3, reshape(Hx(:,:,1),1,nSensors^2), reshape(Hy(:,:,1),1,nSensors^2), 13, 'kx');
scatter(ax3, Hx(1,1,1), Hy(1,1,1), 13, 'rx');
scatter(ax3, Hx(1,end,1), Hy(1,end,1), 13, 'gx');
scatter(ax3, Hx(end,1,1), Hy(end,1,1), 13, 'mx');
scatter(ax3, Hx(end,end,1), Hy(end,end,1), 13, 'cx');
axis square xy
axis tight
xlabel('Hx in kA/m', 'FontSize', 12)
ylabel('Hy in kA/m', 'FontSize', 12)
title('Vcos(Hx,Hy)', 'FontSize', 12, 'FontWeight', 'bold')
cb1 = colorbar;
cb1.Label.String = sprintf('Vcos in V, Vcc = %1.1fV, Voff = %1.2fV', Vcc, Voff);
cb1.Label.FontSize =12;
ax3.NextPlot = 'replaceChildren';


ax4 = nexttile;
p=imagesc(ax4, HxScale, HyScale, VsinRef);
set(gca, 'YDir', 'normal');
set(p, 'AlphaData', ~isnan(VsinRef));
ax4.NextPlot = 'add';
scatter(ax4, reshape(Hx(:,:,1),1,nSensors^2), reshape(Hy(:,:,1),1,nSensors^2), 13, 'kx');
scatter(ax4, Hx(1,1,1), Hy(1,1,1), 13, 'rx');
scatter(ax4, Hx(1,end,1), Hy(1,end,1), 13, 'gx');
scatter(ax4, Hx(end,1,1), Hy(end,1,1), 13, 'mx');
scatter(ax4, Hx(end,end,1), Hy(end,end,1), 13, 'cx');
axis square xy
axis tight
xlabel('Hx in kA/m', 'FontSize', 12)
ylabel('Hy in kA/m', 'FontSize', 12)
title('Vsin(Hx,Hy)')
cb2 = colorbar;
cb2.Label.String = sprintf('Vsin in V, Vcc = %1.1fV, Voff = %1.2fV', Vcc, Voff);
cb2.Label.FontSize =12;
ax4.NextPlot = 'replaceChildren';


%Frames(nTheta) = struct('cdata',[],'colormap',[]);
% f.Visible = 'off';
for i = 1:nTheta
    fprintf('Render frame %d\n', i)
    q1 = quiver(ax1, X, Y, Hx(:,:,i), Hy(:,:,i), 0.5, 'b');
    ax1.NextPlot = 'add';
    q2 = quiver(ax1, X, Y, Vcos(:,:,i) - Voff, Vsin(:,:,i) - Voff, 0.5, 'r');
    scatter(ax1, X(:), Y(:), 18, 'k', 'filled')
    scatter(ax1, X(1,1), Y(1,1), 18, 'r', 'filled')
    scatter(ax1, X(1,end), Y(1,end), 18, 'g', 'filled')
    scatter(ax1, X(end,1), Y(end,1), 18, 'm', 'filled')
    scatter(ax1, X(end,end), Y(end,end), 18, 'c', 'filled')
    legend([q1, q2], 'quiver(Hx,Hy)', 'quiver(Vcos-Voff,Vsin-Voff)')
    ax1.NextPlot = 'replaceChildren';
    
    polarscatter(ax2 ,theta(i)/180*pi, 1, 'b', 'filled');
    
    p=imagesc(ax3, HxScale, HyScale, VcosRef);
    set(p, 'AlphaData', ~isnan(VcosRef));
    set(gca, 'YDir', 'normal');
    ax3.NextPlot = 'add';
    scatter(ax3, reshape(Hx(:,:,i),1,nSensors^2), reshape(Hy(:,:,i),1,nSensors^2), 13, 'kx');
    scatter(ax3, Hx(1,1,i), Hy(1,1,i), 13, 'rx');
    scatter(ax3, Hx(1,end,i), Hy(1,end,i), 13, 'gx');
    scatter(ax3, Hx(end,1,i), Hy(end,1,i), 13, 'mx');
    scatter(ax3, Hx(end,end,i), Hy(end,end,i), 13, 'cx');
    ax3.NextPlot = 'replaceChildren';
    
    p=imagesc(ax4, HxScale, HyScale, VsinRef);
    set(gca, 'YDir', 'normal');
    set(p, 'AlphaData', ~isnan(VsinRef));
    ax4.NextPlot = 'add';
    scatter(ax4, reshape(Hx(:,:,i),1,nSensors^2), reshape(Hy(:,:,i),1,nSensors^2), 13, 'kx');
    scatter(ax4, Hx(1,1,i), Hy(1,1,i), 13, 'rx');
    scatter(ax4, Hx(1,end,i), Hy(1,end,i), 13, 'gx');
    scatter(ax4, Hx(end,1,i), Hy(end,1,i), 13, 'mx');
    scatter(ax4, Hx(end,end,i), Hy(end,end,i), 13, 'cx');
    ax4.NextPlot = 'replaceChildren';
    
    drawnow
    %Frames(i) = getframe(f);
end
% movie(f, Frames, 1, 3);
