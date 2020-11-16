clear all
close all

x = linspace(-15, 15, 501);
y = -2;
z = linspace(15, -15, 501);
[X, Z, Y] = meshgrid(x, z, 0);


m = rotate3DVector([-1e6; 0; 0], 0, 0, 0);

Hnorm = computeDipoleH0Norm(200, -1e6, 1, 2);

H = computeDipoleHField(X, Y, Z, m, Hnorm);

Habs = reshape(sqrt(sum(H.^2, 1)), 501, 501);

Hx = reshape(H(1,:), 501, 501) ./ Habs;
Hy = reshape(H(2,:), 501, 501) ./ Habs;
Hz = reshape(H(3,:), 501, 501) ./ Habs;

[HxDx, HxDz] = gradient(Hx);
[HzDx, HzDz] = gradient(Hz);

innerMag = X.^2 + Z.^2 <= 2.^2; 
Habs(innerMag) = NaN;

fig = newConfigFigure('Dipole Magnet', ...
    'Approximated Spherical Magnet (Dipole Far Field)', ...
    'Sphere radius r = 2mm, imprinted H-field strength magnitude of 200kA/m in 1mm distance from surface.'); 

% fig.WindowStyle = 'docked';
set(fig,'DoubleBuffer','on');
set(gcf,'renderer','zbuffer')


%im = imagesc(x, z, mag2db(Habs), 'AlphaData', 1);
im = imagesc(x, z, log10(Habs), 'AlphaData', 1);
%im = imagesc(x, z, Habs, 'AlphaData', 1);
set(gca, 'YDir', 'normal');
colormap('jet');
cb = colorbar;
cb.Label.String = 'log10(|H|) in kA/m';
cb.Label.FontSize = 12;
%caxis([mag2db(0.1961) mag2db(200)]);
%caxis([0.1961 25]);

shading flat
view(2)

hold on
grid on
st = streamslice(X, Z, Hx, Hz, 'noarrows', 'cubic');
set(st, 'Color', 'k');

idx = 25:25:501-25;
q = quiver(X(idx, idx), Z(idx, idx), Hx(idx, idx), Hz(idx, idx), 0.5, 'k');

rectangle('Position', [-2 -2 4 4], 'Curvature', [1 1]);
r = 2;
p = pi/2:0.01:3*pi/2;
semicrc = r.*[cos(p); sin(p)];
patch(semicrc(1,:), semicrc(2,:),'r')
patch(-semicrc(1,:), -semicrc(2,:),'g')
text(-1, 0, 'N', 'FontSize', 18)
text(0.5, 0, 'S', 'FontSize', 18)
xlim(gca, [-15 15])
ylim(gca, [-15 15])
xticks(-15:1:15)
xtlabels = string(xticks);
xtlabels(1:2:end) = "";
xticklabels(xtlabels)
xlabel('X in mm')
yticks(-15:1:15)
ytlabels = string(yticks);
ytlabels(1:2:end) = "";
yticklabels(ytlabels)
ylabel('Z in mm')
text(-14, -14, 'Y = 0mm', 'Color', 'w', 'FontSize', 18)
axis equal
axis tight








