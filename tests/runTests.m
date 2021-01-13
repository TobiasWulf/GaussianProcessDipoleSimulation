%% runTests
%

% clean workspace
clearvars;

% build suite from test files
suite = testsuite({'removeFilesFromDirTest', 'rotate3DVectorTest', ...
    'generateDipoleRotationMomentsTest', ...
    'generateSensorArraySquareGridTest', ...
    'computeDipoleH0NormTest', ...
    'computeDipoleHFieldTest', ...
    'tiltRotationTest'});

% run tests
results = run(suite);

% show results 
disp(results)
disp(table(results))
cd ..
