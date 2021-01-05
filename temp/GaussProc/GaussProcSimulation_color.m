%% Simulation angle prediction with Gauss-Prozesses
close all
clear all
% clc 
addpath('../linAlg/');
% Daten für die Lernphase 
load('../../data/test/Test_2021-01-05_13-57-09-083.mat', 'Data');
D = struct();
D.Vc = Data.Vcos;
D.Vs = Data.Vsin;
D.alpha = Data.angles * pi /180;

% Datan für die Arbeitsphase
load('../../data/test/Test_2021-01-05_13-57-09-083.mat', 'Data');
Dpred = struct();
Dpred.Vc = Data.Vcos;
Dpred.Vs = Data.Vsin;
Dpred.alpha = Data.angles * pi /180;

nRef        = 16;                    % Number of ref angles 
labelSize   = 10; 
tickSize    = 9; 
legendSize  = 8; 
txtsize     = 8; 
cSize       = 8; 
OFFX        = 10;
% D = load('MAG_SIM_XY_NEW.mat');
% D = load('MAG_SIM_XY_NEW2.mat');
%%  Winkelfehler ohne Gauß Prozess
for n = 1 : length(D.alpha) 
    sv(n) = mean2(squeeze(D.Vs(:,:,n)));
    cv(n) = mean2(squeeze(D.Vc(:,:,n))); 
end 
alpha_NO_LERN    = atan2(sv-mean(sv),...
                         cv-mean(cv)); 
alpha_error_NO_LERN = (unwrap(alpha_NO_LERN)-D.alpha).*180./pi;  
nMess       = length(D.alpha);  
%% Aufteilen in Referenzdaten und Testdaten 
inc         = floor(nMess / nRef);
idxRef      = 1:inc:(nMess-inc);    % Index of Reference angle 
Dref.alpha  = D.alpha(idxRef)';     % Reference angle  als col vector
Dref.Vc     = D.Vc(:,:,idxRef);     % Cosine reference 
Dref.Vs     = D.Vs(:,:,idxRef);     % Sine reference 
alphaRefDeg = Dref.alpha*180/pi;    % Angle reference convert to degree


% minimize the effort for the plot instead of using 721 reference angles
idxPred             = 1:nMess;  % alle 721 Winkel sind etwas overkill
alphaPredTrue       = Dpred.alpha(idxPred)';
alphaPredTrueDeg    = alphaPredTrue * 180/pi;
Dpred.Vc            = Dpred.Vc(:,:,idxPred);
Dpred.Vs            = Dpred.Vs(:,:,idxPred);

%% Erster Test mit irgendwelchen Parametern und single in Anwendungsphase
clc
% Art der Covarianzfunktion
% c = s2f / ( len2 + r ) ;  
params.s2f          = 1;
params.s2n          = 0;        % Parameter zur Bildung der Inversen Matrix
params.len          = 2;       % 
params.lenV         = 5;       % Varianz adaptieren 
params.len2         = Dref.alpha(2).*180./pi;
params.castFunc     = @double; % @(x) fi(x, 1, 16, 9);

[cosPred, sinPred,varPred]  = doGPReg(Dref, Dpred, params);

alphaDiff     = (alphaPredTrue-unwrap(atan2(sinPred,cosPred)));
alphaDiffDeg  = alphaDiff*180/pi;
alphaErrDeg   = 180/pi*(abs(cosPred) + abs(sinPred)).*sqrt(varPred);
alphaErrDeg   = alphaErrDeg*params.len;

%% Angle error without optimized parameters 
fh1 = figure(1); 
plot(alphaPredTrueDeg, alphaDiffDeg);
title(sprintf(['Winkelfehler\n',...
              'µ: %.2f°, max: %.2f°'], mean(abs(alphaDiffDeg)), max(abs(alphaDiffDeg))));
xlabel('Drehwinkel / Grad');
ylabel('Winkelfehler / Grad');
yline(0,'k');
yline(-0.5,'k:');
yline(0.5,'k:');
for a = alphaRefDeg'
   xline(a,'k:');
