function circle_plot(M)
%CIRCLE_PLOT(M)
%==========================================================================
% Input variables 
%==========================================================================
% Mfield: Stuct with follwoing neccesary entreis 
%     	|
%       |-> rot     :    rotation angle of magnet in degree
%       |-> Hx      :    field strength in x-direction
%       |-> Hy      :    field strength in y-direction
%       |-> COS_VAL :    sensor output in x-direction
%       |-> SIN_VAL :    sensor output in y-direction
%==========================================================================
% Output
%==========================================================================
% XY-Darstellung der Rotation eines Magneten über den Sensor-Elementen. 
% Die Darstellung dient hier zur Veranschaulichung des Ausgangssignals des
% Sensorarrays bei einer vollen Rotation des Encodermagneten.
%
% Schritt 1: Berechnung des Betragsmaximum des Eingagssignals 
% Schritt 2: Umspeichern und Normieren der Daten
% Schritt 3: Plotten der XY-Darstellung als Schachbrett
%==========================================================================
% Die Ausgabe sollte ungefähr das folgende ergeben:
% OL: Feldstärke, die an den Sensoren anliegt. Hier normiert auf das Maximum 
%     über alle Punkte und eine volle Umdrehung => Feldverlauf und Stärke wird
%     berücksichtigt
% OR: Das Entsprechende Sensor-Ausgangssignal zur Feldstärke OL
% UL: Feldstärke, die an den Sensoren anliegt. Hier normiert auf das Maximum an
%     jedem einzelnen Punkt => Feldverlauf kann näher betrachtet werden aber
%     keine Aussage mehr über die Feldstärke
% UR: Das Entsprechende Sensor-Ausgangssignal zur Feldstärke UL hier dann auch
%     für jeden Punkt auf das einzelne Maximum normiert
 
    arr_sz = sqrt(length(M(1).COS_VAL));
    dat_len= length(M);   
    
    Y_lbl = ['A':'Z']'; 
    X_lbl = [1:arr_sz]; 
    
    for n = 1 : dat_len 
        % single norm 
        SnormC(n,:)= sqrt(M(n).COS_VAL(:).^2+M(n).SIN_VAL(:).^2); 
        MnormC(n)  = max(sqrt(M(n).COS_VAL(:).^2+M(n).SIN_VAL(:).^2)); 
        SnormH(n,:)= sqrt(M(n).Hx(:).^2+M(n).Hy(:).^2); 
        MnormH(n)  = max(sqrt(M(n).Hx(:).^2+M(n).Hy(:).^2)); 
    end
    SnormC  = max(SnormC)'*2; 
    SnormH  = max(SnormH)'*2; 
    MnormHn = max(MnormH)*2;  
    MnormCn = max(MnormC)*2;  
    for n = 1 : dat_len
        hx(n,:)         = M(n).Hx(:)./SnormH; 
        hy(n,:)         = M(n).Hy(:)./SnormH; 
        hx_scaled(n,:)  = M(n).Hx(:)./MnormHn; 
        hy_scaled(n,:)  = M(n).Hy(:)./MnormHn; 
        
        c(n,:)          = M(n).COS_VAL(:)./SnormC; 
        s(n,:)          = M(n).SIN_VAL(:)./SnormC;
        c_scaled(n,:)   = M(n).COS_VAL(:)./MnormCn; 
        s_scaled(n,:)   = M(n).SIN_VAL(:)./MnormCn; 
    end
    fh1 = figure(1);
        nn = 1; 
        for x = 1 : arr_sz
            for y = 1 : arr_sz
                plot(hx_scaled(:,nn)+x,hy_scaled(:,nn)+y,'color','b','linewidth',1.5),hold on
                line([x,hx_scaled(1,nn)+x],[y,hy_scaled(1,nn)+y],'color','r','linewidth',1.5)
                nn=nn+1; 
            end
        end
        xticks(1:arr_sz);
        yticks(1:arr_sz);yticklabels(Y_lbl(1:arr_sz));
        hold off
        axis square xy 
        xlim([0 arr_sz+1])
        ylim([0 arr_sz+1])
        grid on
        title('Field strength normed to maximum output of all positions')
        xlabel('X-coord')
        ylabel('Y-coord')
    fh2 = figure(2);
        nn = 1; 
        for x = 1 : arr_sz
            for y = 1 : arr_sz
                plot(hx(:,nn)+x,hy(:,nn)+y,'color','b','linewidth',1.5),hold on
                line([x,hx(1,nn)+x],[y,hy(1,nn)+y],'color','r','linewidth',1.5)
                nn=nn+1; 
            end
        end
        xticks(1:arr_sz);
        yticks(1:arr_sz);yticklabels(Y_lbl(1:arr_sz));
        hold off
        axis square xy 
        xlim([0 arr_sz+1])
        ylim([0 arr_sz+1])
        grid on
        title('Field strength normed to each position individual')
        xlabel('X-coord')
        ylabel('Y-coord')
    fh3 = figure(3);
        nn = 1; 
        for x = 1 : arr_sz
            for y = 1 : arr_sz
                plot(c_scaled(:,nn)+x,s_scaled(:,nn)+y,'color','b','linewidth',1.5),hold on
                line([x,c_scaled(1,nn)+x],[y,s_scaled(1,nn)+y],'color','r','linewidth',1.5)
                nn=nn+1; 
            end
        end
        xticks(1:arr_sz);
        yticks(1:arr_sz);yticklabels(Y_lbl(1:arr_sz));
        hold off
        axis square xy 
        xlim([0 arr_sz+1])
        ylim([0 arr_sz+1])
        grid on
        title('Sensor output normed to maximum output of all elements')
        xlabel('X-coord')
        ylabel('Y-coord')
    fh4 = figure(4);
        nn = 1; 
        for x = 1 : arr_sz
            for y = 1 : arr_sz
                plot(c(:,nn)+x,s(:,nn)+y,'color','b','linewidth',1.5),hold on
                line([x,c(1,nn)+x],[y,s(1,nn)+y],'color','r','linewidth',1.5)
                nn=nn+1; 
            end
        end
        xticks(1:arr_sz);
        yticks(1:arr_sz);yticklabels(Y_lbl(1:arr_sz));
        hold off
        axis square xy 
        xlim([0 arr_sz+1])
        ylim([0 arr_sz+1])
        grid on
        title('Sensor output normed to each position individual')
        xlabel('X-coord')
        ylabel('Y-coord')
    fh1.Units = 'normalized';
    fh2.Units = 'normalized';
    fh3.Units = 'normalized';
    fh4.Units = 'normalized';
    sz_xy = .4; 
    fh1.Position=[.1,.5+0.02,sz_xy,sz_xy];
    fh3.Position=[.5,.5+0.02,sz_xy,sz_xy];
    
    fh2.Position=[.1,.1,sz_xy,sz_xy];
    fh4.Position=[.5,.1,sz_xy,sz_xy];
    
    fh1.ToolBar = 'none';fh1.MenuBar = 'none';
    fh2.ToolBar = 'none';fh2.MenuBar = 'none';
    fh3.ToolBar = 'none';fh3.MenuBar = 'none';
    fh4.ToolBar = 'none';fh4.MenuBar = 'none';
    
end

