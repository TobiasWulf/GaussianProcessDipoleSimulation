function R = myChol(A)
   %MYCHOL Elementary implementation of Cholesky decomposition
   % according to https://de.wikipedia.org/wiki/Cholesky-Zerlegung
   % ACHTUNG: Funktioniert (noch) nicht !!!
   
   assert(issymmetric(A)); 
   assert(size(A,1) == size(A,2)); 
   N = size(A,1); 
   R = zeros(size(A)); 
   
   for i=1:N
      for j=1:i
         Summe = A(i,j); 
         for k=1:(j-1)
            Summe = Summe - A(i, k) * A(j, k);
         end
         if i>j
            R(i,j) = Summe / A(j,j);
         elseif Summe > 0
            R(i,i) = sqrt(Summe);
         end
      end
   end
   R = R';    % damit's mit 'chol' kompatibel ist
end

          