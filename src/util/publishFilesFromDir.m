%% publishFilesFromDir
% Publish m-files from given directory with passed publishing options.
%
%% Syntax
%   publishFilesFromDir(directory, PublishOptions)
%   publishFilesFromDir(directory, PublishOptions, recursivly)
%   publishFilesFromDir(directory, PublishOptions, recursivly, verbose)
%
%
%% Description
% *publishFilesFromDir(directory, PublishOptions)* publish m-files wich are
% located in the passed directory with options from passed publishing options
% struct which is must be strictly formatted after given example from Matlab
% documentation.
%
% *publishFilesFromDir(directory, PublishOptions, recursive)* publishing like
% described before but scan the directory recursively for m-files. Default is
% false for do not recursively.
%
% *publishFilesFromDir(directory, PublishOptions, recursive, verbose)* with
% optional verbose set to true the published html files will be displayed in the
% prompt. Default is false.
%
%
%% Examples
%   directory = 'src';
%   PublishOptions = struct;
%   PublishOptions.outputDir = 'src/html';
%   PublishOptions.evalCode = false;
%   publishFilesFromDir(directory, PublishOptions, true)
%
%   load('config.mat', 'srcPath', 'PublishOptions')
%   publishFilesFromDir(srcPath, PublishOptions, true, true)
%
%
%% Input Arguments
% *directory* char vector, path to directory where m-files are located to
% publish.
%
% *PublishOptions* struct which contains publishing options for the Matlab
% publish function.
%
% *recursive* logical scalar which directs the function to scan recursively for
% m-files in passed directory if true. Default is false.
%
% *verbose* logical scalar which determines to display the filenames and path to
% published file if true. Default is false.
%
%
%% Output Arguments
% *None*
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * <matlab:web(fullfile(docroot,'matlab/ref/dir.html')) dir>
% * <matlab:web(fullfile(docroot,'matlab/ref/fullfile.html')) fullfile>
% * <matlabl:web(fullfile(docroot,'matlab/ref/publish.html')) publish>
%
%
% Created on October 31. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function publishFilesFromDir(directory, PublishOptions, recursive, verbose)
    arguments
        % validate directory if exist
        directory (1,:) char {mustBeFolder}
        % validate Publish options if it is a struct
        PublishOptions (1,1) struct {mustBeA(PublishOptions, ["struct"])}
        % validate recursive if logical
        recursive (1,1) logical {mustBeNumericOrLogical} = false
        verbose (1,1) logical {mustBeNumericOrLogical} = false
    end
    
    % file extension is alway m-file
    ext = '*.m';
    
    % reursive parsing for files with dir function needs a certain regex
    if recursive
        pathPattern = fullfile(directory, '**', ext);
    else
        pathPattern = fullfile(directory, ext);
    end
    
    % scan directory for files returns a column struct with path fields
    files = dir(pathPattern);
    
    % transpose files struct and loop through for publish
    for file = files'
        %  if not dir must be file
        if ~file.isdir
            % build path by struct field for recursive tree
            written = publish(fullfile(file.folder, file.name), PublishOptions);
            if verbose
                disp(written);
            end
        end
    end
end

