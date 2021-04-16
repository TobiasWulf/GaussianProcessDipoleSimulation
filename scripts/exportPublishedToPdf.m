%% exportPublishedToPdf
% Export Matlab generated Tex documentation (publish) to combined LaTeX index
% file ready compile to appendix manual. 
%
%
%% Requirements
% * Other m-files None
% * Subfunctions: removeFilesFromDir
% * MAT-files required: data/config.mat
%
%
%% See Also
% * <generateConfigMat.html generateConfigMat>
% * <publishProjectFilesToHTML.html publishProjectFilesToHTML>
% * <Documentation_Workflow.html Documentation Workflow>
%
%
% Created on December 10. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on April 16. 2021 by Editor: Solve export via own latex style sheet.
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
toc = ["section",           "GaussianProcessDipoleSimulation.tex";
       "section"            "Workflows.tex";
       "subsection",        "Project_Preparation.tex";
       "subsection",        "Project_Structure.tex";
       "subsection",        "Git_Feature_Branch_Workflow.tex";
       "subsection",        "Documentation_Workflow.tex";
       "subsection",        "Simulation_Workflow.tex";
       "section",           "Executable_Scripts.tex";
       "subsection",        "publishProjectFilesToHTML.tex";
       "subsection",        "generateConfigMat.tex";
       "subsection",        "generateSimulationDatasets.tex";
       "subsection",        "deleteSimulationDatasets.tex";
       "subsection",        "deleteSimulationPlots.tex";
       "subsection",        "exportPublishedToPdf.tex";
       "subsection",        "demoGPRModule.tex";
       "subsection",        "investigateKernelParameters.tex";
       "subsection",        "compareGPRKernels.tex";
       "section",           "Source_Code.tex";
       "subsection",        "sensorArraySimulation.tex";
       "subsubsection",     "rotate3DVector.tex";
       "subsubsection",     "generateDipoleRotationMoments.tex";
       "subsubsection",     "generateSensorArraySquareGrid.tex";
       "subsubsection",     "computeDipoleH0Norm.tex";
       "subsubsection",     "computeDipoleHField.tex";
       "subsubsection",     "simulateDipoleSquareSensorArray.tex";
       "subsection",        "gaussianProcessRegression.tex";
       "subsubsection",     "initGPR.tex";
       "subsubsection",     "initGPROptions.tex";
       "subsubsection",     "initTrainDS.tex";
       "subsubsection",     "initKernel.tex";
       "subsubsection",     "initKernelParameters.tex";
       "subsubsection",     "tuneKernel.tex";
       "subsubsection",     "computeTuneCriteria.tex";
       "subsubsection",     "predFrame.tex";
       "subsubsection",     "predDS.tex";
       "subsubsection",     "lossDS.tex";
       "subsubsection",     "optimGPR.tex";
       "subsubsection",     "computeOptimCriteria.tex";
       "subsubsection",     "kernelQFCAPX.tex";
       "paragraph",         "QFCAPX.tex";
       "paragraph",         "meanPolyQFCAPX.tex";
       "paragraph",         "initQFCAPX.tex";
       "subsubsection",     "kernelQFC.tex";
       "paragraph",         "QFC.tex";
       "paragraph",         "meanPolyQFC.tex";
       "paragraph",         "initQFC.tex";
       "subsubsection",     "basicMathFunctions.tex";
       "paragraph",         "sinoids2angles.tex";
       "paragraph",         "angles2sinoids.tex";
       "paragraph",         "decomposeChol.tex";
       "paragraph",         "frobeniusNorm.tex";
       "paragraph",         "computeInverseMatrixProduct.tex";
       "paragraph",         "computeTransposeInverseProduct.tex";
       "paragraph",         "addNoise2Covariance.tex";
       "paragraph",         "computeAlphaWeights.tex";
       "paragraph",         "computeStdLogLoss.tex";
       "paragraph",         "computeLogLikelihood.tex";
       "paragraph",         "estimateBeta.tex";
       "subsection",        "util.tex";
       "subsubsection",     "removeFilesFromDir.tex";
       "subsubsection",     "publishFilesFromDir.tex";
       "subsubsection",     "plotFunctions.tex";
       "paragraph",         "plotTDKCharDataset.tex";
       "paragraph",         "plotTDKCharField.tex";
       "paragraph",         "plotTDKTransferCurves.tex";
       "paragraph",         "plotKMZ60CharDataset.tex";
       "paragraph",         "plotKMZ60CharField.tex";
       "paragraph",         "plotKMZ60TransferCurves.tex";
       "paragraph",         "plotDipoleMagnet.tex";
       "paragraph",         "plotSimulationDataset.tex";
       "paragraph",         "plotSingleSimulationAngle.tex";
       "paragraph",         "plotSimulationSubset.tex";
       "paragraph",         "plotSimulationCosSinStats.tex"
       "paragraph",         "plotSimulationDatasetCircle.tex";
       "section",           "Datasets.tex";
       "subsection",        "TDK_TAS2141_Characterization.tex";
       "subsection",        "NXP_KMZ60_Characterization.tex";
       "subsection",        "Config_Mat.tex";
       "subsection",        "Training_and_Test_Datasets.tex";
       "section",           "Unit_Tests.tex";
       "subsection",        "runTests.tex";
       "subsection",        "removeFilesFromDirTest.tex";
       "subsection",        "rotate3DVectorTest.tex";
       "subsection",        "generateDipoleRotationMomentsTest.tex";
       "subsection",        "generateSensorArraySquareGridTest.tex";
       "subsection",        "computeDipoleH0NormTest.tex";
       "subsection",        "computeDipoleHFieldTest.tex";
       "subsection",        "tiltRotationTest.tex";];

