%% publishProjectFilesToHTML
% The is script is used to publish all toolbox included files to HTML
% documentation folder docs/html. The script runs a section with certain
% options for each project part and uses the built-in function to generate the
% documentation files. For a complete documentation support each generated html
% document needs to get listed in the project helptoc file with toc entry.
%
% See also:
%
% * <matlab:web(fullfile(docroot,'matlab/ref/publish.html')) publish>
% * <matlab:web(fullfile(docroot,'matlab/ref/fullfile.html')) fullfile>
% * <matlab:web(fullfile(docroot,'matlab/ref/builddocsearchdb.html')) builddocsearchdb>
% * <matlab:web(fullfile(docroot,'matlab/ref/delete.html')) delete>
%
% Created on September 21. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on September 21. 2020 by Tobias Wulf: Added first publish documents.
% Edited on September 22. 2020 by Tobias Wulf: Add Sript section.
% Edited on September 23. 2020 by Tobias Wulf: Add helpsearch section (Build).
% Edited on September 30. 2020 by Tobias Wulf: Improve helpsearch rewrite.
% Edited on September 30. 2020 by Tobias Wulf: Add Project_Preparation.m.
% Edited on October 01. 2020 by Tobias Wulf: Add open documention section.
% Edited on October 02. 2020 by Tobias Wulf: Rename Flows.m to Work_Flows.m
% Edited on October 02. 2020 by Tobias Wulf: See also manually links (evalCode).
% Edited on October 07. 2020 by Tobias Wulf: Add Project_Structure.m.
% Edited on October 07. 2020 by Tobias Wulf: Git Feature Branch Workflow.
% -->
% </html>
%
%
%% Start Publishing Script and Clean Up
% At first clean up junk from workspace and clear prompt for new output. Set
% project root path to create absolute file path with fullfile function.
% Relative path objective can be lead to shadowing file errors.
clearvars;
clc;
disp('Workspace cleaned up ...');
rootPath = '/home/tobias/Documents/workspace/matlab/GaussianProcessDipolSimulation/Toolbox/';
disp('Set project root path to ...');
disp(rootPath);

%% Publish Options
% These are general options for documents to publish. They are passed to the
% matlab publish function via a struct where each option gets its own field.
% The option struct can be copied and adjusted for differing publish
% conditions in example for scripts, functions, and bare document m-files.
% Initialize the option struct with output format field name and field value
% and add further fields (options) with point value.
PublishOptions = struct('format', 'html');
PublishOptions.outputDir = fullfile(rootPath, 'docs', 'html');
PublishOptions.stylesheet = fullfile(matlabroot, 'toolbox', 'matlab', ...
    'codetools', 'private', 'mxdom2simplehtml.xsl');
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
disp('Set general publishing options to ...');
disp(PublishOptions);

%% Project Documentation Files
% In this section of the publish script every bare documentation script should
% be handled and executed to publish. These are m-files without any executeable
% code so they exist just to transport the documentation content into html
% output. The files are passed with fullfile to a cell array which is looped to
% the publish function passed options for publishing
disp('Publish project documentation files ...');
projectDocFiles = { ...
    fullfile(rootPath, 'docs', 'Introduction.m'), ...
    fullfile(rootPath, 'docs', 'Workflows.m'), ...
    fullfile(rootPath, 'docs', 'Project_Preparation.m'), ...
    fullfile(rootPath, 'docs', 'Executable_Scripts.m'), ...
    fullfile(rootPath, 'docs', 'Project_Structure.m'), ...
    fullfile(rootPath, 'docs', 'Git_Feature_Branch_Workflow.m'), ...
};
disp('Project documentation files collected ...');
disp('Publishing ...');
for docToPublish = projectDocFiles
    disp(docToPublish{:});
    publishedFile = publish(docToPublish{:}, PublishOptions);
    disp(publishedFile)
end

%% Executable Script Files
% The section collects all ready to execute scripts from project scripts folder
% and publish them to html documentation folder. Every script must be notice in
% in executableScripts.m file with one line description. To gain control of
% script execution during the publish porcess a second cell parameter is added
% to the script path. The parameter indicates if the script is executed or not.
% That is very important if scripts contains critical or loop gaining code. In
% example the publishProjectFilesToHTML.m script such loop gaining code. If
% eval code during publishing is enabled the script starts publishing itself
% over and over again because it contains the loop entry via the publish
% function. So routine is minmal adjusted by evalCode parameter in
% PublishOptions struct.
disp('Publish executable scripts ...');
executableScriptFiles = { ...
    {fullfile(rootPath, 'scripts', 'publishProjectFilesToHTML.m'), false}, ...
};
disp('Executable script files collected ...');
disp('Publishing ...');
for scriptToPublish = executableScriptFiles
    disp(scriptToPublish{1}{1});
    PublishOptions.evalCode = scriptToPublish{1}{2};
    publishedFile = publish(scriptToPublish{1}{1}, PublishOptions);
    disp(publishedFile);
end

%% Build Documentation Database for Matlab Help Browser
% To support Matlabs help browser it is needed build searchable help browser
% entries including a searchable database backend. Matlabs built-in function
% builddocsearchdb does the trick. The function just needs the output directory
% of builded html documentation and it creates a subfolder which includes the
% database. About the info.xml from the project root and the helptoc.xml file
% the html documentation folder all listet documentation is accessable.
% At first remove old database before build the new reference database.
% Remove autogenerated directory helpsearch-v3. At first get folder content and
% remove first two relative directory entries from struct. Then delete files
% and check if files do not exist any more. At least build up new search
% database entries to Matlab help.
disp('Remove old search entries ...');
filesToRemove = dir(fullfile(rootPath, 'docs', 'html', 'helpsearch-v3'));
filesToRemove(1:2) = [];
removeStatus = 0;
for file = filesToRemove'
    delete(fullfile(file.folder, file.name))
    removeStatus = removeStatus + ... 
        exist(fullfile(file.folder, file.name), 'file');
end
if removeStatus > 0
    disp('Could not remove old search entries ...');
else
    builddocsearchdb(PublishOptions.outputDir);
    disp('Search entries generated ...');
end
disp('Done ...');

%% Open Generated Documentation.
% Open generated HTML documentation from documentation root HTML file which
% should be a project introduction or project roadmap page. Comment out if this
% script is added to project shutdown tasks.
open(fullfile(PublishOptions.outputDir, 'Git_Feature_Branch_Workflow.html'));
