%% plotTDKCharDataset
% Explore TDK TAS2141 characterization dataset and plot its content.
%
%% Syntax
%   Figures = plotTDKCharDataset(dataset)
%   Figures = plotTDKCharDataset(datset, dock)
%
%
%% Description
% Figures = plotTDKCharDataset(datset) explores the dataset and plot its
% content in three docked figure windows. Dataset input argument is the
% path to the characterization dataset. The function returns a struct which
% includes the handles to created figures axes and plots for each figure
% window.
%
% Figures = plotTDKCharDataset(datset, dock) operates as described above
% but by passing false to dock argument, the figure windows are undocked.
% Default is true, so docking is enabled.
%
%
%% Examples
%   dataset = 'data/TDK_TAS2141_Characterization_2019-07-24.mat';
%   figs = plotTDKCharDataset(dataset);
%
%   figs = plotTDKCharDataset(dataset, false);
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: reconstructMagStimulus, findMinMax
% * MAT-files required: data/TDK_TAS2141_Characterization_2019-07-24.mat
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
% -->
% </html>
%
function [Figures] = plotTDKCharDataset(dataset, dock)
    arguments
        % validate if dataset exists
        dataset (1,:) char {mustBeFile}
        % validate optional dock enable
        dock (1,1) logical {mustBeNumericOrLogical} = true
    end
    
    % load dataset into function workspace
    load(dataset, 'Data', 'Info');
    
    % get dataset infos and format strings to place in figures
    infoStr = join([Info.SensorManufacturer, ...
                    Info.Sensor, ... 
                    Info.SensorTechnology, ...
                    Info.SensorType, ...
                    "Sensor Characterization Dataset"]);
    dateStr = join(["Created on", ...
                    Info.Created, ...
                    "by", ...
                    Info.Creator, ...
                    "and updated on", ...
                    Info.Edited, ...
                    "by", ...
                    Info.Editor]);
    
    % reconstruct magnetic Hx and Hy field stimulus with helper function
    [phi, hxStim, hyStim, modAmp, nPeriods, nSamples, reduced, fMod, fCar, ... 
        hMax, hMin, hSteps, hRes] = reconstructMagStimulus(Info.MagneticField);
    
    
    
    % figure for magnetic stimulus which sourced the sensor outputs
    f1 = figure('Name', 'Magnetic Stimulus');
    f1.NumberTitle = 'off';
    f1.Units = 'normalized';
    f1.OuterPosition = [0, 0.5, 1, 0.5];
    
    % create tile layout to show stimulus of Hx and Hy field
    t1 = tiledlayout(2, 2);
    t1.Padding = 'compact';
    t1.TileSpacing = 'compact';
    t1.Title.String = "Reconstructed Hx- and Hy-Field Stimulus in Reduced View";
    t1.Subtitle.String = [infoStr; dateStr];
    t1.Subtitle.FontSize = 8;
    ylabel(t1, "Amplitude in " + Info.Units.MagneticFieldStrength);
    
    % plot stimulus and modulation for Hx
    ax1 = nexttile;
    p1 = plot(phi, modAmp, 'k');
    hold on;
    p2 = plot(phi, -modAmp, 'k');
    p3 = plot(phi(1:nSamples/2), hxStim(1:nSamples/2), 'b');
    p4 = plot(phi(nSamples/2:end), hxStim(nSamples/2:end), 'r');
    ylabel('Hx')
    xticks([0 0.25*pi 0.5*pi 0.75*pi pi 1.25*pi 1.5*pi 1.75*pi 2*pi] * nPeriods);
    xticklabels({'0', '8\pi', '16\pi', '24\pi', '32\pi', '40\pi', '48\pi', '56\pi', '64\pi'});
    xlabel('160 periods reduced by 10 for better view');
    title('Triangle Modulation 0.01Hz with Cosinus Carrier 3.2Hz')
    legend([p3, p4], 'Rise', 'Fall')
    hold off;
    
    % plot stimulus and modulation for Hy
    ax2 = nexttile;
    p5 = plot(phi, modAmp, 'k');
    hold on;
    p6 = plot(phi, -modAmp, 'k');
    p7 = plot(phi(1:nSamples/2), hyStim(1:nSamples/2), 'b');
    p8 = plot(phi(nSamples/2:end), hyStim(nSamples/2:end), 'r');
    ylabel('Hy')
    xticks([0 0.25*pi 0.5*pi 0.75*pi pi 1.25*pi 1.5*pi 1.75*pi 2*pi] * nPeriods);
    xticklabels({'0', '8\pi', '16\pi', '24\pi', '32\pi', '40\pi', '48\pi', '56\pi', '64\pi'});
    xlabel('320 periods reduced by 10 for better view');
    title('Triangle Modulation 0.01Hz with Sinus Carrier 3.2Hz')
    legend([p7, p8], 'Rise', 'Fall')
    hold off;
    
    % link axes of stimulus to manipulate both at a time
    linkaxes([ax1, ax2], 'xy');
    ax1.XLim = [0 phi(end)];
    
    % polar plot of rising stimulus elements amplitude and angle
    ax3 = nexttile;
    p9 = polarplot(phi(1:nSamples/2), modAmp(1:nSamples/2), 'b');
    title('Polar View of Rise for Cosinus and Sinus')
    subtitle('Radius runs from center outwards')
    
    % polar plot of falling stimulus elements amplitude and angle
    ax4 = nexttile;
    p10 = polarplot(phi(nSamples/2:end), modAmp(nSamples/2:end), 'r');
    title('Polar View of Fall for Cosinus and Sinus')
    subtitle('Radius runs from outwards to center')
    
    % figure for CosinusBridge outputs
    f2 = figure('Name', 'Cosinus Bridge Output');
    f2.NumberTitle = 'off';
    f2.Units = 'normalized';
    f2.OuterPosition = [0, 0, 0.5, 0.5];
    
    % create tile layout to show outputs or rising, falling, all, and
    % differential field strenght outputs.
    t2 = tiledlayout(2, 2);
    t2.Padding = 'normal';
    t2.TileSpacing = 'normal';
    t2.Title.String = "Sensor Cosinus Bridge Outpus Gathered from Corresponding Hx- and Hy-Field Amplitudes";
    t2.Subtitle.String = [infoStr; dateStr];
    t2.Subtitle.FontSize = 8;
    ylabel(t2, "Hy in " + Info.Units.MagneticFieldStrength);
    xlabel(t2, "Hx in " + Info.Units.MagneticFieldStrength);
    
    % find absolute min max
    [minOut, maxOut] = findMinMax(Data.SensorOutput.CosinusBridge);
    
    % plot outputs from cosinus bridge recorded during rising stimulus 
    ax5 = nexttile;
    p11 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Rise);
    set(p11, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Rise));
    caxis([minOut, maxOut]);
    
    title('Rising Stimulus Hx-/ Hy-Amplitudes')
    
    % % plot outputs from cosinus bridge recorded during falling stimulus 
    ax6 = nexttile;
    p12 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Fall);
    set(p12, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Fall));
    caxis([minOut, maxOut]);
    title('Falling Stimulus Hx-/ Hy-Amplitudes')
    
    % plot superimpose rising and falling stimulus output
    ax7 = nexttile;
    p13 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.All);
    set(p13, 'AlphaData', ~(~Data.SensorOutput.CosinusBridge.All));
    caxis([minOut, maxOut]);
    title('Superimposed Stimulus Hx-/ Hy-Amplitudes')
    
    % plot difference btween rising and falling stimulus ouputs
    ax8 = nexttile;
    p14 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Diff);
    set(p14, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Diff));
    caxis([minOut, maxOut]);
    title('Differentiated Stimulus Hx-/ Hy-Amplitudes')
    
    % add colorbar and place it overall plots
    cb1 = colorbar;
    cb1.Layout.Tile = 'east';
    cb1.Label.String = 'Cosinus Bridge Output Vcos(Hx, Hy) in mV';
    
    % link axes for simultaniously zoom
    linkaxes([ax5, ax6, ax7, ax8], 'xy');
    
    
    % figure for SinusBridge outputs
    f3 = figure('Name', 'Sinus Bridge Output');
    f3.NumberTitle = 'off';
    f3.Units = 'normalized';
    f3.OuterPosition = [0.5, 0, 0.5, 0.5];
    
    % create tile layout to show outputs or rising, falling, all, and
    % differential field strenght outputs.
    t3 = tiledlayout(2, 2);
    t3.Padding = 'normal';
    t3.TileSpacing = 'normal';
    t3.Title.String = "Sensor Sinus Bridge Outpus Gathered from Corresponding Hx- and Hy-Field Amplitudes";
    t3.Subtitle.String = [infoStr; dateStr];
    t3.Subtitle.FontSize = 8;
    ylabel(t3, "Hy in " + Info.Units.MagneticFieldStrength);
    xlabel(t3, "Hx in " + Info.Units.MagneticFieldStrength);
    
    % find absolute min max
    [minOut, maxOut] = findMinMax(Data.SensorOutput.SinusBridge);
    
    % plot outputs from sinus bridge recorded during rising stimulus 
    ax9 = nexttile;
    p15 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Rise);
    set(p15, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Rise));
    caxis([minOut, maxOut]);
    title('Rising Stimulus Hx-/ Hy-Amplitudes')
    
    % % plot outputs from sinus bridge recorded during falling stimulus 
    ax10 = nexttile;
    p16 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Fall);
    set(p16, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Fall));
    caxis([minOut, maxOut]);
    title('Falling Stimulus Hx-/ Hy-Amplitudes')
    
    % plot superimpose rising and falling stimulus output
    ax11 = nexttile;
    p17 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.All);
    set(p17, 'AlphaData', ~(~Data.SensorOutput.SinusBridge.All));
    caxis([minOut, maxOut]);
    title('Superimposed Stimulus Hx-/ Hy-Amplitudes')
    
    % plot difference btween rising and falling stimulus ouputs
    ax12 = nexttile;
    p18 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.SinusBridge.Diff);
    set(p18, 'AlphaData', ~isnan(Data.SensorOutput.SinusBridge.Diff));
    caxis([minOut, maxOut]);
    title('Differentiated Stimulus Hx-/ Hy-Amplitudes')
    
    % add colorbar and place it overall plots
    cb2 = colorbar;
    cb2.Layout.Tile = 'east';
    cb2.Label.String = 'Sinus Bridge Output Vsin(Hx, Hy) in mV';
    
    % link axes for simultaniously zoom
    linkaxes([ax9, ax10, ax11, ax12], 'xy');
    
    % dock figures side by side if enabled, default true
    if dock
        handles = [f1, f2, f3];
        set(handles, 'WindowStyle', 'dock');
    end
    
    % store created figures and plots into struct and return for furhter
    % manipulation or to save components for documentation
    Figures = struct;
    % magnetic stimulus plots
    Figures.MagFig = struct;
    Figures.MagFig.h = f1;
    Figures.MagFig.t = t1;
    Figures.MagFig.ax = [ax1, ax2, ax3, ax4];
    Figures.MagFig.p = [p1, p2, p3, p4, p5, p6, p7, p8, p9 p10];
    % Cosinus Brdige plots
    Figures.CosFig = struct;
    Figures.CosFig.h = f2;
    Figures.CosFig.t = t2;
    Figures.CosFig.ax = [ax5, ax6, ax7, ax8];
    Figures.CosFig.p = [p11, p12, p13, p14];
    Figures.CosFig.c = cb1;
    % Sinus Brdige plots
    Figures.SinFig = struct;
    Figures.SinFig.h = f3;
    Figures.SinFig.t = t3;
    Figures.SinFig.ax = [ax9, ax10, ax11, ax12];
    Figures.SinFig.p = [p15, p16, p17, p18];
    Figures.SinFig.c = cb2;
