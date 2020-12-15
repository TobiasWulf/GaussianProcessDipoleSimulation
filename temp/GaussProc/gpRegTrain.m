function [zc, zs, R] = gpRegTrain(VcRef, VsRef, cosRef, sinRef, covFunc, s2n)
   %gpRegTrain: GP-Regression training phase
   
   % Berechnung der Kovarianzmatrix der Referenzfelder
   nSteps = size(VcRef, 3);
   covMatTrain = single(zeros(nSteps, nSteps));
   for kk=1:nSteps
      for nn=1:nSteps
         covMatTrain(kk,nn) = covFunc(squeeze(VcRef(:,:,kk)), squeeze(VcRef(:,:,nn)), ...
            squeeze(VsRef(:,:,kk)), squeeze(VsRef(:,:,nn)));
      end
   end
   % disp(max(covMatTrain(:)) / min(covMatTrain(:)));
   covMatTrain = covMatTrain + s2n*eye(nSteps);
     
   % R2 = myChol(covMatTrain); laeuft noch nicht.
    [R, flag] = chol(covMatTrain);
   assert(flag==0);
%    
%    % Berechnung des Produkts K^-1*y aus Gleichung (2.25) bei
%    % Rasmussen/Williams. y hier hierbei cos(alpha) bzw. sin(alpha)
   ac = myLinsolveTril(R', cosRef); 
   as = myLinsolveTril(R', sinRef); 
   zc = myLinsolveTriu(R, ac); 
   zs = myLinsolveTriu(R, as); 
   
%    Kinv = covMatTrain^-1; 
%    zc = (cosRef'*Kinv)'; 
%    zs = (sinRef'*Kinv)'; 
   
end
