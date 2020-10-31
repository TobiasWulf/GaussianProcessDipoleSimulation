%% generateConfigMat
% Generate configuration mat-file wich contains reusable configuration to
% control the software or certain function parameters. Centralized collection of
% configuration. If it is certain configuration needed place it here.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/save.html')) save>
% * <matlab:web(fullfile(docroot,'matlab/ref/load.html')) load>
% * <matlab:web(fullfile(docroot,'matlab/ref/matlab.io.matfile.html')) matfile>
%
%
% Created on October 29. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%
%% Clean Up
% Clear variables from workspace to build up a fresh new configuration
% workspace.
disp('Clean up workspace ...');
clearvars;
clc;


%% Path Variables
% Key path variables and directories, often used in functions or scripts.
% Collet the path in a struct for easier save the struct fields as variables to
% config.mat via -struct flag.

disp('Create current project instance to gather information ...');

% create current project instance to retrieve root information
projectInstance = matlab.project.currentProject;

disp('Create path variables ...');

% project root path, needs to be recreated generic to work on different machines
PathVariables.rootPath = projectInstance.RootFolder;

% path to data folder, which contains datasets and config.mat
PathVariables.dataPath = fullfile(PathVariables.rootPath, 'data');

% path to TDK TAS2141 TMR angular sensor characterization dataset
PathVariables.tdkDatasetPath = fullfile(PathVariables.dataPath, ... 
    'TDK_TAS2141_Characterization_2019-07-24.mat');

% path to config file dataset
PathVariables.configPath = fullfile(PathVariables.dataPath, 'config.mat');

% path to documentation and m-files only for documentation
PathVariables.docsPath = fullfile(PathVariables.rootPath, 'docs');

% path to publish html documentation output directory, helptoc.xml location
PathVariables.publishHtmlPath = fullfile(PathVariables.docsPath, 'html');

% path to style sheet for html documentation, Matlab provided style sheet
PathVariables.publishStyleSheetPath = string(fullfile(matlabroot, 'toolbox', ...
    'matlab', 'codetools', 'private', 'mxdom2simplehtml.xsl'));

% path to documentation search database entries for Matlab help browser support
PathVariables.helpsearchPath = fullfile(PathVariables.publishHtmlPath, ...
    'helpsearch-v3');

% path to executable m-file scripts of the project
PathVariables.scriptsPath = fullfile(PathVariables.rootPath, 'scripts');

% path to source code files, function and class files
PathVariables.srcPath = fullfile(PathVariables.rootPath, 'src');


%% Publish Options
% These are general options for documents to publish. They are passed to the
% matlab publish function via a struct where each option gets its own field.
% The option struct can be copied and adjusted for differing publish
% conditions in example for scripts, functions, and bare document m-files.
% Initialize the option struct with output format field name and field value
% and add further fields (options) with point value.
disp('Set publish options struct for publish function ...');
PublishOptions = struct('format', 'html');
PublishOptions.outputDir = PathVariables.publishHtmlPath;
PublishOptions.stylesheet = PathVariables.publishStyleSheetPath;
PublishOptions.createThumbnail = false;
PublishOptions.figureSnapMethod = 'entireFigureWindow';
PublishOptions.imageFormat = 'png';
PublishOptions.maxHeight = [];
PublishOptions.maxWidth = [];
PublishOptions.useNewFigure = false;
PublishOptions.evalCode = false;
PublishOptions.catchError = true;
PublishOptions.codeToEvaluate = [];
PublishOptions.maxOutputLines = Inf;
PublishOptions.showCode = true;


%% Save Configuration
% Save section wise each config part as struct or struct fields to standalone
% variables in config.mat use newest save format with no compression.

% save PathVariables struct fields to config.mat with no compression
disp('Save path variables configuration to config.mat ...');
save(PathVariables.configPath, '-struct', 'PathVariables', ...
    '-v7.3', '-nocompression');

% save PublishOptions struct to config.mat with no compression, append to file
disp('Save publish options configuration to config.mat ...')
save(PathVariables.configPath, 'PublishOptions', ... 
    '-append', '-nocompression');
