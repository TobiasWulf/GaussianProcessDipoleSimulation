%% newConfigFigure
% Creates new figure with a tiled layout and loads config from config.mat file.
%
%% Syntax
%   [fig, layout] = newConfigFigure(name, titleStr, subtitleStr)
%   [fig, layout] = newConfigFigure(name, titleStr, subtitleStr, m)
%   [fig, layout] = newConfigFigure(name, titleStr, subtitleStr, m, n)
%
%
%% Description
% *[fig, layout] = newConfigFigure(name, titleStr, subtitleStr)* creates a new
% figure with loaded configurations from config.mat given window name, layout
% title and subtitle with font size 8.
%
% *[fig, layout] = newConfigFigure(name, titleStr, subtitleStr, m)* creates
% figures as described before and splits the layout in m rows.
%
% *[fig, layout] = newConfigFigure(name, titleStr, subtitleStr, m, n)* as
% described before plus splitting the layout in m rows and n columns tiles.
%
%
%% Examples
%   [fig, layout] = newConfigFigure('My Fig', 'That is a Fig', 'Very good one.')
%   p = plot([1, 2, 4, 5, 5, 5, 6, 2, 9, 0]);
%
%   [fig, layout] = newConfigFigure('Fig', 'That Fig', 'Very good.', 1, 2)
%   ax1 = nexttile;
%   p1 = plot([1, 2, 4, 5, 5, 5, 6, 2, 9, 0]);
%   ax2 = nexttile;
%   p2 = plot([1, 2, 1, 4, 1, 5, 1, 3, 1, 0]);
%
%
%% Input Arguments
% *name* char vector or string of figure window name.
%
% *titleStr* char vector or string of displayed figure title, main plot title.
%
% *subtitleStr* char vector or string of displayed figure subtitle, main plot
% subtitle.
%
% *m* number of row tiles in figure window. Positive integer number.
%
% *n* number of column tiles in figure window. Positive integer number.
%
%
%% Output Arguments
% *fig* figure handle object of created figure window.
%
% *layoyut* tiled layout which is embedded in created figure window. Use
% nexttile to create axes.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: data/config.mat
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/figure.html#buich1u-1_seealso')) figure>
% * <matlab:web(fullfile(docroot,'matlab/ref/matlab.ui.figure-properties.html')) Figure Properties>
% * <matlab:web(fullfile(docroot,'matlab/ref/tiledlayout.html')) tiledlayout>
% * <matlab:web(fullfile(docroot,'matlab/ref/matlab.graphics.layout.tiledchartlayout-properties.html')) TileChartLayout Properties>
%
%
% Created on November 01. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [fig, layout] = newConfigFigure(name, titleStr, subtitleStr, m, n)
    arguments
        % validate name char vector as figure name property
        name (1,:) char {mustBeText}
        % validate figure title and subtitle as string or char vector
        titleStr (:,:) string {mustBeText}
        subtitleStr (:,:) string {mustBeText}
        % validate tile dimensions, default is 1x1 for single plot
        m (1,1) double {mustBeNumeric, mustBeInteger, mustBePositive} = 1
        n (1,1) double {mustBeNumeric, mustBeInteger, mustBePositive} = 1
    end
    
    % create new figure with given name and tile layout with passed m x n grid
    fig = figure('Name', name);
    layout = tiledlayout(fig, m, n);
    
    % try to load figure options from config and push options in it
    try
        % load workspace
        load('config.mat', 'FigureOptions', 'TileOptions');
        
        % get figure porperty names, values and count of
        figProps = fieldnames(FigureOptions);
        figVals = struct2cell(FigureOptions);
        nProps = length(figProps);
        % push values into figure handle
        for i = 1:nProps, set(fig, figProps{i}, figVals{i}); end
        
        % set colormap
        colormap(fig, 'jet')
        
        % get tile porperty names and values and count of
        tileProps = fieldnames(TileOptions);
        tileVals = struct2cell(TileOptions);
        nProps = length(tileProps);
        % push values into layout handle
        for i = 1:nProps, set(layout, tileProps{i}, tileVals{i}); end
        % set title and subtitle to figure layout
        layout.Title.String = titleStr;
        layout.Subtitle.String = subtitleStr;
        layout.Subtitle.FontSize = 8;
        
    catch ME
        rethrow(ME);
    end
end

