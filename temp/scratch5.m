
clear all
close all

%load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-04-03_11-21-41-896.mat')
%load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-04-03_00-24-08-574.mat')
%load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-04-03_00-23-56-590.mat')
%load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-04-02_23-16-01-193.mat')
%load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-04-02_23-11-08-644.mat')
load('/home/tobias/Documents/workspace/matlab/GaussianProcessDipoleSimulation/data/test/Test_2021-03-19_11-21-59-990.mat')
VC = Data.Vcos-Info.SensorArrayOptions.Voff;
VS = Data.Vsin-Info.SensorArrayOptions.Voff;
a360 = Data.angles;

i1 = a360 >= 0 & a360 < 45;
i2 = a360 >= 45 & a360 < 90;
i3 = a360 >= 90 & a360 < 135;
i4 = a360 >= 135 & a360 < 180;
i5 = a360 >= 180 & a360 < 225;
i6 = a360 >= 225 & a360 < 270;
i7 = a360 >= 270 & a360 < 315;
i8 = a360 >= 315 & a360 < 360;

% m0 = [0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0
%       0 0 0 0 0 0 0 0];
% m0 = logical(m0);

m1 = [0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];
m1 = logical(m1);
  
m2 = [1 1 0 0 0 0 1 1
      1 1 0 0 0 0 1 1
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      1 1 0 0 0 0 1 1
      1 1 0 0 0 0 1 1];
m2 = logical(m2);

m3 = [0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];
m3 = logical(m3);

m4 = [0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0
      0 0 1 1 1 1 0 0];
m4 = logical(m4);

m5 = [0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      1 1 1 1 0 0 0 0
      1 1 1 1 0 0 0 0
      1 1 1 1 0 0 0 0
      1 1 1 1 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];
m5 = logical(m5);

m6 = [0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0
      0 0 0 0 1 1 1 1
      0 0 0 0 1 1 1 1
      0 0 0 0 1 1 1 1
      0 0 0 0 1 1 1 1
      0 0 0 0 0 0 0 0
      0 0 0 0 0 0 0 0];
m6 = logical(m6);

C = sum(VC,3);
S = sum(VS,3);

C1 = sum(C(m1))/720/16;
S1 = sum(S(m1))/720/16;
R1 = sqrt(C1^2 + S1^2);
T1 = direcT(S1,C1);

C2 = sum(C(m2))/720/16;
S2 = sum(S(m2))/720/16;
R2 = sqrt(C2^2 + S2^2);
T2 = direcT(S2,C2);

C3 = sum(C(m3))/720/16;
S3 = sum(S(m3))/720/16;
R3 = sqrt(C3^2 + S3^2);
T3 = direcT(S3,C3);

C4 = sum(C(m4))/720/16;
S4 = sum(S(m4))/720/16;
R4 = sqrt(C4^2 + S4^2);
T4 = direcT(S4,C4);

C5 = sum(C(m5))/720/16;
S5 = sum(S(m5))/720/16;
R5 = sqrt(C5^2 + S5^2);
T5 = direcT(S5,C5);

C6 = sum(C(m6))/720/16;
S6 = sum(S(m6))/720/16;
R6 = sqrt(C6^2 + S6^2);
T6 = direcT(S6,C6);

figure;
f1 = polaraxes;
thetaticks([0 45 90 135 180 225 270 315])
hold on

polarscatter(T1,R1, 'filled');
polarscatter(T2,R2, 'filled');
polarscatter(T3,R3, 'filled');
polarscatter(T4,R4, 'filled');
polarscatter(T5,R5, 'filled');
polarscatter(T6,R6, 'filled');

legend('Center', 'Corner', 'North', 'South', 'West', 'East')

figure;
f2 = polaraxes;
polarhistogram(unwrap(atan2(VS(:),VC(:))),16)

function T = direcT(S,C)
    if C > 0 
        if S > 0
            T = atan(S/C);
        else
            T = atan(S/C) + 2*pi;
        end
    else
        T = atan(S/C) + pi;
    end
end