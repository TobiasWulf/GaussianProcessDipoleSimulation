% build suite from test files
suite = testsuite({'removeFilesFromDirTest', 'rotate3DVectorTest', ...
    'generateDipoleRotationMomentsTest'});

% run tests
results = run(suite);

% show results 
disp(results)
disp(table(results))
