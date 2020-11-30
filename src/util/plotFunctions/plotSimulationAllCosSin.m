%% plotSimulationAllCosSin
% Search for available trainings or test dataset and plot dataset. Follow user
% input dialog to choose which dataset to plot and statistics of cos sin.
% Save created plot to file. Filename same as dataset with attached info.
%
%% Syntax
%   plotSimulationAllCosSin()
%
%
%% Description
% *fig = plotSimulationAllCosSin()* plot training or test dataset which are
% loacated in data/test or data/training. The function list all datasets and the
% user must decide during user input dialog which dataset to plot.
% It loads path from config.mat and scans for file
% automatically. Returns figure handle of created plots.
%
%
%% Examples
%   plotSimulationAllCosSin()
%
%
%% Input Argurments
% *None*
%
%
%% Output Argurments
% *None*
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: config.mat
%
%
%% See Also
% * <generateSimulationDatasets.html generateSimulationDatasets>
% * <sensorArraySimulation.html sensorArraySimulation>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on November 30. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function plotSimulationAllCosSin()
    % scan for datasets and load needed configurations %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        disp('Plot simulation dataset ...');
        close all;
        % load path variables
        load('config.mat', 'PathVariables');
        % scan for datasets
        TrainingDatasets = dir(fullfile(PathVariables.trainingDataPath, ...
            'Training_*.mat'));
        TestDatasets = dir(fullfile(PathVariables.testDataPath, 'Test_*.mat'));
        allDatasets = [TrainingDatasets; TestDatasets];
        % check if files available
        if isempty(allDatasets)
            error('No training or test datasets found.');
        end
    catch ME
        rethrow(ME)
    end
    
    % display availabe datasets to user, decide which to plot %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % number of datasets
    nDatasets = length(allDatasets);
    fprintf('Found %d datasets:\n', nDatasets)
    for i = 1:nDatasets
        fprintf('%s\t:\t(%d)\n', allDatasets(i).name, i)
    end
    % get numeric user input to indicate which dataset to plot
    iDataset = 1;%input('Type number to choose dataset to plot to: ');
        
    % load dataset and ask user which one and how many angles %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    try
        ds = load(fullfile(allDatasets(iDataset).folder, ...
            allDatasets(iDataset).name));
    catch ME
        rethrow(ME)
    end
    
    % create dataset figure for a subset or all angle %%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig = figure('Name', 'Sensor Array', ...
        'NumberTitle' , 'off', ...
        'WindowStyle', 'normal', ...
        'MenuBar', 'none', ...
        'ToolBar', 'none', ...
        'Units', 'centimeters', ...
        'OuterPosition', [0 0 37 29], ...
        'PaperType', 'a4', ...
        'PaperUnits', 'centimeters', ...
        'PaperOrientation', 'landscape', ...
        'PaperPositionMode', 'auto', ...
        'DoubleBuffer', 'on', ...
        'RendererMode', 'manual', ...
        'Renderer', 'painters');
    
    tdl = tiledlayout(fig, 2, 1, ...
        'Padding', 'normal', ...
        'TileSpacing' , 'normal');
    
    
    title(tdl, 'Sensor Array Simulation', ...
        'FontWeight', 'normal', ...
        'FontSize', 18, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
%     subline1 = "Sensor Array (%s) of $%d\\times%d$ sensors, an edge length of $%.1f$ mm, a rel. pos. to magnet surface of";
%     subline2 = " $(%.1f, %.1f, -(%.1f))$ in mm, a magnet tilt of $%.1f^\\circ$, a sphere radius of $%.1f$ mm, a imprinted";
%     subline3 = "field strength of $%.1f$ kA/m at $%.1f$ mm from sphere surface in z-axis, $%d$ rotation angles with a ";
%     subline4 = "step width of $%.1f^\\circ$ and a resolution of $%.1f^\\circ$. Visualized is a subset of $%d$ angles in ";
%     subline5 = "sample distance of $%d$ angles. Based on %s characterization reference %s.";
%     sub = [sprintf(subline1, ...
%                    ds.Info.SensorArrayOptions.geometry, ...
%                    ds.Info.SensorArrayOptions.dimension, ...
%                    ds.Info.SensorArrayOptions.dimension, ...
%                    ds.Info.SensorArrayOptions.edge); ...
%            sprintf(subline2, ...
%                    ds.Info.UseOptions.xPos, ...
%                    ds.Info.UseOptions.yPos, ...
%                    ds.Info.UseOptions.zPos, ...
%                    ds.Info.UseOptions.tilt, ...
%                    ds.Info.DipoleOptions.sphereRadius); ...
%            sprintf(subline3, ...
%                    ds.Info.DipoleOptions.H0mag, ...
%                    ds.Info.DipoleOptions.z0, ...
%                    ds.Info.UseOptions.nAngles); ...
%            sprintf(subline4, ...
%                    ds.Data.angleStep, ...
%                    ds.Info.UseOptions.angleRes, ...
%                    nSubAngles)
%            sprintf(subline5, ...
%                    sampleDistance, ...
%                    ds.Info.CharData, ...
%                    ds.Info.UseOptions.BridgeReference)];
%     
%     subtitle(tdl, sub, ...
%         'FontWeight', 'normal', ...
%         'FontSize', 14, ...
%         'FontName', 'Times', ...
%         'Interpreter', 'latex');
    
    % get subset of needed data to plot, only one load %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    M = ds.Info.SensorArrayOptions.dimension^2;
    N = ds.Info.UseOptions.nAngles;
    res = ds.Info.UseOptions.angleRes;
    angles = ds.Data.angles;
    anglesIP = 0:res:360-res;
    
    % load V subset and reshape for easier computing statistics
    Vcos = squeeze(reshape(ds.Data.Vcos, 1, M, N));
    Vsin = squeeze(reshape(ds.Data.Vsin, 1, M, N));
    
    % load offset voltage to subtract from cosinus, sinus voltage
    Voff = ds.Info.SensorArrayOptions.Voff;
    Vcc = ds.Info.SensorArrayOptions.Vcc;
    
    % compute statistics of Vcos Vsin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % interpolate with makima makes best results, ensure to kill nans for
    % fill otherwise fill strokes, use linstyle none for fill without frame
    VcosMean = mean(Vcos, 1);
    VcosMeanIP = interp1(angles, VcosMean, anglesIP, 'makima');
    VcosStd = std(Vcos, 1, 1); 
    VcosVar = var(Vcos, 1, 1); % std^2
    VcosCovF = zeros(1, N);
    for i = 1:N
        VcosCovF(i) = cov(Vcos(:,i), 1);
    end
    VcosUpper = VcosMean + VcosStd;
    VcosUpperIP = interp1(angles, VcosUpper, anglesIP, 'makima');
    VcosLower = VcosMean - VcosStd;
    VcosLowerIP = interp1(angles, VcosLower, anglesIP, 'makima');
    
    % plot Vcos Vsin over angles %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % axes limits
    %xlimits = [-10 370];
    %ylimits = [min(cat(3, ds.Data.VsinRef, ds.Data.VcosRef), [], 'all') - 0.1*Vcc, ...
    %    max(cat(3, ds.Data.VsinRef, ds.Data.VcosRef), [], 'all') + 0.1*Vcc];
    
    % Vcos
    nexttile;
    hold on;
    
    fillX = [anglesIP, fliplr(anglesIP)];
    fillY = [VcosLowerIP, fliplr(VcosUpperIP)];
    fill(fillX, fillY, [0.9 0.9 0.9], 'LineStyle', 'none');
    yline(Voff, 'k--');
    scatter(angles, VcosUpper, [], 'r*');
    plot(anglesIP, VcosUpperIP, 'r-.');
    scatter(angles, VcosMean, [], 'm*');
    plot(anglesIP, VcosMeanIP, 'm-.');
    scatter(angles, VcosLower, [], 'b*');
    plot(anglesIP, VcosLowerIP, 'b-.');
    
    
    hold off;
    xlim([-0.1 360]);
    %ylim(ylimits);
    grid on;
    
    text(300, 1.1, ...
        sprintf('$V_{cc} = %.1f$ V, $V_{off} = %.2f$ V', Vcc, Voff), ...
        'Color', 'k', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');    
    
    xlabel('$\theta$ in Degree', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    ylabel('$V{cos}(\theta)$ in V', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    title('$V{cos}$ of Enabled Array Positions over $\theta$', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    % Vsin
    nexttile;
    hold on;
    
    yline(Voff, 'k--');


    hold off;
    %xlim(xlimits);
    %ylim(ylimits);
    grid on;
    
    text(300, 2.1, ...
        sprintf('$V_{cc} = %.1f$ V, $V_{off} = %.2f$ V', Vcc, Voff), ...
        'Color', 'k', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');    
    
    xlabel('$\theta$ in Degree', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    ylabel('$V{sin}(\theta)$ in V', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    title('$V{sin}$ of Enabled Array Positions over $\theta$', ...
        'FontWeight', 'normal', ...
        'FontSize', 12, ...
        'FontName', 'Times', ...
        'Interpreter', 'latex');
    
    
    % save figure to file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % get file path to save figure with angle index
%     [~, fName, ~] = fileparts(ds.Info.filePath);
%     
%     % save to various formats
%     yesno = input('Save? [y/n]: ', 's');
%     if strcmp(yesno, 'y')
%         fLabel = input('Enter file label: ', 's');
%         fPath1 = fullfile(PathVariables.saveFiguresPath, ...
%             fName + "_subset_" + fLabel);
%         fPath2 = fullfile(PathVariables.saveImagesPath, ...
%             fName + "_subset_" + fLabel);
%         savefig(fig, fPath1);
%         print(fig, fPath2, '-dsvg');
%         print(fig, fPath2, '-depsc', '-tiff', '-loose');
%         print(fig, fPath2, '-dpdf', '-loose', '-fillpage');
%     end
%     close(fig);
end

