%===============================================================================
% diff2()
% Description:

% Input:

% Output:

% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 23.01.2017
% edit    : 27.01.2017 : h
%===============================================================================
function [ddf] = diff2(f,x)
  h   = x(1,2)-x(1,1);
  ddf    = zeros(length(f(:,1)),length(f(1,:))-4);
  for ii = 1:length(f(:,1))
    for kk = 3:length(f(1,:))-2
      ddf(ii,kk-2)  = 1/(12 * h^2) * (-f(ii,kk-2) + 16*f(ii,kk-1) - 30*f(ii,kk) + 16*f(ii,kk+1) - f(ii,kk+2));
    end
  end
end