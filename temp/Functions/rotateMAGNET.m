function [ MAGNET ] = rotateMAGNET( MAGNET, ROT , T )
% MAGNET = ROTATEMAGNET( MAGNET, ROT , T )
%
% Rotation and translation of the magnet points
%
% Input args: 
%               MAGNET
%               ROT     :       ROT(1)-> Rotation along the X-Axis
%                               ROT(2)-> Rotation along the Y-Axis
%                               ROT(3)-> Rotation along the Z-Axis
%               T       :       T(1) -> Translation in X-Direction
%                               T(2) -> Translation in Y-Direction
%                               T(3) -> Translation in Z-Direction
%==========================================================================
% Output args: 
%               MAGNET
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      30.08.2016
%==========================================================================

    Tr      = repmat([T(1);T(2);T(3)],1,length(MAGNET.normal.xt));
    P       = rotMatrix([   MAGNET.normal.xt;...
                            MAGNET.normal.yt;...
                            MAGNET.normal.zt],ROT(1),ROT(2),ROT(3))+...
                            Tr; % rotataion arount z-axis

    MAGNET.rotXYZ.xt   = P(1,:); 
    MAGNET.rotXYZ.yt   = P(2,:); 
    MAGNET.rotXYZ.zt   = P(3,:);  
end

