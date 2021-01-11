function [ Mfield,r_mag] = genField(M,... 
                                    r_sta,...
                                    r_ste,...
                                    r_end,...
                                    shift_x,...
                                    shift_y,...
                                    tx,ty,tz,...
                                    V1,V2,Fstrength,hx,hy)
%GENFIELD Summary of this function goes here
%   Detailed explanation goes here


%   ,phix,phiy evtl fuer spaetere implementation // Verkippung des Magneten
nsens = length(M.x); 
n_mag = nsens^2;
nn = 1; 
for rotate = r_sta:r_ste:r_end
    r_mag(nn) = rotate; 
    %======================================================================
    % Define square magnet
    %======================================================================
%     Magnet.a          = 0;          % edge length a in x-direction in cm
%     Magnet.b          = 0;          % edge length b in y-direction in cm
%     Magnet.c          = 0;          % edge length c in z-direction in cm
%     Magnet.an         = 1;            % number of dipols in x-direction
%     Magnet.bn         = 1;            % number of dipols in y-direction
%     Magnet.cn         = 1;             % number of dipols in z-direction
%     Magnet.DipolGes   = Magnet.an * Magnet.bn * Magnet.cn;
%     Magnet.rotate     = [0 0 rotate];
%     Magnet.translate  = [tx ty 0];
%     Magnet.mue0       = 1;      %4 * pi * 10-7;          % magnetic constant 
%     mue               = [-Magnet.DipolGes./10; 0; 0];
%     Magnet.mue        = rotMatrix(mue,Magnet.rotate(1),Magnet.rotate(2),Magnet.rotate(3));%[0; -1; 0];  % magnetic moment
% % create dipol position 
%     [Dipol] = blockMeshgrid(Magnet); 
% calc field  
    rr  = [ M.x(:)+shift_x, M.y(:)+shift_y, M.x(:).*0+tz]';  

    %%  
    Magnet.rotate     = [0 0 rotate];
    Magnet.translate  = [tx ty 0];
    Magnet.mue0       = 1;     
    mue               = [-1; 0; 0];
    Magnet.mue        = rotMatrix(mue,Magnet.rotate(1),Magnet.rotate(2),Magnet.rotate(3));%[0; -1; 0];  % magnetic moment

    xx  = rr(1,:);
    yy  = rr(2,:);
    zz  = rr(3,:);  
    
    MagField(nn).Bx = zeros(1,nsens^2);
    MagField(nn).By = zeros(1,nsens^2);
    MagField(nn).Bz = zeros(1,nsens^2);
    
    Betrag      = sqrt(xx.^2 + yy.^2 + zz.^2);
    Skalar      = Magnet.mue(1)*xx + Magnet.mue(2)*yy + Magnet.mue(3)*zz;
    
    MagField(nn).Bx	= 1./(4 * pi * Betrag.^2) .* ...
                   	  (3*xx.*(Skalar) - mue(1) .* Betrag.^2) ./ Betrag.^3;
    MagField(nn).By	= 1./(4 * pi * Betrag.^2) .* ...
                   	  (3*yy.*(Skalar) - mue(2) .* Betrag.^2) ./ Betrag.^3;
    MagField(nn).Bz = 1./(4 * pi * Betrag.^2) .* ...
                   	  (3*zz.*(Skalar) - mue(3) .* Betrag.^2) ./ Betrag.^3;
    
    
    %%
%     for ii = 1:length(Dipol.positionX) 
% 
%         xx  = rr(1,:)-Dipol.positionX(ii);
%         yy  = rr(2,:)-Dipol.positionY(ii);
%         zz  = rr(3,:)+Dipol.positionZ(ii);
% 
%         Betrag      = sqrt(xx.^2 + yy.^2 + zz.^2);
%         Skalar      = Magnet.mue(1)*xx + Magnet.mue(2)*yy + Magnet.mue(3)*zz;
%         Bx = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * xx .* (Skalar) ...
%                             - Magnet.mue(1) .* Betrag.^2) ./ Betrag.^3;
%         By = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * yy .* (Skalar) ...
%                             - Magnet.mue(2) .* Betrag.^2) ./ Betrag.^3;
%         Bz = Magnet.mue0 ./ (4 * pi * Betrag.^2) .* (3 * zz .* (Skalar) ...
%                             - Magnet.mue(3) .* Betrag.^2) ./ Betrag.^3;
%         Bx(isnan(Bx)==1)  = 0;
%         By(isnan(By)==1)  = 0;
%         Bz(isnan(Bz)==1)  = 0; 
%         MagField(nn).Bx = MagField(nn).Bx + Bx;
%         MagField(nn).By = MagField(nn).By + By;
%         MagField(nn).Bz = MagField(nn).Bz + Bz; 
%     end
    
        MM(nn) = max([max(abs(MagField(nn).Bx)),max(abs(MagField(nn).By))]);  
    
        nn = nn + 1; 
