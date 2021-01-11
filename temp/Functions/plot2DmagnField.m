%===============================================================================
% plot2DmagnField
% Description:
%             calculate the magnitude and the phase of each vector of a 2D-vectofield and plot the results
% and plots the results
% Input:
%           Bx    : x-Component of magnetic field
%           By    : y-Component of magnetic field
%           zPos  : defines in wich z-plane, with respect to the calcField
% Output:
%           magnitude     : magnitude of Bx and By
%           phase         : phase of Bx and By
% author  : Hauke J. Pape
% email   : hauke.pape@haw-hamburg.de
% date    : 03.01.2017
%===============================================================================
function [magnitude, phase]=plot2DmagnField(Bx,By,zPos,xx,yy,mue, Dipol)
  By(By==-0)  = 0;        % there are failures by calculating the angle, because some elements in Bx and By have the value "-0"
  Bx(Bx==-0)  = 0;
  phase       = atan2d(By,Bx);
  magnitude   = sqrt(Bx.^2 + By.^2);
  zz = ones(length(yy(:,1)),length(xx(1,:)))*zPos;
  % Plot results
  figure;
  %===============================================================================
  % Vectorfield
                                       
  quiver3(xx,yy,zz, Bx,By,zeros(length(By(:,1)),length(Bx(1,:))));
  hold on;
  %if Dipol.positionX(1,1) ~ 0
  scatter3(Dipol.positionX,Dipol.positionY,Dipol.positionZ);
  %quiver3(Dipol.positionX,Dipol.positionY,Dipol.positionZ,mue(1)*0.5,mue(2)*0.5,mue(3)*0.5);
  %endif
  hold off;
  set(gca,'DataAspectRatio',[1 1 1]);
  grid on;
  %axis([xx(1,1)-range xx(1,end)+range yy(1,1)-range yy(end,1)+range]);
  title(sprintf( ' z-Ebene: %d,  mue=[%d %d %d]', zPos,mue(1),mue(2),mue(3) ));
  xlabel('x-Koordinate');
  ylabel('y-Koordinate');
end
