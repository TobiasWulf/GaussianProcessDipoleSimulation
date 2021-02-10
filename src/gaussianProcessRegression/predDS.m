%% predDS
% Predict all angles in test dataset
%
function [fang, frad, fcov, s, ci, fcos, fsin] = predDS(Mdl, TestDS, rad)
    
    % get number of angles in dataset
    N = TestDS.Info.UseOptions.nAngles;
    
    % allocate memory for results
    fang = zeros(N, 1); % angle
    frad = zeros(N, 1); % radius
    fcov = zeros(N, 1); % predictive covariance over radius
    s = zeros(N, 1); % sigma standard deviation over radius
    ci = zeros(N, 2); % confidence 95% interval over raidus lower and upper 
    fcos = zeros(N, 1); % cosine
    fsin = zeros(N, 1); % sine
    
    % predict angle by angle from dataset
    for n = 1:N
        % get cosine and sine at n-th angle
        Xcos = TestDS.Data.Vcos(:,:,n);
        Xsin = TestDS.Data.Vsin(:,:,n);
        
        % predict frame
        [fang(n), frad(n), fcov(n), s(n), ci(n,:), fcos(n), fsin(n)] = ...
            predFrame(Mdl, Xcos, Xsin, rad);
    end
end