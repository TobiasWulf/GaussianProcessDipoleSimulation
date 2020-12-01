%% plotDipoleMagnet
% Plot dipole magnet which approximate a spherical magnet in its far field.
%
%% Syntax
%   plotDipoleMagnet()
%
%
%% Description
% plotDipoleMagnet() load dipole constants from config.mat and construct
% magnet in its rest position in x and z layer for y = 0.
%
%
%% Examples
%   plotDipoleMagnet();
%
%
%% Input Arguments
% *None*
%
%
%% Output Arguments
% *None*
%
%
%% Requirements
% * Other m-files: generateDipoleRotationMoments.m, computeDipoleH0Norm.m,
%   computeDipoleHField
% * Subfunctions: none
% * MAT-files required: data/config.mat
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/quiver.html')) quiver>
% * <matlab:web(fullfile(docroot,'matlab/ref/imagesc.html')) imagesc>
% * <matlab:web(fullfile(docroot,'matlab/ref/streamslice.html')) streamslice>
%
%
% Created on November 20. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function plotDipoleMagnet()
    try
        % load dataset path and dataset content into function workspace
        load('config.mat', 'PathVariables', 'DipoleOptions');
        close all;
    catch ME
        rethrow(ME)
    end
    
    % figure save path for different formats
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figFilename = 'dipole_magnet';
    figPath = fullfile(PathVariables.saveFiguresPath, figFilename);
    figSvgPath = fullfile(PathVariables.saveImagesPath, 'svg', figFilename);
    figEpsPath = fullfile(PathVariables.saveImagesPath, 'eps', figFilename);
    figPdfPath = fullfile(PathVariables.saveImagesPath, 'pdf', figFilename);
    
    % load needed data from dataset in to local variables for better handling
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Radius in mm of magnetic sphere in which the magnetic dipole is centered.
    % So it can be seen as z-offset to the sensor array.
    rsp = DipoleOptions.sphereRadius;

    % H-field magnitude to multiply of generated and relative normed dipole
    Hmag = DipoleOptions.H0mag;

    % Distance in zero position of the spherical magnet in which is imprinted
    z0 = DipoleOptions.z0;

    % Magnetic moment magnitude attach rotation to the dipole field
    m0 = DipoleOptions.M0mag;
    
    % clear dataset all loaded
    clear DipoleOptions;
    
    % set construction dipole magnet, all length in mm and areas mm^2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % number of samples for good looking
    nSamples = 501;
    % slice in view for quiver, every 25th point
    slice = 25:25:nSamples-25;
    % grid edge of meshgrid, square grid
    xz = 15;
    % y layer in coordinate system
    y = 0;
    % orientat of magnet along z axes
    pz = pi/2:0.01:3*pi/2;
    % distances magnet surface to display in plot
    zd = -rsp:-z0:-xz;
    xd = zeros(1, length(zd));
    % scale grid to simulate
    x = linspace(-xz, xz, nSamples);
    z = linspace(xz, -xz, nSamples);
    [X, Z, Y] = meshgrid(x, z, y);
    
    % compute dipole and fetch to far field to approximate a sperical magnet
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % generate dipole moment for 0°
    m = generateDipoleRotationMoments(m0, 1);
    % compute H-field norm factor imprieng H magnitude on dipole, rest position
    H0norm = computeDipoleH0Norm(Hmag, m, [0; 0 ;-(z0 + rsp)]);
    % compute dipole H-field for rest position in y = 0 layer
    H = computeDipoleHField(X, Y, Z, m, H0norm);
    % calculate magnitudes for each point in the grid
    Habs = reshape(sqrt(sum(H.^2, 1)), nSamples, nSamples);
    % split H-field in componets and reshape to meshgrid
    Hx = reshape(H(1,:), nSamples, nSamples) ./ Habs;
    Hy = reshape(H(2,:), nSamples, nSamples) ./ Habs;
    Hz = reshape(H(3,:), nSamples, nSamples) ./ Habs;
    % exculde value within the spherical magnet, < rsp
    innerField = X.^2 + Z.^2 <= rsp.^2; 
    Habs(innerField) = NaN;
    % find relevant magnitudes at anounced distances
    Hd = interp2(X, Z, Habs, xd, zd, 'nearest', NaN);

    
    % figure dipole magnet
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig = figure('Name', 'Dipole Magnet', ...
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
    
    % plot magnitude as colormap
    imagesc(x, z, log10(Habs), 'AlphaData', 1);
    set(gca, 'YDir', 'normal');
    colormap('jet');
    shading flat;
    
    % set colorbar to log10 scaling of map
    cb = colorbar;
    cb.Label.String = '$log_{10}(|H|)$ in kA/m';
    cb.Label.Interpreter = 'latex';
    cb.Label.FontSize = 16;
    
    hold on;
    grid on;
    
    % plot field lines
    st = streamslice(X, Z, Hx, Hz, 'noarrows', 'cubic');
    set(st, 'Color', 'k');
    
    % plot field vectors
    quiver(X(slice, slice), Z(slice, slice), Hx(slice, slice), ...
        Hz(slice, slice), 0.5, 'k');
    
    % plot magnet with north and south pole
    rectangle('Position', [-rsp -rsp 2*rsp 2*rsp], 'Curvature', [1 1]);
    semicrc = rsp.*[cos(pz); sin(pz)];
    patch(semicrc(1,:), semicrc(2,:),'r');
    patch(-semicrc(1,:), -semicrc(2,:),'g');
    text(-1.25, 0, 'N', 'FontSize', 18);
    text(0.5, 0, 'S', 'FontSize', 18);
    
    % additional figure text and lines
    text(-(xz-1), -(xz-1), ...
        sprintf('$\\mathbf{Y = %.1f}$ \\textbf{mm}', y), ...
        'Color', 'w', ...
        'FontSize', 16, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    % distance scale in -z direction for x =0, distance from magnet surface
    line(xd, zd, 'Marker', '_', 'LineStyle', '-', 'Color', 'w', 'LineWidth', 2.0);
    
    % place text along marker
    for i = 2:length(zd)-1
        text(0.5, zd(i), ...
            sprintf('\\textbf{$\\mathbf{d = %d}$ mm, $\\mathbf{|H| = %.1f}$ kA/m}', ...
                abs(zd(i))-rsp, Hd(i)), ...
            'Color', 'w', ...
            'FontSize', 14, ...
            'FontName', 'Times', ...
            'Interpreter', 'latex');
    end

    % limits ticks and labels
    xlim([-xz xz]);
    ylim([-xz xz]);

    xticks(-xz:xz);
    yticks(-xz:xz);
    
    labels = string(xticks);
    labels(1:2:end) = "";
    xticklabels(labels)
    yticklabels(labels)
    
    % axis shape set
    axis equal;
    axis tight;
    
    % title and figure labels
    title('Approximated Spherical Magnet with Dipole Far Field', ...
        'FontWeight', 'normal', ...
        'FontSize', 18, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    subtitle([sprintf("Sphere whith imprinted H-field magnitude of $%.1f$ kA/m", Hmag); ...
        sprintf("at distance $d = %.1f$ mm with $d = |z| - r_{sp}$", z0) + ...
        sprintf(" and sphere radius $r_{sp} = %.1f$ mm", rsp)], ...
        'FontWeight', 'normal', ...
        'FontSize', 14, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    xlabel('$X$ in mm', ...
        'FontWeight', 'normal', ...
        'FontSize', 16, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    ylabel('$Z$ in mm', ...
        'FontWeight', 'normal', ...
        'FontSize', 16, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    % save results of figure
    yesno = input('Save? [y/n]: ', 's');
    if strcmp(yesno, 'y')
        savefig(fig, figPath);
        print(fig, figSvgPath, '-dsvg');
        print(fig, figEpsPath, '-depsc', '-tiff', '-loose');
        print(fig, figPdfPath, '-dpdf', '-loose', '-fillpage');
    end
    close(fig)
end
