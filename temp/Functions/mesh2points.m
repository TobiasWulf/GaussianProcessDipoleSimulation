function [ P ] = mesh2points( X,Y,Z )
%MESH2POINTS 
%==========================================================================
% author :      Thorben Schuethe
% mail   :      thorben.schuethe@haw-hamburg.de
% date   :      03.11.2016
%==========================================================================
    [sx,sxx] = size(X); 
    [sy,syy] = size(Y); 
    [sz,szz] = size(Z); 
    
    a=1; 
    if sx==sy && sx==sz && sy==sz
        if sxx==syy && sxx==szz && syy==szz
           for k = 1 : sx
               for n = 1 : sxx
                   P(a,:) = [X(k,n);Y(k,n);Z(k,n)];
                   a = a+1;
               end
           end
        end        
    else
        P = 0; 
    end    
end

