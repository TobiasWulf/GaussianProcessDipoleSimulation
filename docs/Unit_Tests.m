%% Unit Tests
% Unit Tests are provideing way to test core functionallity of the written
% software components. Matlab supports various methods to apply Unit Tests.
% The designed tests are using script-based testing. So for each function
% or functionallity needs to be tested a own test script is written and
% gathered into a main test script where all standalone test scripts are
% combined to a test suite and executed at once.
%
%
%% runTests
% Test suite script which executes all Unit Tests scripts at once and
% gathers the test results in a Matlab table.
%
%
%% removeFilesFromDirTest
% Test of function removeFilesFromDir. Creates several files and
% directories and deletes them during testing.
%
%
%% rotate3DVectorTest
% Test rotate3DVector function. Do some rotations and check results.
%
%
%% generateDipoleRotationMomentsTest
% Test the generation of magnetic dipole moments for a full rotation
% between 0° and 360°.
%
%
%% generateSensorArraySquareGridTest
% Test the meshgrid generation of the sensor array and shifting it in x and
% y direction.
%
%
%% computeDipoleH0NormTest
% Test magnetic field norming function. Simple test of consitent data.
%
%
%% computeDipoleHFieldTest
% Test the magnetic dipole equation to generate dipole fields in 3D
% meshgrid of data points. Test field characteristics like symmetry and so
% on.
%
%
%% tiltRotationTest
% Test tilt rotation of a dipole magnetic. Tilt magnet and coordinate cross
% to fetch pole values during rotation.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/script-based-unit-tests.html?s_tid=CRUX_lftnav')) Script-Based Unit Tests>
% * <matlab:web(fullfile(docroot,'matlab/matlab_prog/write-script-based-unit-tests.html')) Write Script-Based Unit Tests>
% * <matlab:web(fullfile(docroot,'matlab/matlab_prog/write-script-based-test-using-local-functions.html')) Write Script-Based Unit Tests Using Local Functions>
% * <matlab:web(fullfile(docroot,'matlab/matlab_prog/analyze-testsolver-results.html')) Analyze Test Case Result>
%
%
% Created on December 14. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%