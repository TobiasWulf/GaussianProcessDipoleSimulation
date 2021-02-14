%% predDS
% Predict all angles in test dataset
%
%
%% Syntax
%   outputArg = functionName(positionalArg)
%   outputArg = functionName(positionalArg, optionalArg)
%
%
%% Description
% *outputArg = functionName(positionalArg)* detailed use case description.
%
% *outputArg = functionName(positionalArg, optionalArg)* detailed use case
% description.
%
%
%% Examples
%   Enter example matlab code for each use case.
%
%
%% Input Argurments
% *positionalArg* argurment description.
%
% *optionalArg* argurment description.
%
%
%% Output Argurments
% *outputArg* argurment description.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: None
% * MAT-files required: None
%
%
%% See Also
% * Reference1
% * Reference2
% * Reference3
%
%
% Created on Month DD. YYYY by Creator. Copyright Creator YYYY.
%
% <html>
% <!--
% Hidden Clutter.
% Edited on Month DD. YYYY by Editor: Single line description.
% -->
% </html>
%
function [fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS)
    
    % get number of angles in dataset
    N = TestDS.Info.UseOptions.nAngles;
    
    % allocate memory for results
    fang = zeros(N, 1); % angle
    frad = zeros(N, 1); % radius
    fcos = zeros(N, 1); % cosine
    fsin = zeros(N, 1); % sine
    fcov = zeros(N, 1); % predictive covariance over radius
    s = zeros(N, 1); % sigma standard deviation over radius
    ciang = zeros(N, 2); % confidence 95% interval over angles lower and upper 
    cirad = zeros(N, 2); % confidence 95% interval over raidus lower and upper 
    
    % predict angle by angle from dataset
    for n = 1:N
        % get cosine and sine at n-th angle
        Xcos = TestDS.Data.Vcos(:,:,n);
        Xsin = TestDS.Data.Vsin(:,:,n);
        
        % predict frame
        [fang(n), frad(n), fcos(n), fsin(n), ...
         fcov(n), s(n), ciang(n,:), cirad(n,:)] = predFrame(Mdl, Xcos, Xsin);
    end
end