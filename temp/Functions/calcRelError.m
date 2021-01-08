%===============================================================================
% [e] = calcRelError(measureArray, simArray, k)
% Description:
%             
% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 01.02.2017
%===============================================================================
function [e] = calcRelError(measureArray, simArray, k)
    measureArray(abs(measureArray)<10e-9)=0;
    simArray(abs(measureArray)<10e-9)=0;
    e = abs((measureArray) - simArray*k)./(abs(measureArray));
    e(isnan(e)==1)=[];
    e=sum(e(:));
end