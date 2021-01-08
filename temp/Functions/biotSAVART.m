function [ MAGFIELD ] = biotSAVART( MAGNET, SENS, I,nr_points)
% MAGFIELD = BIOTSAVART = biotSAVART( MAGNET, SENS )
% 
% Compute the magnetic field using biot savart equation 
%
% A picture to explain the equation variables is schon at 
% http://notes.tyrocity.com/wp-content/uploads/Biot-Savart-Law.png
%
% Input args: 
%               MAGNET
%               SENS
%               I           : current through the wire
%==========================================================================
% Output args: 
%               MAGFIELD
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      30.08.2016
%==========================================================================

H           = zeros(3,SENS.lP);     % magnetic field

rc          = [ MAGNET.rotXYZ.xt
                MAGNET.rotXYZ.yt
                MAGNET.rotXYZ.zt]; 

ds          =   rc(:,2:1:end)-rc(:,1:1:end-1);
%rc = rc2(:,1:2:end-1);
%% clear all entrys that include NaN
n           =any(isnan(ds));    
ds(:,n==1,:)= []; 
rc(:,n==1,:)= []; 
ds          = ds(:,1:end); 
rc          = rc(:,1:end-1); 
%%
for k = 1 : SENS.lP     
    r       = repmat(SENS.P(:,k), 1, length(rc));     
    rrc     = r-rc;
    absL    = repmat(sqrt(sum(rrc.^2)).^3,3,1);        
    c       = cross(ds,rrc)./absL;
    H(:,k)  = I/(4*pi).*sum(c,2);
end 
%H = I/(4*pi).*H;%./nr_points;
[MAGFIELD.coord.X ,...
 MAGFIELD.coord.Y]  = meshgrid(SENS.P(1,1:SENS.numPxl),SENS.P(1,1:SENS.numPxl));
MAGFIELD.coord.Z    = zeros(SENS.numPxl,SENS.numPxl); 
MAGFIELD.hfield.X   = vec2mat(H(1,:),SENS.numPxl);
MAGFIELD.hfield.Y   = vec2mat(H(2,:),SENS.numPxl);
MAGFIELD.hfield.Z   = vec2mat(H(3,:),SENS.numPxl);
MAGFIELD.hnorm.X    = MAGFIELD.hfield.X./sqrt(MAGFIELD.hfield.X.^2+MAGFIELD.hfield.Y.^2+MAGFIELD.hfield.Z.^2);
MAGFIELD.hnorm.Y    = MAGFIELD.hfield.Y./sqrt(MAGFIELD.hfield.X.^2+MAGFIELD.hfield.Y.^2+MAGFIELD.hfield.Z.^2);
MAGFIELD.hnorm.Z    = MAGFIELD.hfield.Z./sqrt(MAGFIELD.hfield.X.^2+MAGFIELD.hfield.Y.^2+MAGFIELD.hfield.Z.^2);

end

