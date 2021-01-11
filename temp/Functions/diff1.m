%===============================================================================
% diff1()
% Description:

% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 20.01.2017
% edit    : 27.01.2017 : h
%===============================================================================
function [df] = diff1(f,x)
  h     = x(1,2)-x(1,1);
  df    = zeros(length(f(:,1)),length(f(1,:))-4);
  for ii = 1:length(f(:,1))
    for kk = 3:length(f(1,:))-2
      df(ii,kk-2)  = 1/(12 * h) * (f(ii,kk-2) - 8*f(ii,kk-1) + 8*f(ii,kk+1) - f(ii,kk+2));
    end
  end
end