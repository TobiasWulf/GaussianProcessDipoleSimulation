%% Project Structure
% A good project directory structure is the key to build scalable and expandable
% software projects. Therfore each project folder has to fulfill an associated
% task. Additionally, a good structure facilitates project navigation and the
% retrieval and reuse of project content. Further on Matlab provides stratgies
% to add content to existing project structures and label it for script based
% execution of project task to manage project files. To add new content have a
% look at the links below.
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'simulink/ug/specify-project-path.html')) Specify Project Path>
% * <matlab:web(fullfile(docroot,'simulink/ug/add-files-to-the-project.html')) Add Files to the Project>
% * <matlab:web(fullfile(docroot,'simulink/ug/add-labels-to-files.html')) Add Labels to Files>
%
%
%% Directory Overview
%
% <include>Directory_Tree.txt</include>
%
% _Generated with linux shell command from on directory above the main project
% directory._
%  
%   !tree -dhn GaussianProcessDipolSimulation -o GaussianProcessDipolSimulation/Toolbox/docs/html/Directory_Tree.txt -I "project|Project_*"
%
%% Directory Tasks
%
% <html>
% <table border=1>
% <thead>
%   <tr><th>Directory</th><th>Task</th></tr>
% </thead>
% <tbody>
%   <tr>
%     <td>../</td>
%     <td>Main project directory which contains the Matlab project sandbox
%     folder and the hidden "remote" repository.
%     </td>
%   </tr>
%   <tr>
%     <td>../.git</td>
%     <td>Hidden remote repository for local statndalone work. Saves daily
%     working results. Provide a Git clonable instance of sandbox the directory.
%     Replacable. Not Matlab driven, simulates remote repository.
%     </td>
%   </tr>
%   <tr>
%     <td>./</td>
%     <td>Matlab project sandbox directory. Project root directory which
%     contains the Matlab project file, the info.xml, .gitignore, .gitattributes
%     files and all other project related subdirectories. Startup directory.
%     </td>
%   </tr>
%   <tr>
%     <td>./.git</td>
%     <td>Hidden local repository. Not replacable. Matlab driven repository.
%     </td>
%   </tr>
%   <tr>
%     <td>./resources</td>
%     <td>Autogenerated directory from Matlab project. Contains the local
%     project versionation and project xml-files.
%     </td>
%   </tr>
%   <tr>
%     <td>./data</td>
%     <td>Contains all project related datasets e.g. mat-files.
%     </td>
%   </tr>
%   <tr>
%     <td>./docs</td>
%     <td>Documentation directory which contains m-files only for documtation
%     use and the direcoty where all project remarked files are published into
%     HTML output files.
%     </td>
%   </tr>
%   <tr>
%     <td>./docs/html</td>
%     <td>Publish directory where published m-files are collected and bind to a
%     Matlab help browser readable documentation. It contains html-files and
%     subdirectory for images and figures which are used in the documentaion.
%     The help browser search database is placed here too. Much more important
%     the directory contains the helptoc.xml which pointed by the info.xml from
%     root project directory.
%     </td>
%   </tr>
%   <tr>
%     <td>./docs/html/figures</td>
%     <td>Contains all needed fig-files which are used in the documentation.
%     </td>
%   </tr>
%   <tr>
%     <td>./docs/html/helpsearch-v3</td>
%     <td>Contains autogenerated help search database entries. The directory is
%     rewritten during the publish documentation process.
%     </td>
%   </tr>
%   <tr>
%     <td>./docs/html/images</td>
%     <td>Contains all needed image files like png-files which are used in the
%     documentation.
%     </td>
%   </tr>
%   <tr>
%     <td>./scripts</td>
%     <td>The sripts directory contains all executable script m-files to solve
%     certain tasks in the project, to generate datasets or execute parts of the
%     toolbox source code.
%     </td>
%   </tr>
%   <tr>
%     <td>./src</td>
%     <td>Source code directory which contains reusable source code clustered in
%     submodule direcotries. The code can be function oriented or class oriented
%     or a mix of both. Contains no bare script files.
%     </td>
%   </tr>
%   <tr>
%     <td>./src/util</td>
%     <td>Util function and class space. Function and class source code to slove
%     upcomming help tasks e.g. to manage project content, to support plot
%     framework or reporting or publishing processes.
%     </td>
%   </tr>
%   <tr>
%     <td>./src/util/plotFunctions</td>
%     <td>Contain plot functions for reuse.
%     </td>
%   </tr>
%   <tr>
%     <td>./tests</td>
%     <td>For test driven development each function or class needs a own
%     test space or file. The directory contains these test.
%     </td>
%   </tr>
%   <tr>
%     <td>./temp</td>
%     <td>Temporally working directory to save intermediate results or the last
%     software state from session before.
%     </td>
%   </tr>
% </tbody>
% </table>
% </html>
%
%
%% Add New Elements
%
% *Add new folder to project:*
%
% # Create a new folder and add to Project Path after Matlab flow.
% # Run Checks *>* Add Files.
% # Run tree command from shell to update directory for the documentation
%   (optional).
% # Update directorry task table of this document.
%
%
% *Add new file to project:*
%
% # Create new File and edit the file after <Documentation_Workflow.html Documentation Workflow>
%   and Conventions.
% # Run Checks *>* Add Files.
% # Label the new file from project pane.
% # Commit file into active branch.
% # Registrate to the documentation if needed (publish, toc and listings docs).
%
%
% Created on October 1. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on October 07. 2020 by Tobias Wulf: Add inital description.
% Edited on October 08. 2020 by Tobias Wulf: Add workflow and overview.
% -->
% </html>
%
