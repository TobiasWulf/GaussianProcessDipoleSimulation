# GaussianProcessDipoleSimulation
This very software project is written during my bachelor thesis. I wrote my thesis at The University of Applied Science Hamburg under supervision of Prof. Dr.-Ing. Karl-Ragmar Riemschneider and Prof. Dr. Klaus Jünemann. The work supports the Integrated Sensor Array Project and the Phd. thesis of M.Sc Thorben Schüthe. 

## Theme
Angular Measurement by Magnetic Sensor Arrays and Tolerance Compensation by Gaussian Process

## Abstract
This bachelor thesis covers the construction and improvement of simulation software and models for the physical simulation of a tunnel magnetoresistive Sensor Array as well as the mathematical simulation of an associated evaluating ASIC model. The mathematical ASIC model for the evaluation of the Sensor Srray simulation data is based on a regression method for Gaussian Processes. In preliminary work, basic principles for the physical and mathematical simulation of the models have been created, which will be combined into a modular software within the scope of this work. Furthermore, the mathematical ASIC model will be further optimized and improved with respect to model resources and machine learning capability, and supplemented by algorithms for model optimization. Finally, experiments on the functionality, model optimization and tolerance compensation capability of the overall system are carried out in this thesis.

## Keywords
Sensor Array Simulation, Dipole, Magnetic Field, Sperical Magnet Approximation, TMR, TDK TAS2141, AMR, NXP KMZ60, Tolerance Compensation, Gaussian Processes, Covariance, Covariance Matrix, Regression, Angular Prediction, Logarithmic Marginal Likelihood, Standardized Logarithmic Loss, Minimization, Optimization, ASIC Model

## First Get Instructions
1. Clone the repositoy or download the zip file and extract local.
2. Open Matlab in the top level project directory.
3. In Matlab open the software project via Open > GaussianProcessDipoleSimulation.prj.
4. The Matlab project initialized itself and runs the configration script at start up which setups the environment
5. Run the script publishProjectFilesToHTML.m and exportPublishToPdf.m to get a fresh update of docs. Project docs should be althoug available under suplemental software in the Matlab help. Say no if you will be asked to rebuild the equations. It is not necessary at this step.
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


For a deeper understandig please read the thesis. Thank you. Please excuse its written in german.

Best regards,

Tobias Wulf
