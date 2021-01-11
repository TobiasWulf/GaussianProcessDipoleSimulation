function [ Mfield,r_mag] = genField2(M,... 
                                    r_sta,...
                                    r_ste,...
                                    r_end,...
                                    shift_x,...
                                    shift_y,...  
                                    tz,...
                                    V1,...
                                    V2,...
                                    Fstrength,...
                                    hx,...
                                    hy)
%GENFIELD Summary of this function goes here
%   Detailed explanation goes here


%   ,phix,phiy evtl fuer spaetere implementation // Verkippung des Magneten
nsens = length(M.x); 
n_mag = nsens^2;
nn = 1; 
for rotate = r_sta:r_ste:r_end
    r_mag(nn) = rotate; 
    
    MagField(nn).Bx = zeros(1,nsens^2);
    MagField(nn).By = zeros(1,nsens^2);
    MagField(nn).Bz = zeros(1,nsens^2); 
    m               = rotMatrix([-1e6;0;0],0,0,rotate);   
%     m               = rotMatrix([0;-1e6;0],0,0,rotate);   
    rr              = [ M.x(:)-shift_x, M.y(:)-shift_y, (M.x(:).*0)-tz]';   
    uo    	        = 1; 
    xx              = rr(1,:);
    yy              = rr(2,:);
    zz              = rr(3,:);  
    betrag	        = sqrt(xx.^2 + yy.^2 + zz.^2);


    MagField(nn).Bx = -((m(1).*betrag.^2 - 3.*xx.*(m(1).*xx + ...
                         m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);
    MagField(nn).By = -((m(2).*betrag.^2 - 3.*yy.*(m(1).*xx + ...
                         m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);
    MagField(nn).Bz = -((m(3).*betrag.^2 - 3.*zz.*(m(1).*xx + ...
                         m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);

%     MM(nn) = max([max(abs(MagField(nn).Bx)),max(abs(MagField(nn).By))]);
% maximaler betrag an jedem winkel  
    MM(nn) = max(sqrt(MagField(nn).Bx(:).^2+...
                      MagField(nn).By(:).^2+...
                      MagField(nn).Bz(:).^2));
    nn = nn + 1; 
end 
for nn =1 : length(MagField)
% normierung auf 1 über das maximum für die multiplizierung einer beliebigen feldstärke
        MagField(nn).Bx2 = MagField(nn).Bx./max(MM).*Fstrength;
        MagField(nn).By2 = MagField(nn).By./max(MM).*Fstrength;
        MagField(nn).Bz2 = MagField(nn).Bz./max(MM).*Fstrength;
%           Fstrength./max(MM)
% Normiert auf einem Abstand von TZ = 5mm und Fstrength = 8.5kA/m !!! 
%         MagField(nn).Bx2 = MagField(nn).Bx.*0.0134;
%         MagField(nn).By2 = MagField(nn).By.*0.0134;
%         MagField(nn).Bz2 = MagField(nn).Bz.*0.0134;
% Normiert auf einem Abstand von TZ = 2mm und Fstrength = 8.5kA/m !!! 
% 
%         MagField(nn).Bx2 = MagField(nn).Bx.*8.5477e-04;
%         MagField(nn).By2 = MagField(nn).By.*8.5477e-04;
%         MagField(nn).Bz2 = MagField(nn).Bz.*8.5477e-04;
end  
     
for n = 1 : length(MagField)
    MagField(n).halX = MagField(n).Bx2;
    MagField(n).halY = MagField(n).By2;
    
end 


% quiver(reshape(MagField(nn).Bx2,nsens,nsens),reshape(MagField(nn).By2,nsens,nsens)) 
%% Real VALS.... 
for n = 1 : length(MagField)
    Mfield(n).rot = r_mag(n); 
    Mfield(n).x   = M.x;
    Mfield(n).y   = M.y;
    
    for r = 1 : n_mag 
            bvx = MagField(n).halX(r); 
            Mfield(n).Hx(r) = bvx;
%             bvx = floor(bvx.*1e6)./1e6;
            bvy = MagField(n).halY(r); 
            Mfield(n).Hy(r) = bvy;
%             bvy = floor(bvy.*1e6)./1e6;  
             
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
                Mfield(n).COS_VAL(r) = V1.V1all(pHy,pHx);
                Mfield(n).SIN_VAL(r) = V2.V2all(pHy,pHx);       
            else 
                Mfield(n).COS_VAL(r) = NaN;
                Mfield(n).SIN_VAL(r) = NaN;
            end 
    end 
end  
end

