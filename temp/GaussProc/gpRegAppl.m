function [cosPred, sinPred, varPred] = gpRegAppl(VcRef, VsRef, VcTest, VsTest, ...
      zc, zs, covFunc, R)
   %grRegAppl: GP Regression anwenden
   % zc und zs sind jeweils die Spaltenvektoren K^-1*y in (2.25) bei
   % Rasmussen/Williams. y hier hierbei cos(alpha) bzw. sin(alpha)
   
   assert(iscolumn(zc));
   assert(iscolumn(zs));
   
   % berechne Varianz nur, wenn Cholesky-Matrix R übergeben wird 
   calcVarPred = (nargin == 8); 
   
   % Berechne k_* aus Gl (2.25)
   nSteps = size(VcRef, 3);
   covVecTestTrain = single(zeros(nSteps, 1));
   for nn=1:nSteps
      covVecTestTrain(nn) = covFunc(VcTest, squeeze(VcRef(:,:,nn)), ...
         VsTest, squeeze(VsRef(:,:,nn)));
   end
   
   % Vorhersage fuer cos(alpha) und sin(alpha) nach (2.25)
   cosPred = covVecTestTrain'*zc;
   sinPred = covVecTestTrain'*zs;

   % Berechne Varianz nach (2.26):
   if calcVarPred
      v = myLinsolveTril(R', covVecTestTrain);
      varPred = covFunc(VcTest, VcTest, VsTest, VsTest) - v'*v;
   end
end

