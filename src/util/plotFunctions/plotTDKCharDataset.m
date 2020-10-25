%% plotTDKCharDataset
% Explore TDK TAS2141 characterization dataset and plot its content.
%
%% Syntax
%   outputArg = functionName(positionalArg)
%   outputArg = functionName(positionalArg, optionalArg)
%
%
%% Description
% outputArg = functionName(positionalArg) detailed use case description.
%
% outputArg = functionName(positionalArg, optionalArg) detailed use case
% description.
%
%
%% Examples
%   Enter example matlab code for each use case.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: data/TDK_TAS2141_Characterization_2019-07-24.mat
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on Month 24. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
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
    
    % create figures to plot the dataset content into
    % and collect their handles in structs for later manipulation or saving
    Figures = struct;
        
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
    xticks([0 0.25*pi 0.5*pi 0.75*pi pi] * nPeriods);
    xticklabels({'0', '8\pi', '16\pi', '24\pi', '32\pi'})
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
    xticks([0 0.25*pi 0.5*pi 0.75*pi pi] * nPeriods);
    xticklabels({'0', '8\pi', '16\pi', '24\pi', '32\pi'})
    xlabel('160 periods reduced by 10 for better view');
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
    t2.Padding = 'compact';
    t2.TileSpacing = 'compact';
    t2.Title.String = "Sensor Cosinus Bridge Outpus Gathered from Corresponding Hx- and Hy-Field Amplitudes";
    t2.Subtitle.String = [infoStr; dateStr];
    t2.Subtitle.FontSize = 8;
    ylabel(t2, "Hy in " + Info.Units.MagneticFieldStrength);
    xlabel(t2, "Hx in " + Info.Units.MagneticFieldStrength);
    
    % find absolute min max
    [minOut, maxOut] = findMinMax(Data.SensorOutput.CosinusBridge);
    
    % fill tile axis with content
    % Work on color bar axis scales and dimension, plot fits 
    ax5 = nexttile;
    p11 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Rise);
    set(p11, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Rise));
    caxis([minOut, maxOut]);
    
    ax6 = nexttile;
    p12 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Fall);
    set(p12, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Fall));
    caxis([minOut, maxOut]);
    
    ax7 = nexttile;
    p13 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.All);
    set(p13, 'AlphaData', ~(~Data.SensorOutput.CosinusBridge.All));
    caxis([minOut, maxOut]);
    
    ax8 = nexttile;
    p14 = imagesc([hMin hMax], [hMin hMax], Data.SensorOutput.CosinusBridge.Diff);
    set(p14, 'AlphaData', ~isnan(Data.SensorOutput.CosinusBridge.Diff));
    caxis([minOut, maxOut]);
       
    cb = colorbar;
    cb.Layout.Tile = 'east';
    cb.Label.String = 'Cosinus Bridge Output in mV';
    
    linkaxes([ax5, ax6, ax7, ax8], 'xy');
    
    
    % figure for SinusBridge outputs
    f3 = figure('Name', 'Sinus Bridge Output');
    f3.NumberTitle = 'off';
    f3.Units = 'normalized';
    f3.OuterPosition = [0.5, 0, 0.5, 0.5];
    
    % create tile layout to show outputs or rising, falling, all, and
    % differential field strenght outputs.
    t3 = tiledlayout(2, 2);
    t3.Padding = 'compact';
    t3.TileSpacing = 'compact';
    
    % fill tile axis with content
    ax9 = nexttile;
    ax10 = nexttile;
    ax11 = nexttile;
    ax12 = nexttile;
    
    % dock figures side by side if enabled, default true
    if dock
        handles = [f1, f2, f3];
        set(handles, 'WindowStyle', 'dock');
    end
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
    nSamples = nPeriods * 20;
    % generate angle base
    phi = linspace(0, nPeriods * pi, nSamples);
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