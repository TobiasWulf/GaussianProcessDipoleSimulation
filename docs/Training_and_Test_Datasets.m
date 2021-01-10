%% Training and Test Datasets
% Training and test datasets are generated by sensor array simulation part of
% the software. One dataset contains the simulation results generated with
% current configuration of used magnet in simulation and a setup of position and
% sensor behavior. The simulation computes for configured angles with certain
% angle resultion the magnetic field strength at sensor array member position
% for a rotation of the magnet through the configured angles. With respect to
% positions and angles the simulation maps the field strength for each array
% member to specified characterization field (current TDK Rise) and interpolates
% (nearest neighbor) the sensor bridge output voltages for cosine and sine
% bridge for each sensor array member. The acquired data is saved in matrices
% with same orientation as sensor array member matrice or coordinate matrices
% of the sensor array, so it completes the rotation in related data matrices.
%
% *Training and test datasets filenames are build by a certain pattern.*
%
% [Training|Test]_YYYY-mm-dd-_HH-MM-SS-FFF.mat
%
% They are saved under data path data/training and data/test.
%
% A best practice can been seen in workflow topic of the documentation.
%
%
%% Dataset Structure
% *Info:*
%
% A training ot test dataset is separated into two main structures the first one
% the Info struct contains information about the simulation configuration and
% setup in which the simulation constructed the dataset.
%
% * *SensorArrayOptions* - struct, contains setting of sensor size and behavior
% * *DipoleOptions* - struct, contains setting of used magnet which was used in
%   the simulation
% * *UseOptions* - struct, contains information about use of the dataset if it
%   is constructed for training or test use, sensor array position, number of
%   angles, tilt of magnet and so on.
% * CharData - string, identifies the characteriazation data set which was used
%   to simulate the array members.
% * *Units* - struct, si units of data in datasets
% * filePath - string, which points on the absolute path origin where the
%   dataset was saved including filename.
%
% * *SensorOptions:*
%
% * geometry - char, indentifier string of which shape the sensor array
%   geometry was constructed, geometry of used meshgrid in computation
% * dimension - double, number of sensors at one array edge for square geometry
% * edge - double, edge lenght in mm of sensor array
% * Vcc - double,  supply voltage of the sensor array
% * Voff - double, bridge offset voltage off the sensor array
% * Vnorm - double, norm value to get voltage values from characterization
%   fields in combination with Vcc and Voff, TDK dataset is normed in mV/V.
% * SensorCount, double - number of sensors in the sensor array for square
%   geometry it is square or dimension
%
% * *DipoleOptions:*
%
% * sphereRadius - double, radius in mm around dipole magnet to approximate a
%   spherical magnet in simulation with far field approximation (dipole field
%   equation)
% * H0mag - double, field strenght magnitude in kA/m which is imprinted on the
%   compute field strength of the used magnet in a certain distance from magnet
%   surface to construct magnet with fitting characteristics for simulation.
% * z0 - double, distance from surface in which H0mag is imprinted on field
%   computed field strength of the used magnet. Imprinting respects magnet tilts
%   so the distance is always set to the magnet z-axis with no shifts in x and y
%   direction
% * M0mag - double, magnetic dipole moment magnitude which is used to define the
%   magnetization direction of the magnet in tis rest position.
%
% * *UseOptions:*
%
% * useCase - string, identifies the dataset if it is for training or test
%   purpose
% * xPos - double, relative sensor array position to magnet surface
% * yPos - double, relative sensor array position to magnet surface
% * zPos - double, relative sensor array position to magnet surface
% * tilt - double, magnet tilt in z-axis
% * angleRes - double, angle resolution of rotation angles in simulation
% * phaseIndex - double, start phase of rotation as index of full scale rotation
%   angles with angleRes
% * nAngles - double, number of rotation angles in datasets
% * BaseReference - char, identifier which characterization dataset was loaded
% * BridgeReference - char, identifier which reference from characteriazation
%   dataset was used to generate cosine and sine voltages
%
% * *Units:*
%
% * SensorOutputVoltage - char, si unit of sensor bridge outputs
% * MagneticFieldStrength - char, si unit of magnetic field strength
% * Angles - char, si unit of angles
% * Length - char, si unit of metric length
%
% *Data:*
%
% * HxScale - 1 x L double vector of Hx field strength amplitudes used in
%   charcteriztion to construct sensor characterization references, x scale for
%   characterization reference
% * HyScale - 1 x L double vector of Hy field strength amplitudes used in
%   charcteriztion to construct sensor characterization references, y scale for
%   characterization reference
% * VcosRef - L x L double matrix of cosine bridge characterization field
%   corresponding to HxScale and HyScale
% * VsinRef - L x L double matrix of sine bridge characterization field
%   corresponding to HxScale and HyScale
% * Gain - double, scalar gain factor for bridge outputs (interanl
%   amplification)
% * r0 - 3 x 1 double vector of magnet rest position from magnet surface and
%   respect to magnet magnet tilt, used in computation of H0norm to imprint a
%   certain field strength on magnets H-field, respects sphere radius of magnet
% * m0 - 3 x 1 vector of magnetic dipole moment in magnet rest position with
%   respect of manget tilt, used to compute H0norm to imprint a certain field
%   strength on magnet H-field, the magnitude of this vector is equal to M0mag
% * H0norm - double, scalar factor to imprint a certain field strength on magnet
%   H-field in rest position with respect to magnet tilt in coordinate system
% * m - 3 x M double vector of magnetic dipole rotation moments each 3 x 1
%   vector is related to i-th rotation angle
% * angles - 1 x M double vector of i-th rotation angles in degree
% * angleStep - double, scalar of angle step width in rotation
% * angleRefIndex - 1 x M double vector of indices which refer to a full scale
%   rotation of configure angle resuolution, so it abstracts a subset angle
%   rotation to the same rotation with all angles given by angle resolution
% * X - N x N double matrix of x coordinate positions of each sensor array
%   member
% * Y - N x N double matrix of y coordinate positions of each sensor array
%   member
% * Z - N x N double matrix of z coordinate positions of each sensor array
%   member
% * Hx - N x N x M double matrix of compute Hx-field strength at each sensor
%   array member position for each rotation angle 1...M 
% * Hy - N x N x M double matrix of compute Hy-field strength at each sensor
%   array member position for each rotation angle 1...M 
% * Hz - N x N x M double matrix of compute Hz-field strength at each sensor
%   array member position for each rotation angle 1...M 
% * Habs - N x N x M double matrix of compute H-field strength magnitude at each
%   sensor array member position for each rotation angle 1...M 
% * Vcos - N x N x M double matrix of computed cosine bridge outputs at each
%   sensor array member position for each rotation angle 1...M
% * Vsin - N x N x M double matrix of computed sine bridge outputs at each
%   sensor array member position for each rotation angle 1...M
%
%
%% See Also
% * <Simulation_Workflow.html Simulation Workflow>
% * <sensorArraySimulation.html sensorArraySimulation>
% * <simulateDipoleSensorArraySquareGrid.html simulateDipoleSensorArraySquareGrid>
% * <generateSimulationDatasets.html generateSimulationDatasets>
% * <generateConfigMat.html generateConfigMat>
%
%
% Created on December 03. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on December 03. 2020 by Tobias Wulf: Add UseOption field BaseReference.
% Edited on December 05. 2020 by Tobias Wulf: Add Gain for reference voltages.
% -->
% </html>
%
%