%%% 
% <html><h1>tiltRotationTest</h1></html>
%

% clean
clearvars;

% relevant tilt in y axes
tilt = 0.5:0.5:90;

% magnetic dipole moment to define magnet orientation, no tilt
% rotate angles theta 0°, 90°, 180°, 270°
[mNoTilt, thetaNoTilt] = generateDipoleRotationMoments(-1e6, 4, 0);

% Habs for magnetization from north to south from -x to x
HabsMust = [400 400 200 200 200 200];

% norm factor to imprint field strength in certain distance d = 1,
% r = 2 in mm, 
% 200 kA/m, no tilt
r0NoTilt = [0; 0; -3];
H0normNoTilt = computeDipoleH0Norm(200, mNoTilt(:,1), r0NoTilt); 

% axes with no tilt, rest position
AxesNoTilt = [-3, 3,  0, 0,  0, 0;
              0, 0, -3  3,  0, 0;
              0, 0,  0, 0, -3, 3];

% calc fields along coorditante cross and magnitudes
HNoTilt = zeros(3, 6, 4);
for i = 1:4
    % rotate axes same wise to check pole values
    RotateNoTiltAxes = rotate3DVector(AxesNoTilt, 0, 0, thetaNoTilt(i));
    HNoTilt(:,:,i) = computeDipoleHField(RotateNoTiltAxes(1,:), ...
        RotateNoTiltAxes(2,:), RotateNoTiltAxes(3,:), ...
        mNoTilt(:,i), H0normNoTilt);
end

% habs must be show imprinted field strength and double of it at poles
HabsNoTilt = sqrt(sum(HNoTilt.^2, 1));

% calc fields along tilt coorditante cross and magnitudes
HTilt = zeros(3, 6, 4, length(tilt));
for j = 1:length(tilt)
    % magnetic dipole moment to define magnet orientation, with tilt
    % rotate angles theta 0°, 90°, 180°, 270°
    [mTilt, thetaTilt] = generateDipoleRotationMoments(-1e6, 4, tilt(j));

    % norm factor to imprint field strength in certain distance d = 1,
    % r = 2 in mm, 
    % 200 kA/m, no tilt
    r0Tilt = rotate3DVector(r0NoTilt, 0, tilt(j), 0);
    H0normTilt = computeDipoleH0Norm(200, mTilt(:,1), r0Tilt); 

    % axes with tilt, rest position
    AxesTilt = rotate3DVector(AxesNoTilt, 0, tilt(j), 0);

    for i = 1:4
        % rotate axes same wise to check pole values
        RotateTiltAxes = rotate3DVector(AxesTilt, 0, 0, thetaTilt(i));
        HTilt(:,:,i,j) = computeDipoleHField(RotateTiltAxes(1,:), ...
            RotateTiltAxes(2,:), RotateTiltAxes(3,:), ...
            mTilt(:,i), H0normTilt);
    end
end

% habs must be show imprinted field strength and double of it at poles
HabsTilt = sqrt(sum(HTilt.^2, 1));

%% Test 1: rotation without tilt
assert(all(round(HabsNoTilt, 6) == round(HabsMust, 6), 'all'))

%% Test 2: rotation with tilt
assert(all(round(HabsTilt, 6) == round(HabsMust, 6), 'all'))
