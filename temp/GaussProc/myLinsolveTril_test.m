N = 6; 
A = rand(N); 
for nn = 1:(N-1)
   A(nn, (nn+1):end) = 0; 
end
assert(istril(A));
b = rand(N,1); 

% Alogithm
x = myLinsolveTril(A,b); 

% Verify results
x_expected = A \ b;
err = double(x) - x_expected

codegen myLinsolveTril -args {A,b} -config:lib -report
