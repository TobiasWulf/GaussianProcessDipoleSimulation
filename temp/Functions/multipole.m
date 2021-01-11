function [ shape ] = multipole( ri, ro, npole, delta, nr, nc, z )
% shape = MULTIPOLE( ri, ro, npole, delta, nr, nc, z )
%
% Create a multipole ring with different magnetiziation
%
% Input args: 
%               ri      :       inner radian of the magnet
%               ro      :       outer radian of the magnet
%               npole 	:       number of poles if 2 => 2xN and 2xS
%               delta   :       angular between magnetesized fields
%               nr      :       number of steps from the radian
%               nc      :       number of steps from the circle
%               z       :       distance from magnet to sensor
%==========================================================================
% Output args: 
%               shape   :       Sturcture with 2 input args
%                       -> x    X-Coordinate of the magnet
%                       -> y    Y-Coordinate of the magnet
%                       -> z    Z-Coordinate of the magnet
%                       -> pn   Vector with 1 for positiv magnetization
%                               and 0 for negative magnetizetion
%                       -> PSI  angle in rad from magnet point in 
%                               cylindrical coordinates
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      30.08.2016
%==========================================================================


shape       = struct('x',[],'y',[],'z',[],'pn',[],'psi',[]); 
MAG.r1      = ri;                       % inner radian 
MAG.d1      = 2*MAG.r1;                 % inner diameter
MAG.r2      = ro;                       % outer radian
MAG.d2      = 2*MAG.r2;                 % outer diameter
MAG.w       = MAG.r2-MAG.r1;            % width of the ring
MAG.p       = npole;                	% number of  segments (6xN, 6xS) 
MAG.p2      = 2*MAG.p;                  % number of all segments
MAG.t     = 1;                        % thickness of magnet
MAG.r     =   1;                      % dist sensor to rotation axis
MAG.lambda  = 2*pi*MAG.r/MAG.p;         % non magnetic wedges between N&S
MAG.delta   = delta*pi/180;             % angle separate regions of magnetization
MAG.lf      = MAG.p*MAG.delta/pi;       % loss factor


MAG.psi1    = pi*(-1 + MAG.lf + 2.*[0 : MAG.p2-1])/(MAG.p2); 
MAG.psi3    = pi*( 1 - MAG.lf + 2.*[0 : MAG.p2-1])/(MAG.p2); 
MAG.z       = -MAG.t/2 : 0.1 : MAG.t/2; 

% MAG.g       = MAG.z-MAG.t/2;          % from sensor to magnet ring

RING.seg    = nc;                       % segments of circle
RING.segr   = nr;                       % segments of radian 

ps13        = [MAG.psi1(:) MAG.psi3(:)];% generate angular vector for segments

for k = 1 : MAG.p2
    RING.psi(k,:) = (ps13(k,1) : (ps13(k,2)-ps13(k,1))/(RING.seg-1) : ps13(k,2))*(-1)^(k-1); 
end
RING.r12 = MAG.r1  : (MAG.r2-MAG.r1)/(RING.segr-1)  : MAG.r2 ;

PSI = RING.psi';
pn  = [1,0]; 
pn  = repmat(pn,length(PSI),MAG.p);
pn  = pn(:); 
pn  = repmat(pn,MAG.p2-1+RING.segr-1,1);

PSI = PSI(:); 
PSI = repmat(PSI,MAG.p2-1+RING.segr-1,1);

% get cartesian coordinates 
x1 = cos(RING.psi)'; 
y1 = sin(RING.psi)'; 
% x1(end+1,:) = NaN; 
% y1(end+1,:) = NaN; 
x1 = x1(:); 
y1 = y1(:); 
x1 = x1*RING.r12; 
y1 = y1*RING.r12; 
x1 = x1(:); 
y1 = y1(:); 
    
shape.x     = x1; 
shape.y     = y1; 
shape.z     = z.*ones(1,length(x1));
shape.pn    = pn; 
shape.psi   = PSI; 
end