end


% helper function to reconstruct magnetic field stimulus for Hx and Hy field
function [phi, hxStim, hyStim, modAmp, nPeriods, nSamples, reduced, fMod, ...
    fCar, hMax, hMin, hSteps, hRes] = reconstructMagStimulus(H)
    % get magnetic Hx or Hy field stimulus information
    % modulation function, standard is triang
    if ~strcmp("triang", H.Modulation)
        error("Modulation function is not triang.");
    end
    % modulation frequency
    fMod = H.ModulationFrequency;
    % carrier function standard is cos for Hx and sin for Hy
    if ~(strcmp("cos", H.CarrierHx) && strcmp("sin", H.CarrierHy))
        error("Carrier functions are not cos or sin.")
    end
    % carrier frequency
    fCar = H.CarrierFrequency;
    % max and min amplitude
    hMax = H.MaxAmplitude;
    hMin = H.MinAmplitude;
    % step range or window size for output picking
    hSteps = H.Steps;
    hRes = H.Resolution;
    
    % reconstruct stimulus
    % number of periods reduced by factor 10
    reduced = 10;
    nPeriods = fCar / fMod / reduced;
    % number of samples for good looking 20 times nPeriods
    nSamples = nPeriods * 40;
    % generate angle base
    phi = linspace(0, nPeriods * 2 * pi, nSamples);
    % calculate modulated amplitude, triang returns a column vector, transpose
    modAmp = hMax * triang(nSamples)';
    % calculate Hx and Hy stimulus
    hxStim = modAmp .* cos(phi);
    hyStim = modAmp .* sin(phi);
end


% helper function to find absolute min and max values of all outputs
function [minOut, maxOut] = findMinMax(Bridge)
    % concatenate all layers in third dim
    Array = cat(3, Bridge.Rise, Bridge.Fall, Bridge.All, Bridge.Diff);
    % get min value overall
    minOut = min(Array, [], 'all');
    % get max value over all
    maxOut = max(Array, [], 'all');
end