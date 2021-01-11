%===============================================================================
% calcAbsError()
% Description:
%             
% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 01.02.2017
%===============================================================================
function [e] = calcAbsError(measureArray, simArray, k)
  a = measureArray - simArray*k;
  a(isnan(a)==1)=0;
  e = sum(a(:));
end