%%% 
% <html><h1>removeFilesFromDirTest</h1></html>
%

% create test directory with files
cd(fileparts(which('removeFilesFromDirTest')));
mkdir('testDir');
fclose(fopen(fullfile('testDir', 'testFile1.txt'), 'w')); 
fclose(fopen(fullfile('testDir', 'testFile2.txt'), 'w')); 
fclose(fopen(fullfile('testDir', 'testFile3.txt'), 'w')); 

%% Test 1: delete all files
removeStatus = removeFilesFromDir(fullfile('testDir'));
assert(removeStatus == true)

% create more files
fclose(fopen(fullfile('testDir', 'testFile1.txt'), 'w')); 
fclose(fopen(fullfile('testDir', 'testFile2.txt'), 'w')); 
fclose(fopen(fullfile('testDir', 'testFile3.txt'), 'w')); 

%% Test 2: delete with pattern
removeStatus = removeFilesFromDir(fullfile('testDir'), '*.txt');
assert(removeStatus == true)

% clean up
rmdir('testDir');