end
xticks(alphaRefDeg);
xlim([0, 360]);

%% 
f2 = figure(2);  
plot(alphaPredTrueDeg,alpha_error_NO_LERN,...
        'LineWidth',1.5);hold off
hold on;
plot(alphaPredTrueDeg, alphaDiffDeg,'LineWidth',1.5);
hold off;
xlim([0,1].*360);
set(gca, 'XTick', Dref.alpha.*180./pi); 
ftx = 1.45; 
xlabel('\alpha_{enc} (degree)', 'Fontsize', 12,'Interpreter','tex');
ylabel('\alpha_{diff} (degree)', 'Fontsize', 12,'Interpreter','tex');
% legend('\alpha_{diff} without correction',...
%        '\alpha_{diff} model free correction',...
%        'Fontsize',8,'Orientation','vertical') 
grid on  
%% Untersuchung des Qualitaetsmasses
% single-Parameter
f3 = figure(3);  
NNfail = 1; 
t = tiledlayout(2,1);   % braucht aktuelle Matlab-Version, sonst subplot benutzen
% title(t, 'Winkelfehler mit Konf-Intervall');
for nFail = 0:NNfail
params.lenV         = 5;       % Varianz adaptieren 
   arSize = size(Dpred.Vc, 1);
   xi = randsample(arSize, nFail, true);
   yi = randsample(arSize, nFail, true);
   Dpred2 = Dpred;
   for kk = 1:nFail
       nFail = 2;
      Dpred2.Vc(4,5,:) = 0;
      Dpred2.Vs(4,5,:) = 0;
      Dpred2.Vc(1,2,:) = 0;
      Dpred2.Vs(2,1,:) = 0;
   end
    
   [cosPred, sinPred, varPred]  = doGPReg(Dref, Dpred2, params);
   alphaErrDeg                  = 180/pi*(abs(cosPred) + abs(sinPred)).*sqrt(varPred);
   % Dieser Faktor hier ist per Hand eingebaut, um auf eine sichtbare Größe
   % zu kommen. alphaErrDeg ist kein echtes Konfidenzintervall, sondern ein
   % relatives Mass, für das ein Schwellwert empirisch bestimmt werden
   % muss:
   alphaErrDeg                  = alphaErrDeg*params.lenV;
   alpha_error = alphaPredTrueDeg-180./pi.*unwrap(atan2(sinPred,cosPred));
   nexttile;
   tname = sprintf('n_{fail} = %1.0f,  E_{max} = %2.3f^\\circ, E_{mean} = %2.3f^\\circ',...
       nFail,max(abs(alpha_error)),mean(abs(alpha_error)));
   
   bcol = [255,255,224]./255; 
   tmpx = [0, alphaPredTrueDeg', 360, 0];
   tmpy = real(1/2 * [0, alphaErrDeg', 0, 0]);
%    p1 = fill(tmpx, tmpy, bcol,'linestyle','none','FaceAlpha',.5);
   plot(tmpx(2:end-2), tmpy(2:end-2),'LineWidth',1,'color','k')
   hold on;
%    plot(tmpx(2:end-2), -tmpy(2:end-2),'LineWidth',1.5,'color','k')
%    p2 = fill(tmpx, -tmpy, bcol,'linestyle','none','FaceAlpha',0.75);
 plot(alphaPredTrueDeg, alpha_error, 'Color', [1 .2 .2],'linewidth',1.5);
   hold off;
   
   title(tname,'FontWeight','normal')
   
   set(gca, 'XTick', 0:60:360); 
   grid on  
   xlim([0, 360]);
   ylim(2*[-1,1]); 
   set(gca,'FontSize',10)
    xlabel('\alpha_{enc} (degree)', 'Fontsize', labelSize);
    ylabel('\alpha_{diff} (degree)', 'Fontsize', labelSize);
end

t.TileSpacing = 'compact';  
t.Padding = 'none'; 
% sname = sprintf('juenemann_qualitaet_nref_%03.0f.png',nRef); 
% saveas(gcf,[sname]); 