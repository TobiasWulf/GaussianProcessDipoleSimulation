%% predDS
% Predict all angles in test dataset
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