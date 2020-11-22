%% sensorArraySimulation
% A spherical magnet is assumed to be used for stimulation of the sensor array.
% The far field of a spherical magnet can be approximately described by the
% magnetic field of a magnetic dipole. The magnetization of the sphere is
% assumed to be in y direction and the magnetic moment in rest position for 0°
% points in x direction. The magnet must be defined in a way that its field
% lines or field strengths own gradients sufficiently strong enough in the
% distance to the sensor array and so the rotation of the magnet generates a
% small scattering of the bridge outputs in the individual sensor points in the
% array. That  all sensors in the array approximately perceive the same magnetic
% field gradients of the current rotation step and the sensors in the array run
% through approximately  equal circular paths in the characterization field.
% This means the sperical magnet is characterized by a favorable mating of
% sphere radius and a certain distance in rest position in which a sufficiently
% high field strength takes effect. Here are neglected small necessary distances
% which are demanded in standard automotive applications. The focus here is on
% to generate simulation datasets, which are uniform and valid for angle
% detection. The modelling of suitable small magnets is not taking place of
% the work.
%
% <html>
% <img src="images/dipole_magnet.svg" height=650>
% </html>
%
%
%% computeDipoleHField
% Compute dipole field strength for meshgrids with additional abillity to
% imprint a certain field strength in defined radius on resulting field.  
%
%% computeDipoleH0Norm
% Compute a norm factor to imprint a magnetic field strength to magnetic dipole
% fields with same magnetic moment magnitude and constant dipole sphere radius
% on which the imprinted field strengt takes effect.
%
%
%% generateSensorArraySquareGrid
% Generat a square sensor array grid in a 3D coordinate system with
% relative position to center of the system and an additional offset in z
% direction.
%
%
%% generateDipoleRotationMoments
% Generate magnetic rotation moments to rotate a magnetic dipol in its z-axes
% with a certain tilt.
%
%
%% rotate3DVector
% Rotate a vector with x-, y- and z-components in a 3D-coordinate system. Rotate
% one step of certain angles.
%
%
% Created on November 04. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on November 04. 2020 by Tobias Wulf: Add rotate3DVector.
% Edited on November 06. 2020 by Tobias Wulf: Add generateDipoleRotationMoments.
% Edited on November 22. 2020 by Tobias Wulf: Add dipole computation functions.
% -->
% </html>
%