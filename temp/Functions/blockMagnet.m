function [ shape ] = blockMagnet( a,b,c,nra,nrb,nrc)
%BLOCKMAGNET Summary of this function goes here
% Input args: 
%               a       :       x direction
%               b       :       y direction
%               c       :       z direction
%               nra     :       nr of points in x dir
%               nrb   	:       nr of points in y dir
%               nrc     :       nr of points in z dir
%==========================================================================
% Output args: 
%               shape   :       Sturcture with 2 input args
%                       -> x    X-Coordinate of the magnet
%                       -> y    Y-Coordinate of the magnet
%                       -> z    Z-Coordinate of the magnet
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      30.08.2016
%==========================================================================


x = [-a/2:a/(nra-1):a/2]; 
y = [-b/2:b/(nrb-1):b/2]'; 
z = [-c/2:c/(nrc-1):c/2]; 

x = repmat(x,nrb,1);
y = repmat(y,1,nra);

x = x(:); 
y = y(:); 

x = repmat(x,nrc,1);
y = repmat(y,nrc,1);
z = repmat(z,length(x)/nrc,1); 
z = z(:);

shape.x     = x; 
shape.y     = y; 
shape.z     = z;
end