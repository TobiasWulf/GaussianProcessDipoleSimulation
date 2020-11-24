clear all
close all

% sensor array geometry, distance to dipole and size
N = 8;
a = 2;


% relative sensor array position from dipole sphere in a position vector p
xPos = 0;
yPos = 0;
zPos = 7;
p = [xPos; yPos; zPos];

% sensor supply voltage and offset voltage
Vcc = 3.3;
Voff = 1.65;

% sensor characterization output is in mV/V so it needs a norming factor to
% supply voltage to get mV outputs after load
Vnorm = 1e3;

% sphere radius arround the dipole in mm
rsp = 2;

% distance from sphere surface in mm where H-magnitude value takes effect
z0 = 1;

% calculate magnetic moments for a subset of angles
% set the moment magnitude to a huge value to prevent numeric failures
M0mag = 1e6;

% number of angles to observe, even from 0 to 360 degree
nAngles = 12;

% tilt angle in z-axes
tilt = 0;

% angele resolution of rotation (full scale)
angleRes = 0.5;

% phase index to perform a shift from start angle
phaseIndex = 0;

% H-magnitured, multiply after norming the field results in kA/m
H0mag = 200;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate sensor array grid
[X, Y, Z] = generateSensorArraySquareGrid(N, a, ...
    p, rsp);


% generate magnetic moments
[m, angles, anglesRefIndex] = generateDipoleRotationMoments(M0mag, nAngles, tilt, ...
    angleRes, phaseIndex);

angleStep = angles(1) - angles(end) + 360;

% compute dipole rest position norm to imprint a certain field strength magnitude
r0 = rotate3DVector([0; 0; -(z0 + rsp)], 0, tilt, 0);
m0 = rotate3DVector([-M0mag; 0; 0], 0, tilt, 0);
H0norm = computeDipoleH0Norm(H0mag, m0, r0);


% https://en.wikipedia.org/wiki/Magnetic_dipole
% https://en.wikipedia.org/wiki/Magnetic_moment
% https://en.wikipedia.org/wiki/Unit_vector
% position of each sensor reshape grid to radius vectors 3xN^2 x,y,z column
% calculate h-field with unit vector of r to simplify the field formular
H = zeros(3, N^2);
Habs = zeros(N, N, nAngles);
Hx = zeros(N, N, nAngles);
Hy = zeros(N, N, nAngles);
Hz = zeros(N, N, nAngles);
for i = 1:nAngles
    % calculate H-field of one rotation step for all positions, this allows
    % singel positions too, the field is normed to zero position magnitude
    % H = (H0norm / 4 / pi) * (3 * Runit .* (M(:,i)' * Runit) - M(:,i)) ./ Rabs.^3;
    tic
    H = computeDipoleHField(X, Y, Z, m(:,i), H0norm);
    toc
    % separate parts or field in axes direction/ components
    Hx(:,:,i) = reshape(H(1,:), N, N);
    Hy(:,:,i) = reshape(H(2,:), N, N);
    Hz(:,:,i) = reshape(H(2,:), N, N);
    Habs(:,:,i) = reshape(sqrt(sum(H.^2, 1)), N, N);
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
[HxScaleGrid, HyScaleGrid] = meshgrid(HxScale, HyScale);
% cross pick references from grid, the Hx and Hy queries can be served as
% matrix as long they have same size and orientation the nearest neigbhor
% interpolation returns of same size and related to orientation, for
% outlayers return NaN, do this for every angle
Vcos = zeros(N, N, nAngles);
Vsin = zeros(N, N, nAngles);
for i = 1:nAngles
    Vcos(:,:,i) = interp2(HxScaleGrid, HyScaleGrid, VcosRef, Hx(:,:,i), Hy(:,:,i), 'nearest', NaN);
    Vsin(:,:,i) = interp2(HxScaleGrid, HyScaleGrid, VsinRef, Hx(:,:,i), Hy(:,:,i), 'nearest', NaN);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% plot scratch for rotation
% f = figure('units','normalized','outerposition',[0 0 1 1]);
sub = [sprintf("Square Array with %d sensors and an edge length of %.1fmm,", ...
       N^2, a); ...
       sprintf("a rel. pos. from magnet $(%.1f, %.1f, %.1f)$ in mm, a magnet tilt of $%.1f^\\circ$", ...
       xPos, yPos, -zPos, tilt); ...
       sprintf("and $%d$ rotation angles with step width of $%.1f^\\circ$ and angle resolution of $%.1f^\\circ$.", ...
       nAngles, angleStep, angleRes)];


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

maxXLim = xPos + a;
maxYLim = yPos + a;
minXLim = xPos - a;
minYLim = yPos - a;
xlim([minXLim, maxXLim])
ylim([minYLim, maxYLim])
title(sprintf('Z-Layer of %d x %d Sensor Array', N, N))
ax1.NextPlot = 'replaceChildren';

nexttile;
polarscatter(angles/180*pi, ones(1, nAngles), 'r');
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
scatter(ax3, reshape(Hx(:,:,1),1,N^2), reshape(Hy(:,:,1),1,N^2), 13, 'kx');
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
scatter(ax4, reshape(Hx(:,:,1),1,N^2), reshape(Hy(:,:,1),1,N^2), 13, 'kx');
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
for i = 1:nAngles
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
    
    polarscatter(ax2 ,angles(i)/180*pi, 1, 'b', 'filled');
    
    p=imagesc(ax3, HxScale, HyScale, VcosRef);
    set(p, 'AlphaData', ~isnan(VcosRef));
    set(gca, 'YDir', 'normal');
    ax3.NextPlot = 'add';
    scatter(ax3, reshape(Hx(:,:,i),1,N^2), reshape(Hy(:,:,i),1,N^2), 13, 'kx');
    scatter(ax3, Hx(1,1,i), Hy(1,1,i), 13, 'rx');
    scatter(ax3, Hx(1,end,i), Hy(1,end,i), 13, 'gx');
    scatter(ax3, Hx(end,1,i), Hy(end,1,i), 13, 'mx');
    scatter(ax3, Hx(end,end,i), Hy(end,end,i), 13, 'cx');
    ax3.NextPlot = 'replaceChildren';
    
    p=imagesc(ax4, HxScale, HyScale, VsinRef);
    set(gca, 'YDir', 'normal');
    set(p, 'AlphaData', ~isnan(VsinRef));
    ax4.NextPlot = 'add';
    scatter(ax4, reshape(Hx(:,:,i),1,N^2), reshape(Hy(:,:,i),1,N^2), 13, 'kx');
    scatter(ax4, Hx(1,1,i), Hy(1,1,i), 13, 'rx');
    scatter(ax4, Hx(1,end,i), Hy(1,end,i), 13, 'gx');
    scatter(ax4, Hx(end,1,i), Hy(end,1,i), 13, 'mx');
    scatter(ax4, Hx(end,end,i), Hy(end,end,i), 13, 'cx');
    ax4.NextPlot = 'replaceChildren';
    
    drawnow
    %Frames(i) = getframe(f);
end
% movie(f, Frames, 1, 3);
