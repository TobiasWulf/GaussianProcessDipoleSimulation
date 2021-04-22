function x = myLinsolveTril(A, b) %#codegen
   %MYLINSOLVETRI Löse LGS mit unterer Dreiecksmatrix
%    assert(istril(A)); 
%    assert(iscolumn(b)); 
   
  %  N = length(b); 
   % assert(isequal(size(A), [N,N])); 
   x = zeros(size(b), 'like', b);
   x(1) = b(1) / A(1,1);
   if length(b)>1
      for nn = 2:length(b)
         % s = zeros(1,1,'like', b); 
         s = 0; 
         for kk = 1:(nn-1)
            s = s + A(nn,kk) * x(kk); 
         end
         x(nn) = (b(nn) - s)/A(nn,nn);
      end
   end
end

