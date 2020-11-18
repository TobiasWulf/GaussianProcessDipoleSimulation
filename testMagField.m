clear all
close all

% sampling and view
nSamples = 501;
nSlice = 25;

% grid space
xz = 15;
y = 0;

% sphere magnet
r = 2;
p = pi/2:0.01:3*pi/2;
Hmag = 200;
m0 = -1e6;
z0 = 1;

% destination field strength magnitude for linear area
% only the distance between surface and space limit get a label
zDest = -r:-z0:-xz;
xDest = zeros(1, length(zDest));

% scale grid
x = linspace(-xz, xz, nSamples);
z = linspace(xz, -xz, nSamples);
[X, Z, Y] = meshgrid(x, z, y);

% gridtick
gt = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calc zero position in x and z direction for y=0
m = rotate3DVector([m0; 0; 0], 0, 0, 0);
Hnorm = computeDipoleH0Norm(Hmag, m0, z0, r);
H = computeDipoleHField(X, Y, Z, m, Hnorm);
Habs = reshape(sqrt(sum(H.^2, 1)), nSamples, nSamples);
Hx = reshape(H(1,:), nSamples, nSamples) ./ Habs;
Hy = reshape(H(2,:), nSamples, nSamples) ./ Habs;
Hz = reshape(H(3,:), nSamples, nSamples) ./ Habs;
[HxDx, HxDz] = gradient(Hx);
[HzDx, HzDz] = gradient(Hz);

% exculde value with in the sphere radius
innerMag = X.^2 + Z.^2 <= r.^2; 
Habs(innerMag) = NaN;

% find relevant field strength and distances
HabsDest = interp2(X, Z, Habs, xDest, zDest, 'nearest', NaN);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create new figure
sub = ["Sphere radius r = 2mm", "imprinted H-field strength magnitude of 200kA/m", ...
     "in distance d = 1mm from surface with d = |z| - r."];
fig = newConfigFigure('Dipole Magnet', ...
    'Approximated Spherical Magnet (Dipole Far Field)', ...
    join(sub, ' ')); 
set(fig,'DoubleBuffer','on');
set(gcf,'renderer','zbuffer')

% plot magnitude as colormap
im = imagesc(x, z, log10(Habs), 'AlphaData', 1);
set(gca, 'YDir', 'normal');
colormap('jet');
cb = colorbar;
cb.Label.String = 'log10(|H|) in kA/m';
cb.Label.FontSize = 12;
% caxis([mag2db(0.1961) mag2db(200)]);
shading flat
% view(2)

% lock figure and grid
hold on
grid on

% plot field lines
st = streamslice(X, Z, Hx, Hz, 'noarrows', 'cubic');
set(st, 'Color', 'k');

% plot field vectors
idx = nSlice:nSlice:nSamples-nSlice;
q = quiver(X(idx, idx), Z(idx, idx), Hx(idx, idx), Hz(idx, idx), 0.5, 'k');

% plot magnet with north and south pole
rectangle('Position', [-r -r 2*r 2*r], 'Curvature', [1 1]);
semicrc = r.*[cos(p); sin(p)];
patch(semicrc(1,:), semicrc(2,:),'r')
patch(-semicrc(1,:), -semicrc(2,:),'g')
text(-1.25, 0, 'N', 'FontSize', 18)
text(0.5, 0, 'S', 'FontSize', 18)

% figure limts, ticks and labels
% limits
xlim(gca, [-xz xz])
ylim(gca, [-xz xz])

% ticks
xzticks = -xz:gt:xz;
xticks(xzticks)
yticks(xzticks)

% labels
xzlabels = string(xzticks);
xzlabels(1:2:end) = "";
xticklabels(xzlabels)
yticklabels(xzlabels)
xlabel('X in mm')
ylabel('Z in mm')

% additional figure text
text(-(xz-1), -(xz-1), 'Y = 0mm', 'Color', 'w', 'FontSize', 18)

% distance scale in -z direction for x =0, distance from magnet surface
line(gca, xDest, zDest, 'Marker', '_', 'LineStyle', '-', 'Color', 'w', ...
    'LineWidth', 2.0)
for i = 2:length(zDest)-1
    text(0.5, zDest(i), sprintf('d = %dmm, |H| = %.2fkA/m', ...
        abs(zDest(i))-r, HabsDest(i)), 'Color', 'w', 'FontSize', 10, ...
        'FontWeight', 'bold')
end

% axis set
axis equal
axis tight







