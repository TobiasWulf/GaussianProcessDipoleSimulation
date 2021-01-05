A = [1, 0, 0; 2, 3, 0; 4, 5, 6]; 
b = [-2;2;3];
x = linsolve(A,b);
x2 = myLinsolveTril(A,b);
disp(max(abs(x-x2)));
y = linsolve(A',b);
y2 = myLinsolveTriu(A', b); 
disp(max(abs(y-y2))); 

%% 
N = 6; 
A = rand(N); 
for nn = 1:(N-1)
   A(nn, (nn+1):end) = 0; 
end
assert(istril(A));
assert(istriu(A'));
b = rand(N,1); 
x = A \ b;
x2 = myLinsolveTril(A,b); 
disp(max(abs(x-x2)));
assert(max(abs(x-x2))<eps*1000)
y = A' \ b;
y2 = myLinsolveTriu(A',b);
disp(max(abs(y-y2)));
assert(max(abs(y-y2))<eps*1000)


%% Vergleich double-half
N = 6; 
Ad = rand(N); 
for nn = 1:(N-1)
   Ad(nn, (nn+1):end) = 0; 
end
assert(istril(Ad));
bd = rand(N,1); 
xd = myLinsolveTril(Ad,bd); 
Ah = half(Ad); 
bh = half(bd); 
xh = myLinsolveTril(Ah,bh);


%% Festkomma
% Define word length and fraction length
% number of bits
Nbit    = 12; 
% number of bits for 
num     = 4; 
% Fraction length
frac    = Nbit-num;  
% With sign symbol
signed  = 1;
myFi = @(A) fi(A,signed,Nbit,frac); 
N = 6; 
Ad = rand(N); 
for nn = 1:(N-1)
   Ad(nn, (nn+1):end) = 0; 
end
bd = Ad * rand(N,1); 
assert(istril(Ad));
% bd = rand(N,1); 
xd = myLinsolveTril(Ad,bd); 
%%
Af = myFi(Ad); 
bf = myFi(bd); 
xf = myLinsolveTril(Af,bf);

%% Test Cholesky: Das passt noch gar nicht!!
A = gallery('lehmer',6);
R1 = chol(A); 
R2 = myChol(A); 


