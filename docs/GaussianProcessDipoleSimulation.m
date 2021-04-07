%% GaussianProcessDipoleSimulation
% The project of sensor array simulations and Gaussian Processes for angle
% predictions on simulation datasets started in
%
% *May 06. 2019*
%
% with IEEE paper by Thorben Schüthe which is a base investigation of
% "Two-Dimensional Characterization and Simplified Simualtion Procedure for
% Tunnel Magnetorersistive Angle Sensors". This produces characterization
% datasets of different current available angular sensors on the market.
%
% *June 11. 2019*
%
% Thorben Schüthe came up with a high experimental scripting for abstracting
% sensor characterization fields to an array of sensor fields which was
% stimulated by magnetic dipole field equautions to approximate a spherical
% magnet.
%
% *November 06. 2019*
%
% Prof. Dr. Klaus Jünemann supports the team around Prof. Dr.-Ing. Karl-Ragmar
% Riemschneider and Thorben Schüthe with an apply of Gaussian Process learning
% to investigate on angle predictions for sensor array simualtion results. The
% attempt of the solution was working for tight set of parameter and was highly
% experimental with rare documentation and few set of functions and scripts. The
% math of this very solution based on the standard book for Gaussian Process by
% Williams and Rasmussen. The algorithm is related to the guidline for linear
% regression model which worked fine for a setup of standard use cases but
% needed further investigation for a wider set of parameters and functions to
% identify general and relevant parameter settings to provide an applicable
% angular prediction.
%
% *September 21. 2020*
%
% Tobias Wulf establish a Matlab project structure and programming guidance and
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
% via config file which is partly loaded as needed into workspace.
%
% *November 29. 2020*
%
% Tobias Wulf finished the implementation of sensor array simulation which uses
% TDK TAS2141 as base of simualtion. The software includes now simulation for
% situmulus magnet (dipole sphere) and automated way fast generate training and
% test datasets by set configuration. Various plots and animation for datasets
% and a best practice workflow for simulation. Also included are unittest and
% Matlab integrated documentation in html files. A full description of generated
% datasets is included too.
%
% *December 05. 2020*
%
% Tobias Wulf integrated a second characterization dataset for NXP KMZ60 into
% the sensor array simulation software. The dataset was manually modified in the
% same way as the TDK TAS2141 dataset. The KMZ60 raw data was provided from
% Thorben Schüthe. The simulation software was adjusted to run with both
% datasets now. Additional plots for transfer curves are included for both and
% same plots for characterization view of KMZ60 as for TAS2141 too.
%
% *April 01. 2021*
%
% Tobias Wulf integrated GPR algorithms made by Klaus Jünemann as
% gaussianProcessRegression modul. Additionaly a second kernel was implemented
% based on the first one by Jünemann. The implementation was transfered from a
% functional and script based draft version of GPR mechanism into fully
% initialized model based version which loads needed functionality and
% parameters into a struct. So prediction and optimization algorithms are
% working on a structured model frame. Missing model optimization is added to
% fit model on training data and generalize it to test data. Interface to Sensor
% Array simulations are done by work on datasets.
%
% Created on September 21. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on April 07. 2021 by Tobias Wulf: Last edit description.
% -->
% </html>
%
