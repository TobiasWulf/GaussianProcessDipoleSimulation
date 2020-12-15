function [cosPred, sinPred, varPred] = doGPReg(Dref, Dpred, params)
   %DOGPREGS: Gaussian Process Regression
   
   calcVarPred = (nargout == 3); 
   
   % Referenzdaten aufbereiten: in der Trainingsphase wird alles mit 
   % single-Precision gerechnet
   alphaRef = single(Dref.alpha);  % Spaltenvektor!
   assert(iscolumn(alphaRef));
   % Skalieren der Daten mit einem passenden Parameter: dass klappt der
   % Fixed-Point-Teil besser
   VcRef = (Dref.Vc / params.len2);
   VsRef = (Dref.Vs / params.len2);
   cosRef = cos(alphaRef);
   sinRef = sin(alphaRef);
   
   % Kovarianzfunktion
   covFunc = @(Vc1, Vc2, Vs1, Vs2) covFuncFlexible(Vc1, Vc2, Vs1, Vs2, params);
   
   % Trainingsphase: Die Cholesky-Matrix R wird für die Anwendungsphase 
   % nur gebraucht, wenn die Varianz (Gl 2.26) bei Rasmussen/Williams 
   % berechnet werden soll.
   [zc, zs, R] = gpRegTrain(VcRef, VsRef, cosRef, sinRef, covFunc, params.s2n);
      
   % Anwendungsphase: 
   
   % Erstmal wird alles gecastet: 
   nPred = size(Dpred.Vc,3);
   VcTest = params.castFunc(Dpred.Vc / params.len2);
   VsTest = params.castFunc(Dpred.Vs / params.len2);
   VcRef = params.castFunc(VcRef); 
   VsRef = params.castFunc(VsRef); 
   cosPred = params.castFunc(zeros(nPred,1));
   sinPred = params.castFunc(zeros(nPred,1));
   zc = params.castFunc(zc); 
   zs = params.castFunc(zs); 
   if calcVarPred
      varPred = params.castFunc(zeros(nPred,1));
      R = params.castFunc(R);
   end
   for kk=1:nPred
      if calcVarPred
         [cp, sp, vp] = gpRegAppl(VcRef, VsRef, squeeze(VcTest(:,:,kk)), squeeze(VsTest(:,:,kk)), ...
            zc, zs, covFunc, R);
         varPred(kk) = vp;
      else
         [cp, sp] = gpRegAppl(VcRef, VsRef, squeeze(VcTest(:,:,kk)), squeeze(VsTest(:,:,kk)), ...
            zc, zs, covFunc);
      end
      cosPred(kk) = cp;
      sinPred(kk) = sp;
    end
end

