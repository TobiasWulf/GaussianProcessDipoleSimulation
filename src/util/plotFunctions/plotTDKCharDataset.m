%% plotTDKCharDataset
% Explore TDK TAS2141 characterization dataset and plot its content.
%
%% Syntax
%   Figures = plotTDKCharDataset()
%
%
%% Description
% Figures = plotTDKCharDataset() explores the dataset and plot its
% content in three docked figure windows. Loads dataset location from
% config.mat.
%
%
%% Examples
%   figs = plotTDKCharDataset();
%
%
%% Input Arguments
% *None*
%
%
%% Output Arguments
% *Figure* struct which contains the created figure handles.
%
%
%% Requirements
% * Other m-files: none
% * Subfunctions: none
% * MAT-files required: data/TDK_TAS2141_Characterization_2019-07-24.mat,
%   data/config.mat
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/plot.html')) plot>
% * <matlab:web(fullfile(docroot,'matlab/ref/imagesc.html')) imagesc>
% * <matlab:web(fullfile(docroot,'matlab/ref/polarplot.html')) polarplot>
%
%
% Created on Month 24. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on October 26. 2020 by Tobias Wulf: Finish plots, docstring, adjust phi.
% Edited on November 09. 2020 by Tobias Wulf: Load PathVariables as struct.
% -->
% </html>
%
function [Figures] = plotTDKCharDataset()
    try
        % load dataset path and dataset content into function workspace
        load('config.mat', 'PathVariables');
        load(PathVariables.tdkDatasetPath, 'Data', 'Info');
    catch ME
        rethrow(ME)
    end
    
    % load needed data from dataset in to local variables for better handling
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % check if modulation fits to following reconstructioning
    if ~strcmp("triang", Info.MagneticField.Modulation)
        error("Modulation function is not triang.");
    end
    if ~(strcmp("cos", Info.MagneticField.CarrierHx) && ...
            strcmp("sin", Info.MagneticField.CarrierHy))
        error("Carrier functions are not cos or sin.")
    end
    
    % modulation frequency
    fm = Info.MagneticField.ModulationFrequency;
    % carrier frequency
    fc = Info.MagneticField.CarrierFrequency;
    % max and min amplitude
    Hmax = Info.MagneticField.MaxAmplitude;
    Hmin = Info.MagneticField.MinAmplitude;
    % step range or window size for output picking
    Hsteps = Info.MagneticField.Steps;
    % resoulution of H steps
    Hres = Info.MagneticField.Resolution;
    % get unit strings from
    kApm = Info.Units.MagneticFieldStrength;
    Hz = Info.Units.Frequency;
    mV = Info.Units.SensorOutputVoltage;
    
    % get dataset infos and format strings to place in figures
    % subtitle string for all figures
    infoStr = join([Info.SensorManufacturer, Info.Sensor, Info.SensorTechnology, ...
        Info.SensorType, "Sensor Characterization Dataset"]);
    dateStr = join(["Created on", Info.Created, "by", Info.Creator, ...
        "and updated on", Info.Edited, "by", Info.Editor]);
    
    % load characterization data
    Vcos = Data.SensorOutput.CosinusBridge;
    Vsin = Data.SensorOutput.SinusBridge;
    
    % clear dataset all loaded
    clear Data Info;
    % reconstruct magnetic stimulus and reduce the view for example plot by 10
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % number of periods reduced by factor 10
    reduced = 10;
    nPeriods = fc / fm / reduced;
    % number of samples for good looking 40 times nPeriods
    nSamples = nPeriods * 40;
    % half number of samples
    nHalf = round(nSamples / 2);
    % generate angle base
    phi = linspace(0, nPeriods * 2 * pi, nSamples);
    % calculate modulated amplitude, triang returns a column vector, transpose
    Hmag = Hmax * triang(nSamples)';
    % calculate Hx and Hy stimulus
    Hx = Hmag .* cos(phi);
    Hy = Hmag .* sin(phi);
    % index for rising and falling stimulus
    idxR = 1:nHalf;
    idxF = nHalf:nSamples;
    % find absolute min and max values in bridge outputs for uniform colormap
    A = cat(3, Vcos.Rise, Vcos.Fall, Vcos.All, Vcos.Diff, Vsin.Rise, ... 
        Vsin.Fall, Vsin.All, Vsin.Diff);
    Vmax = max(A, [], 'all');
    Vmin = min(A, [], 'all');
    clear A;
    
    
    
    
    % titles and labels of first figure (stimulus)
    name10 = 'Magnetic Stimulus';
    title10 = 'Reconstructed Hx- and Hy-Field Stimulus in Reduced View';
    ylabel10 = sprintf('H amplitude in %s', kApm);
    xlabel10 = sprintf('%d periods, reduced factor %d', nPeriods, reduced);
    xticks11 = [0 0.25*pi 0.5*pi 0.75*pi pi 1.25*pi 1.5*pi 1.75*pi 2*pi] * nPeriods;
    xticklabels11 = {'0', '8\pi', '16\pi', '24\pi', '32\pi', '40\pi', '48\pi', '56\pi', '64\pi'};
    title11 = sprintf('Modulation %1.2f %s - Cosinus Carrier %1.2f %s', fMod, Hz, fCar, Hz);
    title12 = sprintf('Modulation %1.2f %s - Sinus Carrier %1.2f %s', fMod, Hz, fCar, Hz);
    title13 = 'Polar View of Rise for Cosinus and Sinus';
    subtitle13 = 'Radius runs from center outwards';
    title14 = 'Polar View of Fall for Cosinus and Sinus';
    subtitle14 = 'Radius runs from outwards to center';
    
    % figure 1 for magnetic stimulus which sourced the sensor outputs
    [f1, t1] = newConfigFigure(name10, title10, subtitle00, 2, 2);
    xlabel(t1, xlabel10, 'FontSize', FigureLabelOptions.LabelSize);
    ylabel(t1, ylabel10, 'FontSize', FigureLabelOptions.LabelSize);
    
    % make axes in layout and plot to axes
    % hx stimulus
    ax1 = nexttile;
    p1 = plot(phi, modAmp, phi, -modAmp, phi(1:nHalf), hxStim(1:nHalf), ...
        phi(nHalf:end), hxStim(nHalf:end));
    set(p1, {'Color'}, {'k', 'k', 'b', 'r'}');
    xticks(xticks11);
    xticklabels(xticklabels11);
    legend([p1(1), p1(3), p1(4)], 'Mod', 'Rise', 'Fall');
    title(title11, 'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight)
    
    % hy stimulus
    ax2 = nexttile;
    p2 = plot(phi, modAmp, phi, -modAmp, phi(1:nHalf), hyStim(1:nHalf), ...
        phi(nHalf:end), hyStim(nHalf:end));
    set(p2, {'Color'}, {'k', 'k', 'b', 'r'}');
    xticks(xticks11);
    xticklabels(xticklabels11);
    legend([p2(1), p2(3), p2(4)], 'Mod', 'Rise', 'Fall');
    title(title12, 'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight)
    
    % link axes of modulation plots and adjust
    linkaxes([ax1, ax2], 'xy');
    ax1.XLim = [0 phi(end)];
    
    % polar for rising modulation
    ax3 = nexttile;
    p3 = polarplot(phi(1:nHalf), modAmp(1:nHalf), 'b');
    subtitle(subtitle13);
    title(title13, 'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);
    
    % polar for falling modulation
    ax4 = nexttile;
    p4 = polarplot(phi(nHalf:end), modAmp(nHalf:end), 'r');
    subtitle(subtitle14);
    title(title14, 'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);
    
    % titles and labels of second figure (cosinus bridge output images)
    name20 = 'Cosinus Bridge';
    title20 = 'Gathered Cosinus Bridge Outputs for Corresponding Hx-/ Hy-Amplitudes';
    xlabel20 = sprintf('Hx in %s, %d px in %1.4f %s steps', kApm, hSteps, hRes, kApm);
    ylabel20 = sprintf('Hy in %s, %d px in %1.4f %s steps', kApm, hSteps, hRes, kApm);
    title21 = 'Rising Hx-/ Hy-Amplitudes';
    title22 = 'Falling Hx-/ Hy-Amplitudes';
    title23 = 'Superimposed Hx-/ Hy-Amplitudes';
    title24 = 'Differentiated Hx-/ Hy-Amplitudes';
    cblabel20 = sprintf('Cosinus Bridge Output Vcos(Hx, Hy) in %s', mV);
    
    % save figure 1 as figure, svg, pdf, and eps with tiff view
    f1Filename = 'tdk_magnetic_stimulus';
    savefig(f1, fullfile(PathVariables.saveFiguresPath, f1Filename))
    print(f1, fullfile(PathVariables.saveImagesPath, f1Filename), '-dsvg')
    print(f1, fullfile(PathVariables.saveImagesPath, f1Filename), '-depsc', '-tiff')
    print(f1, fullfile(PathVariables.saveImagesPath, f1Filename), '-dpdf', '-bestfit')
    
    % figure 2 cosinus bridge outputs
    [f2, t2] = newConfigFigure(name20, title20, subtitle00, 2, 2);
    xlabel(t2, xlabel20);
    ylabel(t2, ylabel20);
    
    % make axes in layout and plot to axes  
    % cosinus bridge recorded during rising stimulus 
    ax5 = nexttile;
    p5 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Rise);
    set(gca, 'YDir', 'normal');
    set(p5, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Rise));
    caxis([cosMin, cosMax]);
    title(title21,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % cosinus bridge recorded during falling stimulus 
    ax6 = nexttile;
    p6 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Fall);
    set(gca, 'YDir', 'normal');
    set(p6, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Fall));
    caxis([cosMin, cosMax]);
    title(title22, 'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % superimposed rising and falling
    ax7 = nexttile;
    p7 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.All);
    set(gca, 'YDir', 'normal');
    set(p7, 'AlphaData', ~(~Data.SensorOutput.CosinusBridge.All));
    caxis([cosMin, cosMax]);
    title(title23,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % differentiated rising and falling
    ax8 = nexttile;
    p8 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Diff);
    set(gca, 'YDir', 'normal');
    set(p8, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Diff));
    caxis([cosMin, cosMax]);
    title(title24,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % add colorbar and place it overall plots
    cb2 = colorbar;
    cb2.Layout.Tile = 'east';
    cb2.Label.String = cblabel20;
    cb2.Label.FontSize = FigureLabelOptions.LabelSize;

    % link axes for simultaniously zoom
    linkaxes([ax5, ax6, ax7, ax8], 'xy');
    
    % save figure 2 as figure, svg, pdf, and eps with tiff view
    f2Filename = 'tdk_cosinus_bridge';
    savefig(f2, fullfile(PathVariables.saveFiguresPath, f2Filename))
    print(f2, fullfile(PathVariables.saveImagesPath, f2Filename), '-dsvg')
    print(f2, fullfile(PathVariables.saveImagesPath, f2Filename), '-depsc', '-tiff')
    print(f2, fullfile(PathVariables.saveImagesPath, f2Filename), '-dpdf', '-bestfit')
    
    % titles and labels of third figure (sinus bridge output images)
    name30 = 'Sinus Bridge';
    title30 = 'Gathered Sinus Bridge Outputs for Corresponding Hx-/ Hy-Amplitudes';
    cblabel30 = sprintf('Sinus Bridge Output Vsin(Hx, Hy) in %s', mV);
    
    % figure 2 cosinus bridge outputs
    [f3, t3] = newConfigFigure(name30, title30, subtitle00, 2, 2);
    xlabel(t3, xlabel20);
    ylabel(t3, ylabel20);
    
    % make axes in layout and plot to axes  
    % sinus bridge recorded during rising stimulus 
    ax9 = nexttile;
    p9 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Rise);
    set(gca, 'YDir', 'normal');
    set(p9, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Rise));
    caxis([sinMin, sinMax]);
    title(title21,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % cosinus bridge recorded during falling stimulus 
    ax10 = nexttile;
    p10 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Fall);
    set(gca, 'YDir', 'normal');
    set(p10, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Fall));
    caxis([sinMin, sinMax]);
    title(title22,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % superimposed rising and falling
    ax11 = nexttile;
    p11 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.All);
    set(gca, 'YDir', 'normal');
    set(p11, 'AlphaData', ~(~Data.SensorOutput.SinusBridge.All));
    caxis([sinMin, sinMax]);
    title(title23,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % differentiated rising and falling
    ax12 = nexttile;
    p12 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Diff);
    set(gca, 'YDir', 'normal');
    set(p12, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Diff));
    caxis([sinMin, sinMax]);
    title(title24,'FontSize', FigureLabelOptions.AxesTitleSize, ...
        'FontWeight', FigureLabelOptions.AxesTitleWeight);

    % add colorbar and place it overall plots
    cb3 = colorbar;
    cb3.Layout.Tile = 'east';
    cb3.Label.String = cblabel30;
    cb3.Label.FontSize = FigureLabelOptions.LabelSize;

    % link axes for simultaniously zoom
    linkaxes([ax9, ax10, ax11, ax12], 'xy');
    
    % save figure 3 as figure, svg, pdf, and eps with tiff view
    f3Filename = 'tdk_sinus_bridge';
    savefig(f3, fullfile(PathVariables.saveFiguresPath, f3Filename))
    print(f3, fullfile(PathVariables.saveImagesPath, f3Filename), '-dsvg')
    print(f3, fullfile(PathVariables.saveImagesPath, f3Filename), '-depsc', '-tiff')
    print(f3, fullfile(PathVariables.saveImagesPath, f3Filename), '-dpdf', '-bestfit')
    
    % store created figures and plots into struct and return for furhter
    % manipulation or to save components for documentation
    Figures = struct('f1', f1, 'f2', f2, 'f3', f3);
end
