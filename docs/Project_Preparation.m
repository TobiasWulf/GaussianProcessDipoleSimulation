%% Project Preparation
% The first steps to setup a scalable software project are none trival and need
% a good strcuture for later project expands. Either to setup further new
% projects a well known scalable project structure helps to combine different
% software parts to bigger environment packages. Therefore a project preparation
% flow needs to be documented. It unifies the outcome of software projects and
% part guarantee certain quality aspects.
%
% The following steps can be used as guidance to establish a propper Matlab
% project structure in general. Each step is documented with screenshots to give 
% a comprehensible explanation.
%
%
%% Create Main Project Directory
% The main project directory contains only two subfolders. The first one is the
% Toolbox folder where the project, m-files and other project files like
% documentation are placed. The folder is also called sandbox folder in Matlab
% project creation flows which is just another description for a project folder
% where the coding takes place. The second folder is a hidden Git repository
% folder which keeps the versionation in final. It is respectively seen a remote
% repository that establish basics to setup backup plans via Git clone or can
% be laterly replaced by remote repository on a server or a GitHub repository to
% work in common on the project.
%
% *First step:*
%
% # Create an empty project folder, open Matlab navigate to folder path.
% # Right click in the Current Folder pane and create New *>* Folder "Toolbox".
% # Open a Git terminal and in the project directory and initialize an empty
%   Git repository.
%
% <html>
% <img src="images/Project_Preparation/1_create_matlab_project_empty_toolbox.png" height=200>
% </html> 
%
% <html>
% <img src="images/Project_Preparation/2_create_matlab_project_empty_git.png" height=200>
% </html>
%
%
%% Create Matlab Project with Git Support
% In second it is needed to create the Matlab project files in a certain way to
% get full Git support and support for the Matlab help browser environment. In
% this use case the before created local Git repository is used as remote
% origin. So several settings are automatacally made during the creation process
% by Matlab and as mentioned before the "local remote" repository can be
% replaced later by a remote origin located on a server or GitHub. The Toolbox
% folder must be empty to process the following steps.
%
% *It is recommend to do no further Git actions on the created Git repository
% via Git terminal!*
%
% These steps only proceed the project setup further Matlab framework
% functionality is added later.
%
% *Second step:*
%
% # In the created main project directory create a New *>* Project *>* From Git.
% # Change the repository path to the hidden Git repository path in the main
%   project directory.
% # Change the sandbox path to the Toolbox path in the main project directory.
% # Click Retrieve.
% # Enter the project name given by the main project directory name and click
%   OK.
% # Click on Set Up Project and skip the two follwing steps via Next and Finish.
% # Switch to Toolbox directory by double click on the folder in the Current
%   Folder pane, open the created Matlab project file with a double click and
%   check source control information under PROJECT tab by clicking Git Details.
% # Add a short project summary by click on Details under the ENVIRONMENT
%   section of the PROJECT tab.
% # Click Apply.
% # Click OK.
% 
% *The project itself is under source control now.*
%
% <html>
% <img src="images/Project_Preparation/3_create_matlab_project_from_git.png" height=250>
% </html>
%
% <html>
% <img src="images/Project_Preparation/4_set_repository_sandbox_path.png" height=200>
% </html>
%
% <html>
% <img src="images/Project_Preparation/5_set_project_name_after_repo_create.png" height=150>
% </html>
%
% <html>
% <img src="images/Project_Preparation/6_setup_created_project.png" height=250>
% </html>
%
% <html>
% <img src="images/Project_Preparation/7_next_skip_add_folders.png" height=250>
% </html>
%
% <html>
% <img src="images/Project_Preparation/8_finish_skip_startup_cleanup_scripts.png" height=250>
% </html>
%
% <html>
% <img src="images/Project_Preparation/9_check_git_details.png" height=200>
% </html>
%
% <html>
% <img src="images/Project_Preparation/10_check_project_details_add_description.png" height=300>
% </html>
%
%
%% Registrate Binaries to Git and Git Ignore Cases
%
% <html>
% <img src="images/Project_Preparation/11_registrate_binaries_with_git.png" height=300>
% </html>
%
% <html>
% <img src="images/Project_Preparation/12_setup_gitignore.png" height=300>
% </html>
%
%
%% Checkout Project State and Do Initial Commit
%
% <html>
% <img src="images/Project_Preparation/13_check_add_files.png" height=300>
% </html>
%
% <html>
% <img src="images/Project_Preparation/14_add_git_files.png" height=300>
% </html>
%
% <html>
% <img src="images/Project_Preparation/15_commit_initialized_project.png" height=300>
% </html>
%
%
%% Push Project to Remote Repository and Backup on External Medium
%
%
% Created on September 30. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on September 30. 2020 by Tobias Wulf: Add screenshots to documentation.
% -->
% </html>