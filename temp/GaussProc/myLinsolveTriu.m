function x = myLinsolveTriu(A, b)
   %MYLINSOLVETRI Löse LGS mit oberer Dreiecksmatrix
%    assert(istriu(A)); 
%    assert(iscolumn(b)); 
   
   N = length(b); 
   % assert(isequal(size(A), [N,N])); 
   x = zeros(size(b), 'like', b);
   x(N) = b(N) / A(N,N);
   if N>1
      for nn = (N-1):-1:1
         s = 0; 
         for kk = N:-1:(nn+1)
            s = s + A(nn,kk) * x(kk); 
         end
         x(nn) = (b(nn) - s)/A(nn,nn);
      end
   end
end

