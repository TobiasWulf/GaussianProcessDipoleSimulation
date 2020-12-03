%% GaussianProcessDipoleSimulation
% The project of sensor array simulation and Gaussian Processes for angle
% predictions on simulation datasets starts in
%
% *May 06. 2019*
%
% with IEEE paper by Thorben Schüthe which is a base investigation of
% "Two-Dimensional Characterization and Simplified Simualtion Procedure for
% Tunnel Magnetorersistive Angle Sensors". What produces characterization
% datasets of different current available angular sensors on the market.
%
% *June 11. 2019*
%
% Thorben Schüthe came up with a high experimental scripting for abstracting
% sensor characterization fields to an array of sensor fields which was
% stimulated by bare dipole field eqautions and a not clear figured out way to
% norm field strength in stimulus. Rare Documented set of scripts.
%
% *November 06. 2019*
%
% Prof. Dr. Klaus Jünemann supports the team around Prof. Dr.-Ing. Karl-Ragmar
% Riemschneider and Thorben Schüthe with an apply of Gaussian Process learning
% to investigate on angle predictions for sensor array simualtion results. The
% attemp of the solution was working for tigth set of parameter and was highly
% experimental with rare documentation and few set of functions and script. The
% math of this very solution based the standard book for Gaussian Process by
% Williams and Rasmussen. The algorithm is related to the guidline for linear
% regression model and still not working stable enough to generate valid results
% in some use cases. Needs further investigation of parameters and function
% space.
%
% *September 21. 2020*
%
% Tobias Wulf establish a Matlab project structur and programming guidance and
% flows to document the source code integrated in the Matlab project
% architecture. That includes templating for scripts and functions and general
% descriptions of project structure and guidance for testing and documenting
% project results or new source code including automation for publishing html
% in Matlab integrated fashion.
%
% *October 22. 2020*
%
% Tobias Wulf added TDK TAS2141 TMR characterization to the project. Thorben
% Schüthe provided a raw dataset which was manually modified by Tobias Wulf to
% dataset which is plotable and reconstructable in stimulus and characterization
% field investigations.
%
% *October 31. 2020*
%
% Tobias Wulf establish a general configuration flow to control part of software
% via config file which is part loaded as needed into workspace.
%
% *November 29. 2020*
%
% Tobias Wulf finished the implementation of sensor array simulation which uses
% TDK TAS2141 as base of simualtion. The software includes now simualtion for
% situmuls magnet (dipole sphere) and automated way fast generate training and
% test datasets by set configuration. Various plots and animation for datasets
% and a best practice workflow for simulation. Also included are unittest and
% Matlab integrated documentation in html files. A full description of generated
% datasets is included too.
%
%
% Created on September 21. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on December 03. 2020 by Tobias Wulf: Add roadmap description up simulation.
% -->
% </html>
%
