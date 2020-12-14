%% exportPublishedToPdf
% Export Matlab generated HTML documentation (publish) to pdf-files and combine
% them into a latex index file ready compile to pdf manual. This script works on
% unix sytems only or needs to be adjusted for windows systems for library path
% and wkhtmltopdf binary path.
%
%
%% Requirements
% * Other m-files required: src/util/removeFilesFromDir.m
% * Subfunctions: wkhtmltopdf (shell), pdflatex (shell)
% * MAT-files required: data/config.mat
%
%
%% See Also
% * <generateConfigMat.html generateConfigMat>
% * <matlab:web(fullfile(docroot,'matlab/ref/system.html')) system>
% * <https://wkhtmltopdf.org/ wkhtmltopdf>
% * <publishProjectFilesToHTML.html publishProjectFilesToHTML>
% * <Documentation_Workflow.html Documentation Workflow>
%
%
% Created on December 10. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
%
%% Start Exporting Script, Clean Up and Load Config
% At first clean up junk from workspace and clear prompt for new output. Set
% project root path to create absolute file path with fullfile function.
% Load absolute path variables and publishing options from config.mat
disp('Workspace cleaned up ...');
clearvars;
clc;
disp('Load configuration ...');
try
    load('config.mat', 'PathVariables');
catch ME
    rethrow(ME);
end

%% Define Manual TOC
% The maual toc must be in the same order as in helptoc.xml in the publish html
% folder. The toc is used to generate a latex file to include for appendices.
toc = ["section",       "GaussianProcessDipoleSimulation.pdf";
       "subsection"     "Workflows.pdf";
       "subsubsection", "Project_Preparation.pdf";
       "subsubsection", "Project_Structure.pdf";
       "subsubsection", "Git_Feature_Branch_Workflow.pdf";
       "subsubsection", "Documentation_Workflow.pdf";
       "subsubsection", "Simulation_Workflow.pdf";
       "subsection",    "Executable_Scripts.pdf";
       "subsubsection", "publishProjectFilesToHTML.pdf";
       "subsubsection", "generateConfigMat.pdf";
       "subsubsection", "generateSimulationDatasets.pdf";
       "subsubsection", "deleteSimulationDatasets.pdf";
       "subsubsection", "deleteSimulationPlots.pdf";
       "subsubsection", "exportPublishedToPdf";
       "subsection",    "Source_Code.pdf";
       "subsubsection", "sensorArraySimulation.pdf";
       "paragraph",     "rotate3DVector.pdf";
       "paragraph",     "generateDipoleRotationMoments.pdf";
       "paragraph",     "generateSensorArraySquareGrid.pdf";
       "paragraph",     "computeDipoleH0Norm.pdf";
       "paragraph",     "computeDipoleHField.pdf";
       "paragraph",     "simulateDipoleSquareSensorArray.pdf";
       "subsubsection", "util.pdf";
       "paragraph",     "removeFilesFromDir.pdf";
       "paragraph",     "publishFilesFromDir.pdf";
       "paragraph",     "plotFunctions.pdf";
       "subparagraph",  "plotTDKCharDataset.pdf";
       "subparagraph",  "plotTDKCharField.pdf";
       "subparagraph",  "plotTDKTransferCurves.pdf";
       "subparagraph",  "plotKMZ60CharDataset.pdf";
       "subparagraph",  "plotKMZ60CharField.pdf";
       "subparagraph",  "plotKMZ60TransferCurves.pdf";
       "subparagraph",  "plotDipoleMagnet.pdf";
       "subparagraph",  "plotSimulationDataset.pdf";
       "subparagraph",  "plotSingleSimulationAngle.pdf";
       "subparagraph",  "plotSimulationSubset.pdf";
       "subparagraph",  "plotSimulationCosSinStats.pdf"
       "subparagraph",  "plotSimulationDatasetCircle.pdf";
       "subsection",    "Datasets.pdf";
       "subsubsection", "TDK_TAS2141_Characterization.pdf";
       "subsubsection", "NXP_KMZ60_Characterization.pdf";
       "subsubsection", "Config_Mat.pdf";
       "subsubsection", "Training_and_Test_Datasets.pdf";
       "subsection",    "Unit_Tests.pdf";
       "subsubsection", "runTests.pdf";
       "subsubsection", "removeFilesFromDirTest.pdf";
       "subsubsection", "rotate3DVectorTest.pdf";
       "subsubsection", "generateDipoleRotationMomentsTest.pdf";
       "subsubsection", "generateSensorArraySquareGridTest.pdf";
       "subsubsection", "computeDipoleH0NormTest.pdf";
       "subsubsection", "computeDipoleHFieldTest.pdf";
       "subsubsection", "tiltRotationTest.pdf";];

