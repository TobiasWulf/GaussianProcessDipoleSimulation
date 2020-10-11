%% Documentation Workflow
% 
%
%% Script Template
%
%   %% scriptName
%   % Detailed description of the script task and summary description of
%   % underlaying script sections.
%   %
%   % See also:
%   %
%   % * Reference1
%   % * Reference2
%   % * Reference3
%   %
%   %
%   % Created on Month DD. YYYY by Creator. Copyright Creator YYYY.
%   %
%   % <html>
%   % <!--
%   % Hidden Clutter.
%   % Edited on Month DD. YYYY by Editor: Single line description.
%   % -->
%   % </html>
%   %
%   %
%   %% First Script Section
%   % Detailed section description of step by step executed script code.
%   disp("Prompt current step or meaningful information of variables.")
%   Enter section source code
%   
%   %% Second Script Section
%   % Detailed section description of step by step executed script code.
%   disp("Prompt current step or meaningful information of variables.")
%   Enter section source code
%
%
%% Function Template
%
%   %% functionName
%   % Single line summary.
%   %
%   %% Syntax
%   %   outputArg = functionName(positionalArg)
%   %   outputArg = functionName(positionalArg, optionalArg)
%   %
%   %
%   %% Description
%   % outputArg = functionName(positionalArg) detailed use case description.
%   %
%   % outputArg = functionName(positionalArg, optionalArg) detailed use case
%   % description.
%   %
%   %
%   %% Example
%   %   Enter example matlab code for each use case.
%   %
%   %
%   %% Requirements
%   % * Other m-files required: None
%   % * Subfunctions: None
%   % * MAT-files required: None
%   %
%   % See also:
%   %
%   % * Reference1
%   % * Reference2
%   % * Reference3
%   %
%   %
%   % Created on Month DD. YYYY by Creator. Copyright Creator 2020.
%   %
%   % <html>
%   % <!--
%   % Hidden Clutter.
%   % Edited on Month DD. YYYY by Editor: Single line description.
%   % -->
%   % </html>
%   % 
%   function [outputArg] = functionName(possitionalArg, optionalArg)
%       arguments
%           % validate possitionalArg: dim class {validator}
%           possitionalArg (1,:) double {mustBeNumeric}
%           % validate optionalArg: dim class {validator} = defaultValue
%           optionalArg (1,:) doubel {mustBeNumeric, mustBeEqualSize(positionalArg, optionalArg)} = 4
%       end
%       outputArg = positionalArg + optionalArg;
%   end
%   
%   % Custom validation function
%   function mustBeEqualSize(a,b)
%       % Test for equal size
%       if ~isequal(size(a),size(b))
%           eid = 'Size:notEqual';
%           msg = 'Size of first input must equal size of second input.';
%           throwAsCaller(MException(eid,msg))
%       end
%   end
%
%
% Created on October 10. 2020 by Tobias Wulf. Copyright Tobias Wulf 2020.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on October 10. 2020 by Tobias Wulf: Add script template.
% Edited on October 11. 2020 by Tobias Wulf: Add function template.
% -->
% </html>
%
