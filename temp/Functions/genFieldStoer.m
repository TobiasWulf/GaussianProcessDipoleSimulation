function [ Mfield,r_mag] = genFieldStoer(M,... 
                                    r_sta,...
                                    r_ste,...
                                    r_end,...
                                    shift_x,...
                                    shift_y,...
                                    tx,...
                                    ty,...
                                    tz,...
                                    V1,...
                                    V2,...
                                    Fstrength,...
                                    hx,...
                                    hy,...
                                    ang,...
                                    Strength)
 
nsens = length(M.x); 
n_mag = nsens^2;

%% Compute the saturation field 
%   ,phix,phiy evtl fuer spaetere implementation // Verkippung des Magneten
Stoer.Bx = zeros(1,nsens^2);
Stoer.By = zeros(1,nsens^2);
Stoer.Bz = zeros(1,nsens^2); 
m               = rotMatrix([-1e6;0;0],0,0,ang);     
rr              = [ M.x(:), M.y(:), (M.x(:).*0)-150]';   
uo    	        = 1; 
xx              = rr(1,:);
yy              = rr(2,:);
zz              = rr(3,:);  
betrag	        = sqrt(xx.^2 + yy.^2 + zz.^2);


Stoer.Bx = -((m(1).*betrag.^2 - 3.*xx.*(m(1).*xx + ...
                     m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);
Stoer.By = -((m(2).*betrag.^2 - 3.*yy.*(m(1).*xx + ...
                     m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);
Stoer.Bz = -((m(3).*betrag.^2 - 3.*zz.*(m(1).*xx + ...
                     m(2).*yy + m(3).*zz)))./(4.*betrag.^5.*pi);

MM        = max([max(abs(Stoer.Bx)),max(abs(Stoer.By))]);   
Stoer.Bx2 = Stoer.Bx./max(MM).*Strength;
Stoer.By2 = Stoer.By./max(MM).*Strength;
Stoer.Bz2 = Stoer.Bz./max(MM).*Strength; 
      
Stoer.halX = Stoer.Bx2;
Stoer.halY = Stoer.By2; 


%%
%   ,phix,phiy evtl fuer spaetere implementation // Verkippung des Magneten
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

    MM(nn) = max([max(abs(MagField(nn).Bx)),max(abs(MagField(nn).By))]);  

    nn = nn + 1; 
end 
for nn =1 : length(MagField)
        MagField(nn).Bx2 = MagField(nn).Bx./max(MM).*Fstrength;
        MagField(nn).By2 = MagField(nn).By./max(MM).*Fstrength;
        MagField(nn).Bz2 = MagField(nn).Bz./max(MM).*Fstrength;
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
            bvx = MagField(n).halX(r)+Stoer.halX(r); 
            bvx = floor(bvx.*1e6)./1e6;
            bvy = MagField(n).halY(r)+Stoer.halY(r); 
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
                Mfield(n).COS_VAL(r) = V1.V1all(pHy,pHx);
                Mfield(n).SIN_VAL(r) = V2.V2all(pHy,pHx);       
            else 
                Mfield(n).COS_VAL(r) = NaN;
                Mfield(n).SIN_VAL(r) = NaN;
            end 
    end 
end  
end