nToc = length(toc);
fprintf("%d toc entries remarked ...\n", nToc);

%% Write TOC to LaTeX File
% Wirete TOC to latex file and generate for each pdf to include a toc content
% line with marked toc depth.
disp('Write TOC to Manual.tex ...');
addPdfStr = "\\includepdf[page=-, pagecommand={\\phantomsection" + ...
    "\\addcontentsline{toc}{%s}{%s}}]{%s}\n";
fileID = fopen(fullfile(...
    PathVariables.exportPublishPath, 'Manual.tex'), 'w');
% fprintf(fileID, "%% !TEX root = ../thesis.tex\n");
fprintf(fileID, "%% appendix software documentation\n");
fprintf(fileID, "%% @author Tobias Wulf\n");
fprintf(fileID, ...
    "%% Autogenerated LaTeX file. Generated by exportPublishedToPdf.\n");
fprintf(fileID, ...
    "%% Software manual with TOC generated in the same script.\n");
fprintf(fileID, "%% Generated on %s.\n\n", datestr(datetime('now')));
for i = 1:nToc
    level = toc(i);
    fName = toc(i,2);
    [~, titleStr, ~] = fileparts(fName);
    titleStr = strrep(titleStr, '_', ' ');
    fprintf(fileID, addPdfStr, level, titleStr, fName);
end
fclose(fileID);


%% Scan for HTML Files
% Scan for all published HTML files in the project publish directory.
disp('Scan for published files ...');
HTML = dir(fullfile(PathVariables.publishHtmlPath, '*.html'));
if nToc ~= length(HTML)
    warning(...
        'TOC (%d) length and found HTML (%d) files are diverging.', ...
        nToc, length(HTML));
end

%% Export HTML to Pdf
% Export found HTML files to Pdf files. Each file gets its own Pdf
% represenstation. Filename is kept with pdf extension. Write files into Manual
% folder under latex subdirectory in docs path. Using wkhtmltopdf shell
% application. Get filename, add pdf extension new path to file. Create shell
% string to execute with system command. Get current library path (Matlab) and
% change it to system library path to execute wkhtmltopdf after that restor
% library back to Matlab.
disp('Change local library path to system path ...');
matlabLibPath = getenv('LD_LIBRARY_PATH');
systemLibPath = '/usr/lib/x86_64-linux-gnu';
setenv('LD_LIBRARY_PATH', systemLibPath);

disp('Export published HTML to Pdf ...');
fprintf('Source: %s\n', HTML(1).folder);
fprintf('Destination: %s\n', PathVariables.exportPublishPath);
for fhtml = HTML'
    disp(fhtml.name);
    [~, fName, ~] = fileparts(fhtml.name);
    sourcePath = fullfile(fhtml.folder, fhtml.name);
    destinationPath = fullfile(...
        PathVariables.exportPublishPath, [fName '.pdf']);
    
    cmdStr = join(["wkhtmltopdf", ...
        "-B 57mm", ...
        "-L 30mm", ...
        "-R 30mm", ...
        "-T 37mm", ...
        "--minimum-font-size 11", ...
        "--enable-local-file-access", ...
        "--disable-external-links", ...
        "--disable-internal-links", ...
        ..."--disable-smart-shrinking", ...
        "--window-status finished", ...
        "--no-stop-slow-scripts", ...
        "--javascript-delay 2000", ...
        "%s %s"]);
    shellStr = sprintf(cmdStr, sourcePath, destinationPath);
    
    try
        [status, cmdout] = system(shellStr);
        % disp(cmdout);
        if status ~= 0
            error('Export failure.');
        end
    catch ME
        %setenv('LD_LIBRARY_PATH', matlabLibPath);
        disp(cmdout);
        rethrow(ME)
    end
end

disp('Restor local library path ...');
setenv('LD_LIBRARY_PATH', matlabLibPath);