nToc = length(toc);
fprintf("%d toc entries remarked ...\n", nToc);


%% Scan for Tex Files
% Scan for all published Tex files in the project publish directory.
disp('Scan for published files ...');
TEX = dir(fullfile(PathVariables.publishHtmlPath, '*.tex'));
if nToc ~= length(TEX)
    warning(...
        'TOC (%d) length and found Tex (%d) files are diverging.', ...
        nToc, length(TEX));
end

%% Export Tex
% Export found Tex files to Manual file. Each file gets its own represenstation.
% Filename is kept. Write files into Manual folder under LaTeX subdirectory 
% in docs path. Get filename, move to new path. Write Manual.
disp('Export published Tex to Manual ...');
fprintf('Source: %s\n', TEX(1).folder);
fprintf('Destination: %s\n', PathVariables.exportPublishPath);
for ftex = TEX'
    disp(ftex.name);
    sourcePath = fullfile(ftex.folder, ftex.name);
    destinationPath = fullfile(...
        PathVariables.exportPublishPath, ftex.name);
    try
        [status, msg] = movefile(sourcePath, destinationPath);
        % disp(cmdout);
        if status ~= 1
            error('Export failure.');
        end
    catch ME
        disp(msg);
        rethrow(ME)
    end
end


%% Write TOC to LaTeX File
% Wirete TOC to LaTeX file and generate for each file a subimport along toc
% content line with marked toc depth.
disp('Write TOC to Manual.tex ...');
fileID = fopen(fullfile(...
    PathVariables.exportPublishPath, 'Manual.tex'), 'w');
fprintf(fileID, "%% appendix software documentation\n");
fprintf(fileID, "%% @author Tobias Wulf\n");
fprintf(fileID, ...
    "%% Autogenerated LaTeX file. Generated by exportPublishedToPdf.\n");
fprintf(fileID, ...
    "%% Software manual with TOC generated in the same script.\n");
fprintf(fileID, "%% Generated on %s.\n\n", datestr(datetime('now')));
fprintf(fileID, "\\documentclass[class=article, crop=false]{standalone}\n");
fprintf(fileID, "\\usepackage[subpreambles=true]{standalone}\n");
fprintf(fileID, "\\usepackage{import}\n\n");
fprintf(fileID, "\\begin{document}\n");
fprintf(fileID, "\\clearpage\n");
fprintf(fileID, ...
    "\\textbf{Matlab software appendix auto generated on %s.}\n\n", ...
    datestr(datetime('now', 'Format', 'y-MM-d')));

for i = 1:nToc
    level = toc(i);
    fName = toc(i,2);
    [~, fstr, ~] = fileparts(fName);
    lstr = lower(strrep(fstr, '_', '-'));
    tstr = strrep(fstr, '_', ' ');
    
    fprintf(fileID, "\\%s{%s}", level, tstr);
    fprintf(fileID, "\\label{mcode:%s}\n", lstr);
    fprintf(fileID, "\\subimport{./}{%s}\n", fName);
    fprintf(fileID, "\\clearpage\n");
end

fprintf(fileID, "\\end{document}\n");
fclose(fileID);
