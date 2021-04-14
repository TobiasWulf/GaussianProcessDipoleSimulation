%% predDS
% Predicts all frames of a test dataset at once.
%
%
%% Syntax
%   [fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS)
%   predicts whole dataset at once using predFrame in a loop.
%
%
%% Description
% *[fang, frad, fcos, fsin, fcov, s, ciang, cirad] = predDS(Mdl, TestDS)* 
%
%
%% Input Argurments
% *Mdl* model struct.
%
% *TestDS* struct of loaded test dataset.
%
%
%% Output Argurments
% *fang* vector of computed angle by predicted cosine and sine results.
%
% *frad* vector of computed radius by predicted cosine and sine results.
%
% *fcos* vector of predictive mean result of cosine regression.
%
% *fsin* vector of predictive mean result of sine regression.
%
% *fcov* vector of predictive variance for both predictive means.
%
% *s* vector of resulting standard deviation by predictive variance and noise level.
%
% *ciang* vector of confidence interval of computed angle.
%
% *cirad* vector of confidence interval of computed radius.
%
%
%% Requirements
% * Other m-files required: None
% * Subfunctions: predFrame
% * MAT-files required: None
%
%
%% See Also
% * <predFrame.html predFrame>
% * <Training_and_Test_Datasets.html Training and Test Datasets>
%
%
% Created on March 03. 2021 by Tobias Wulf. Copyright Tobias Wulf 2021.
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