end 
for nn =1 : length(MagField)
        MagField(nn).Bx2 = MagField(nn).Bx./max(MM).*Fstrength;
        MagField(nn).By2 = MagField(nn).By./max(MM).*Fstrength;
        MagField(nn).Bz2 = MagField(nn).Bz./max(MM).*Fstrength;
end  



%%
clear('d','bbx','bby')
for n = 1 : length(MagField) 
    for m = 1 : n_mag 
        Bx(m,n) = MagField(n).Bx2(m); 
        By(m,n) = MagField(n).By2(m);  
        MagField(n).halX(m) = Bx(m,n);
        MagField(n).halY(m) = By(m,n);
    end  
    MagField(n).halX = (Bx(:,n)+abs(min(Bx(:,n)))-mean(abs(Bx(:,n)+abs(min(Bx(:,n))))))'; 
    MagField(n).halY = (By(:,n)+abs(min(By(:,n)))-mean(abs(By(:,n)+abs(min(By(:,n))))))'; 
     
    Mstrength(n)     =  max([max(abs(MagField(n).halX)),max(abs(MagField(n).halY))]); 
end   
     Mstrength = max(Mstrength);
    
for n = 1 : length(MagField)
    MagField(n).halX = MagField(n).halX./Mstrength.*Fstrength; 
    MagField(n).halY = MagField(n).halY./Mstrength.*Fstrength; 
end 

% %% Real VALS....
% pct = 0.1; 
% flg = 0; 
% for n = 1 : length(MagField)
%     Mfield(n).rot = r_mag(n); 
%     Mfield(n).x   = M.x;
%     Mfield(n).y   = M.y;
%     
%     for r = 1 : n_mag 
%             bvx = MagField(n).halX(r); 
%             bvx = floor(bvx.*1e6)./1e6;
%             bvy = MagField(n).halY(r); 
%             bvy = floor(bvy.*1e6)./1e6;         
%             if bvx< 0 
%                 P = find(hx<=bvx*(1-pct) & hx>=bvx*(1+pct));  
%                 pHx = floor(mean(P));
%              elseif bvx == 0 
%                  pHx = round(length(V1.V1all)/2);
%                 flg = 1; 
%             elseif bvx >= 0 
%                 P = find(hx>=bvx*(1-pct) & hx<=bvx*(1+pct));  
%                 pHx = floor(mean(P));
%             end
%             
%             if bvy< 0
%                 P = find(hy<=bvy*(1-pct) & hy>=bvy*(1+pct)); 
%                 pHy = floor(mean(P));
%             elseif bvy ==0
%                 pHy = round(length(V1.V1all)/2);
%                 flg = 1; 
%             elseif bvy > 0
%                 P = find(hy>=bvy*(1-pct) & hy<=bvy*(1+pct)); 
%                 pHy = floor(mean(P));
%             end
%             
%             Px(n,r) = pHx; 
%             Py(n,r) = pHy; 
%             
%             if isnan(pHx) == 0 && isnan(pHy) == 0
%                 Mfield(n).COS_VAL(r) = V1.V1all(pHx,pHy);
%                 Mfield(n).SIN_VAL(r) = V2.V2all(pHx,pHy);
%             elseif flg 
%                 Mfield(n).COS_VAL(r) = 0;
%                 Mfield(n).SIN_VAL(r) = 0;            
%             else 
%                 Mfield(n).COS_VAL(r) = NaN;
%                 Mfield(n).SIN_VAL(r) = NaN;
%             end
%             flg = 0;  
%     end 
% end  
%% Real VALS.... 
for n = 1 : length(MagField)
    Mfield(n).rot = r_mag(n); 
    Mfield(n).x   = M.x;
    Mfield(n).y   = M.y;
    
    for r = 1 : n_mag 
            bvx = MagField(n).halX(r); 
            bvx = floor(bvx.*1e6)./1e6;
            bvy = MagField(n).halY(r); 
            bvy = floor(bvy.*1e6)./1e6;  
            
            
            D           = abs(hx-bvx); 
            [mval,P]    = min(D);   
            pHx         = floor(mean(P));
            
            D           = abs(hy-bvy); 
            [mval,P]    = min(D);   
            pHy         = floor(mean(P)); 
            
            Px(n,r) = pHx; 
            Py(n,r) = pHy; 
            
            
            Mfield(n).posx(r) = bvx; 
            Mfield(n).posy(r) = bvy; 
            
            if isnan(pHx) == 0 && isnan(pHy) == 0
                Mfield(n).COS_VAL(r) = V1.V1all(pHx,pHy);
                Mfield(n).SIN_VAL(r) = V2.V2all(pHx,pHy);       
            else 
                Mfield(n).COS_VAL(r) = NaN;
                Mfield(n).SIN_VAL(r) = NaN;
            end 
    end 
end  
end

