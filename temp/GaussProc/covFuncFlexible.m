function c = covFuncFlexible(Bx1, Bx2, By1, By2, params)
   %COVFUNCGP Kovarianz-Funktion, die fuer GP-Regression genutzt wird
   % Das hier ist relativ flexibel, um verschiedene Optionen zu probieren
   
   dBx = Bx1 - Bx2;
   dBy = By1 - By2;
   r2 = sum( dBx(:).^2) + sum( dBy(:).^2 );
      
   len = cast(params.len, 'like', Bx1); 
   c = 1 / (len + r2);
   s2f = cast(params.s2f, 'like', c);
   c = s2f * c; 
end

