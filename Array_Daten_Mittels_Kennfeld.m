% Magnetic field simulation with characteristic diagram of the TDK TASAAAB
% Sensor. 
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      11.06.2019
%==========================================================================
% close all
clear all 
clc 
%addpath('Functions/')   


%  TDK 
saveDat = 0;    
MTX             = load('../Gauss_Process_And_Dipole_Simulation/Array_Simulation/KEPCO_TDK_TAS2141_DifferentialVTG/TDK_TAS2141_TMR_24_July_2019_PM23kAm_256_RaiseFall_DIFFVTG.mat'); 
MTX.Fstrength   = 8;  
MTX.amplitude   = 80;   
%%
k = 1;  
clear('i','ct','n')
%% Sensor Supply Voltage and Offset Voltage
VCC     = 3.3; 
VOFF    = VCC/2;
%%
% size of the sensor array in mm 
sz          = 2; 
% Number of Array elements => NxN 
N           = 8;  

% Position of the Magnet in  x y z
shift_x     = 0; 
shift_y     = 0;  
tz          = 2;  

M.x         = meshgrid([-sz/2:sz/(N-1):sz/2]); 
M.y         = meshgrid([-sz/2:sz/(N-1):sz/2])'; 

MTX.V1.V1all     = MTX.VC.rais; 
MTX.V2.V2all     = MTX.VS.rais; 

MTX.Hx = MTX.hx; 
MTX.Hy = MTX.hy;  

[ Mfield,alpha] = genField2(M,... 
                            0,...
                            1,...
                            360,...
                            shift_x,...
                            shift_y,...
                            tz,...
                            MTX.V1 ,...
                            MTX.V2 ,...
                            MTX.Fstrength,...
                            MTX.Hx,MTX.Hy);
 
for n = 1 : length(Mfield)
    Vc(:,:,n) = reshape(Mfield(n).COS_VAL,N,N)./1e3.*VCC+VOFF; 
    Vs(:,:,n) = reshape(Mfield(n).SIN_VAL,N,N)./1e3.*VCC+VOFF;
    Hx(:,:,n) = reshape(Mfield(n).Hx,N,N)./1e3.*VCC+VOFF; % Warum Sensor Voltage Offset?
    Hy(:,:,n) = reshape(Mfield(n).Hy,N,N)./1e3.*VCC+VOFF; 
end             
%%         
rot = 0; 
pos = find(alpha==rot); 
clc
C = reshape(Mfield(pos).COS_VAL,N,N)./1e3.*VCC; % Warum 2x Normierung?
S = reshape(Mfield(pos).SIN_VAL,N,N)./1e3.*VCC;
xx = Mfield(1).x; 
yy = Mfield(1).y; 
quiver(xx,yy,C,S),axis square xy
xlim([-sz sz]/1.5)
ylim([-sz sz]/1.5)
%%
% maximale Feldstarke
Hmax    =  MTX.Fstrength; 
% Anzahl der sensoren (NxN) 
t       = [shift_x,shift_y,tz]; 
% NxN 
xcoord  = M.x;
% NxN 
ycoord  = M.y;
alpha = alpha./180.*pi;
filename = sprintf('DIP_SIM_tx_%02.4f_ty_%02.4f_tz_%02.4f.mat',t(1),t(2),t(3));
disp(filename) 
save(filename,'alpha','Hmax','Hx','Hy','N','sz','t','Vc','Vs','xcoord','ycoord');


