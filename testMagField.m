clear all
close all

x = linspace(-0.012, 0.012, 200);
y = 0;
z = linspace(0.012, -0.012, 200);
[X, Z, Y] = meshgrid(x, z, 0);


m = rotate3DVector([-1e6; 0; 0], 0, 0, 0);

Hnorm = computeDipoleH0Norm(200e3, -1e6, 0.0008, 0.002);

H = computeDipoleHField(X, Y, Z, m, Hnorm);

Habs = reshape(sqrt(sum(H.^2, 1)), 200, 200);

Hx = reshape(H(1,:), 200, 200) ./ Habs;
Hy = reshape(H(2,:), 200, 200) ./ Habs;
Hz = reshape(H(3,:), 200, 200) ./ Habs;

[HxDx, HxDz] = gradient(Hx);
[HzDx, HzDz] = gradient(Hz);

innerMag = X.^2 + Z.^2 <= 0.002.^2; 
Habs(innerMag) = NaN;

fig = figure('units','normalized','outerposition',[0 0 1 1]);
% fig.WindowStyle = 'docked';
set(fig,'DoubleBuffer','on');
set(gcf,'renderer','zbuffer')

% surf(X, Z, atan2(HxDx ./Habs, HxDx ./ Habs))
% surf(X, Z, HxDz ./ Habs)
% surf(X, Z, Habs)
im = imagesc(x, z, mag2db(Habs), 'AlphaData', 0.6);
set(gca, 'YDir', 'normal');
colormap('jet');
cb = colorbar;
ca = caxis;
shading flat
view(2)

hold on
grid on
st = streamslice(X, Z, Hx, Hz, 'noarrows', 'cubic');
% set(st, 'Color', 'k');

idx = 10:10:200-10;
q = quiver(X(idx, idx), Z(idx, idx), Hx(idx, idx), Hz(idx, idx), 0.5, 'k');

rectangle('Position', [-0.002 -0.002 0.004 0.004], 'Curvature', [1 1]);
r = 0.002;
p = pi/2:0.01:3*pi/2;
semicrc = r.*[cos(p); sin(p)];
patch(semicrc(1,:), semicrc(2,:),'r')
patch(-semicrc(1,:), -semicrc(2,:),'g')
xlim(gca, [-0.012 0.012])
ylim(gca, [-0.012 0.012])
axis equal
axis tight







