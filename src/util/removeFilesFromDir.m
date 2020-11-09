%% removeFilesFromDir
% Remove files from passed direcotory.
%
%% Syntax
%   removeStatus = removeFilesFromDir(directory)
%   removeStatus = removeFilesFromDir(directory, filePattern)
%
%
%% Description
% *removeStatus = removeFilesFromDir(directory)* removes all files that are
% located in the passed directory and returns a logical 1 if the operation was
% successful or 0 if not. The directory argument must be char vector of 1xN and
% valid path to a existing directory.
%
% *removeStatus = removeFilesFromDir(directory, filePattern)* removes all files
% in the located directory which matches the passed file pattern. The
% filePattern argument must be be char vector of 1xN. It is an optional argument
% with a default value of '*.*', valid file patterns can be filenames which part
% replace names by * character before the dot and exisiting file extensions e.g.
% myfile_*.m or *.txt and so on.
%
%
%% Examples
%   d = fullfile('rootPath', 'subfolder')
%   rs = removeFileFromDir(d)
%
%   d = fullfile('rootPath', 'subfolder')
%   rs = removeFileFromDir(d, '*.mat')
%
%
%% Input Arguments
% *directory* char vector, path directory in which to scan for files with
% file pattern and to delete found files.
%
% *filePattern* char vector of file pattern with extension. Default is *.* to
% delete all files. Possible patterns can be e.g. *.m or *part_name_*.* or
% *_part_name_*.png.
%
%
%% Output Arguments
% *removeStatus* locgical scalar which is true if all files wich matches the
% file pattern are deleted successfully from passed directory path.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/fullfile.html')) fullfile>
% * <matlab:web(fullfile(docroot,'matlab/ref/dir.html')) dir>
% * <matlab:web(fullfile(docroot,'matlab/ref/delete.html')) delete>
% * <matlab:web(fullfile(docroot,'matlab/ref/isfile.html')) isfile>
% * <matlab:web(fullfile(docroot,'matlab/ref/isempty.html')) isempty>
% * <matlab:web(fullfile(docroot,'matlab/ref/double.ismember.html')) ismember>
% * <matlab:web(fullfile(docroot,'matlab/ref/mustbefolder.html')) mustBeFolder>
% * <matlab:web(fullfile(docroot,'matlab/ref/mustbetext.html')) mustBeText>
%
%
% Created on October 10. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% Edited on October 11. 2020 by Tobias Wulf: Tested with R2020b.
% -->
% </html>
% 
function [removeStatus] = removeFilesFromDir(directory, filePattern)
    arguments
        % validate directory
        directory (1,:) char {mustBeFolder}
        % validate filePattern
        filePattern (1,:) char {mustBeText} = '*.*'
    end
    % parse pattern for dir
    parsePattern = fullfile(directory, filePattern);
    % parse directory, returns struct        
    filesToRemove = dir(parsePattern);
    % delete files, tranpose to loop through struct
    for file = filesToRemove'
        % check before delete
        filePath = fullfile(file.folder, file.name);
        if isfile(filePath)
            delete(filePath);
        end
    end
    % check if dir returns an empty struct now
    check = dir(parsePattern);
    removeStatus = isempty(check(~ismember({check.name}, {'.', '..'})));
end
