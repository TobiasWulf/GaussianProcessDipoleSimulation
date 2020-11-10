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
% Edited on November 09. 2020 by Tobias Wulf: Save PathVariables as struct.
% Edited on November 09. 2020 by Tobias Wulf: Add Options for dipole simulation with square sensor array.
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


%% GeneralOptions
% General options like formats for strings or date or anything else what
% has no special relation to a theme complex.
disp('Set general options ...');
GeneralOptions = struct;
GeneralOptions.dateFormat = 'yyyy-mm-dd_HH-MM-SS-FFF';


%% Path Variables
% Key path variables and directories, often used in functions or scripts.
% Collet the path in a struct for easier save the struct fields as variables to
% config.mat via -struct flag.

disp('Create current project instance to gather information ...');

% create current project instance to retrieve root information
projectInstance = matlab.project.currentProject;

disp('Set path variables ...');
PathVariables =struct;

% project root path, needs to be recreated generic to work on different machines
PathVariables.rootPath = projectInstance.RootFolder;

% path to data folder, which contains datasets and config.mat
PathVariables.dataPath = fullfile(PathVariables.rootPath, 'data');

% path to TDK TAS2141 TMR angular sensor characterization dataset
PathVariables.tdkDatasetPath = fullfile(PathVariables.dataPath, ... 
    'TDK_TAS2141_Characterization_2020-10-22_18-12-16-827.mat');

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


%% Figure and Tiled Layout Options
% Options to unify plot and figure views and fast create new plots controlled by
% certain configurations. Use options with unique create functions for fast
% forward plotting routines. See Matlab documentation for further figure
% options if needed.
disp('Set figure and tile options for unified plots ...');
FigureOptions = struct;
FigureOptions.NumberTitle = 'off';
FigureOptions.Units = 'normalized';
FigureOptions.WindowStyle = 'docked';
% FigureOptions.OuterPosition = [0, 0, 1, 1];
% FigureOptions.WindowState = 'maximized';
TileOptions.Padding = 'normal';
TileOptions.TileSpacing = 'compact';


%% Sensor Array Options
% The options control the build up of the sensor array in geometry and
% techincal behavior. This means number of sensors in the array and its
% size in mm. The supply and offset voltage of each sensor which is needed
% for using the characterization which is normed in mV/V.
disp('Set sensor array option for geometry and behavior ...');
SensorArrayOptions = struct;

% Geometry of the sensor array
SensorArrayOptions.geometry = 'square';

% Sensor array square dimension
SensorArrayOptions.dimension = 8;

% Sensor array edge length in mm
SensorArrayOptions.edge = 2;

% Sensor array simulated supply voltage in volts
SensorArrayOptions.vcc = 3.3;

% Sensor array simulated offset voltage for bridge outputs in volts
SensorArrayOptions.voff = 1.65;

% Senor array voltage norm factor to recalculate norm bridge outputs to
% given supply voltage and offset voltage, current normin is mV/V which
% implements factor of 1e3
SensorArrayOptions.vnorm = 1e3;


%% Dipole Options
% Dipole options to calculate the magnetic field which stimulate the sensor
% array. The dipole is gained to sphere with additional z distance to the
% array by sphere radius.
disp('Set dipole options to calculate magnetic stimulus ...');
DipoleOptions = struct;

% Radius in mm of magnetic sphere in which the magnetic dipole is centered.
% So it can be seen as z-offset to the sensor array.
DipoleOptions.radius = 2;

% H-field magnitude to multiply of generated and relative normed dipole
% H-fields, the norming is done in zero position of [0 0 z+offset] for
% 0° due to the position of the magnetic moment [-1 0 0] x and y components
% are not relevant, norming without tilt. Magnitude in kA/m
DipoleOptions.hMag = 8.5;

% Magnetic moment magnitude attach rotation to the dipole field at a
% certain position with x, y and z components. Choose a huge value to
% prevent numeric failures
DipoleOptions.mMag = 1e6;


%% Traning Options
% Training options gives the software the needed information to generate
% training datasets by the sensor array simulation with a dipole manget as
% stimulus which pushed with an z offeset to a sphere.
disp('Set training options to generate dataset ...');
TrainingOptions = struct;

% Sensor array relative position to dipole magnet as position vector with
% x, y and z posiotn in mm. Negative x for left shift, negative y for up
% shift and negative z to place the layer under the dipole decrease z to
% increase the distance. The z-position will be subtracted by dipole sphere
% radius in simulation. So there is an offset given by the sphere radius
TrainigOptions.xPos = [0,];
TrainigOptions.yPos = [0,];
TrainigOptions.zPos = [0,];

% Dipole tilt in z-axes
TrainigOptions.tilt = [0,];

% Resolution of rotaion in degree, use same resoultion in training and test
% datasets to have the ability to back reference the index to fullscale
% test data sets 
TrainingOptions.angleRes = 0.5;

% Number rotaion angles, even distribute between 0° and 360° with respect
% to the resolution, even down sampling. To generate full scale the number
% relatead to the resolution or fast generate but wrong number to 0 to
% generate full scale rotation.
TrainingOptions.nAngles = 7;


%% Test Options
% Test options gives the software the needed information to generate
% test datasets by the sensor array simulation with a dipole manget as
% stimulus which pushed with an z offeset to a sphere.
disp('Set test options to generate dataset ...');
TestOptions = struct;

% Sensor array relative position to dipole magnet as position vector with
% x, y and z posiotn in mm. Negative x for left shift, negative y for up
% shift and negative z to place the layer under the dipole decrease z to
% increase the distance. The z-position will be subtracted by dipole sphere
% radius in simulation. So there is an offset given by the sphere radius
TestOptions.xPos = [0,];
TestOptions.yPos = [0,];
TestOptions.zPos = [0, 1, 2, 3, 4];

% Dipole tilt in z-axes
TestOptions.tilt = [0,];

% Resolution of rotaion in degree, use same resoultion in training and test
% datasets to have the ability to back reference the index to fullscale
% test data sets 
TestOptions.angleRes = 0.5;

% Number rotaion angles, even distribute between 0° and 360° with respect
% to the resolution, even down sampling. To generate full scale the number
% relatead to the resolution or fast generate but wrong number to 0 to
% generate full scale rotation.
TestOptions.nAngles = 720;


%% Save Configuration
% Save section wise each config part as struct to standalone variables in
% config.mat use newest save format with no compression.

% create config.mat with timestamp of creation
disp('Create config.mat ...');
timestamp = datestr(now, GeneralOptions.dateFormat);
save(PathVariables.configPath, ...
    'timestamp', ...
    'PathVariables', ...
    'PublishOptions', ... 
    'FigureOptions', ...
    'TileOptions', ... 
    'SensorArrayOptions', ... 
    'DipoleOptions', ...
    'TrainingOptions', ... 
    'TestOptions', ...
    '-v7.3', '-nocompression');
