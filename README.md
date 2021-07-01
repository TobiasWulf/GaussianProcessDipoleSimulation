# GaussianProcessDipoleSimulation
This very software project is written during my bachelor thesis. I wrote my thesis at The University of Applied Science Hamburg under supervision of
Prof. Dr.-Ing. Karl-Ragmar Riemschneider and Prof. Dr. Klaus Jünemann. The work supports the Integrated Sensor Array Project and 
the Phd. thesis of M.Sc Thorben Schüthe. 

## Theme
Angular Measurement by Magnetic Sensor Arrays and Tolerance Compensation by Gaussian Process

## Abstract
This bachelor thesis covers the construction and improvement of simulation software and models for the physical simulation of a tunnel magnetoresistive Sensor
Array as well as the mathematical simulation of an associated evaluating ASIC model. The mathematical ASIC model for the evaluation of the Sensor Srray simulation 
data is based on a regression method for Gaussian Processes. In preliminary work, basic principles for the physical and mathematical simulation of the models have 
been created, which will be combined into a modular software within the scope of this work. Furthermore, the mathematical ASIC model will be further optimized and 
improved with respect to model resources and machine learning capability, and supplemented by algorithms for model optimization. Finally, experiments on the 
functionality, model optimization and tolerance compensation capability of the overall system are carried out in this thesis.

## Keywords
Sensor Array Simulation, Dipole, Magnetic Field, Sperical Magnet Approximation, TMR, TDK TAS2141, AMR, NXP KMZ60, Tolerance Compensation, Gaussian Processes, 
Covariance, Covariance Matrix, Regression, Angular Prediction, Logarithmic Marginal Likelihood, Standardized Logarithmic Loss, Minimization, Optimization, ASIC 
Model

## Requirements
Matlab R2020b or newer.

## First Get Instructions
1. Clone the repositoy or download the zip file and extract local.
2. Open Matlab in the top level project directory.
3. In Matlab open the software project via Open > GaussianProcessDipoleSimulation.prj.
4. The Matlab project initialized itself and runs the configration script at start up which setups the environment
5. Run the script publishProjectFilesToHTML.m and exportPublishToPdf.m to get a fresh update of docs. Project docs should be although available under suplemental software in the Matlab help. Say no if you will be asked to rebuild the equations. It is not necessary at this step.
6. Under the project shortcuts tab you find all executable scripts and functions.
7. Look at Workflows chapter in the documentation for more instructions.
8. But for fast start up just execute generateSimulationDatasets.m and demoGPRModule.m afterwards.
9. Have fun!

## Fork Instructions
If you want to test just clone the project as mentioned before please. Otherwise:
1. Make a fork on GitHub.
2. Use the standard Git Fork Flow.
3. Make your changes and commit locally.
4. Push your changes into your fork of the project.
5. Make a pull request on your changes.
6. We will discuss it and apply it if it is reasonable.
7. Thank you in advanced!

## Get an Idea
Here comes the key point of this simualtion software in short with some supporting graphics:

**1. We got a Sensor Array which measures angles encdoded by a magnet.**



<img src=docs/latex/BA_Thesis_Tobias_Wulf/thesis/chapters/images/2-Grundlagen/Sensor-Array-Prinzip.svg width="600">



**2. The magnet rotates and each Sensor Array Pixel records the rotaion but it gets distortion by different influences.**



<img src=docs/latex/BA_Thesis_Tobias_Wulf/thesis/chapters/images/4-EuOExp/Kombinierte-Fehllagen-Sensor.svg width="600">



**3. The algorithms which are based on gaussian process for regression wrangle that records and adjust them for a correct angle response of the magnets likeli rotation position.**



<img src=docs/latex/BA_Thesis_Tobias_Wulf/thesis/chapters/images/4-EuOExp/Kombinierte-Fehllagen-GPR.svg width="600">


**4. How good the correction works depends on a bunch of parameter and environment variables. Physics. If its in range the sensor is able to adjust itself and has the capabilities for a Self-X sensor as machine learning approach.**



<img src=docs/latex/BA_Thesis_Tobias_Wulf/thesis/chapters/images/4-EuOExp/QFCAPX-Z-N17-Bounds.svg width="600">


For a deeper understandig please read the thesis. Thank you. Please excuse the main part is written in German but the software documentation is done in English.

Best regards,

Tobias Wulf


## Project Roadmap
The project of sensor array simulations and Gaussian Processes for angle
predictions on simulation datasets started in

**May 06. 2019**

with IEEE paper by Thorben Schüthe which is a base investigation of
"Two-Dimensional Characterization and Simplified Simualtion Procedure for
Tunnel Magnetorersistive Angle Sensors". This produces characterization
datasets of different current available angular sensors on the market.

**June 11. 2019**

Thorben Schüthe came up with a high experimental scripting for abstracting
sensor characterization fields to an array of sensor fields which was
stimulated by magnetic dipole field equautions to approximate a spherical
magnet.

**November 06. 2019**

Prof. Dr. Klaus Jünemann supports the team around Prof. Dr.-Ing. Karl-Ragmar
Riemschneider and Thorben Schüthe with an apply of Gaussian Process learning
to investigate on angle predictions for sensor array simualtion results. The
attempt of the solution was working for tight set of parameter and was highly
experimental with rare documentation and few set of functions and scripts. The
math of this very solution based on the standard book for Gaussian Process by
Williams and Rasmussen. The algorithm is related to the guidline for linear
regression model which worked fine for a setup of standard use cases but
needed further investigation for a wider set of parameters and functions to
identify general and relevant parameter settings to provide an applicable
angular prediction.

**September 21. 2020**

Tobias Wulf establish a Matlab project structure and programming guidance and
flows to document the source code integrated in the Matlab project
architecture. That includes templating for scripts and functions and general
descriptions of project structure and guidance for testing and documenting
project results or new source code including automation for publishing html
in Matlab integrated fashion.

**October 22. 2020**

Tobias Wulf added TDK TAS2141 TMR characterization to the project. Thorben
Schüthe provided a raw dataset which was manually modified by Tobias Wulf to
dataset which is plotable and reconstructable in stimulus and characterization
field investigations.

**October 31. 2020**

Tobias Wulf establish a general configuration flow to control part of software
via config file which is partly loaded as needed into workspace.

**November 29. 2020**

Tobias Wulf finished the implementation of sensor array simulation which uses
TDK TAS2141 as base of simualtion. The software includes now simulation for
situmulus magnet (dipole sphere) and automated way fast generate training and
test datasets by set configuration. Various plots and animation for datasets
and a best practice workflow for simulation. Also included are unittest and
Matlab integrated documentation in html files. A full description of generated
datasets is included too.

**December 05. 2020**

Tobias Wulf integrated a second characterization dataset for NXP KMZ60 into
the sensor array simulation software. The dataset was manually modified in the
same way as the TDK TAS2141 dataset. The KMZ60 raw data was provided from
Thorben Schüthe. The simulation software was adjusted to run with both
datasets now. Additional plots for transfer curves are included for both and
same plots for characterization view of KMZ60 as for TAS2141 too.

**April 01. 2021**

Tobias Wulf integrated GPR algorithms made by Klaus Jünemann as
gaussianProcessRegression modul. Additionaly a second kernel was implemented
based on the first one by Jünemann. The implementation was transfered from a
functional and script based draft version of GPR mechanism into fully
initialized model based version which loads needed functionality and
parameters into a struct. So prediction and optimization algorithms are
working on a structured model frame. Missing model optimization is added to
fit model on training data and generalize it to test data. Interface to Sensor
Array simulations are done by work on datasets.
