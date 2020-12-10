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




%% Scan for HTML Files
% Scan for all published HTML files in the project publish directory.
disp('Scan for published files ...');
HTML = dir(fullfile(PathVariables.publishHtmlPath, '*.html'));

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
    destinationPath = fullfile(PathVariables.exportPublishPath, [fName '.pdf']);
    cmdStr = join(["wkhtmltopdf", ...
        "-B 27mm", ...
        "-L 37mm", ...
        "-R 27mm", ...
        "-T 27mm", ...
        ..."--window-status finished", ...
        ..."--no-stop-slow-scripts", ...
        "--javascript-delay 1000", ...
        "%s %s"]);
    shellStr = sprintf(cmdStr, sourcePath, destinationPath);
    try
        [status, cmdout] = system(shellStr);
        % disp(cmdout);
        if status ~= 0
            error('Export failure.');
        end
    catch ME
        setenv('LD_LIBRARY_PATH', matlabLibPath);
        disp(cmdout);
        rethrow(ME)
    end
end

disp('Restor local library path ...');
setenv('LD_LIBRARY_PATH', matlabLibPath);
