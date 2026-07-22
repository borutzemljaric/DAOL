function IB=Kt_T13(e,E,d,L)
% e mora biti stolpièni vektor
% funkcija drugi del integral IB- elastiène sile zaradi krivljenja

% prvi odvod S po ksiju kot Anonymous functions
Sk=@(k,L)... 
[ 6*k^2 - 6*k,           0,           0, L*(3*k^2 - 4*k + 1),                   0,                   0, 6*k - 6*k^2,           0,           0, -L*(2*k - 3*k^2),                0,                0
           0, 6*k^2 - 6*k,           0,                   0, L*(3*k^2 - 4*k + 1),                   0,           0, 6*k - 6*k^2,           0,                0, -L*(2*k - 3*k^2),                0
           0,           0, 6*k^2 - 6*k,                   0,                   0, L*(3*k^2 - 4*k + 1),           0,           0, 6*k - 6*k^2,                0,                0, -L*(2*k - 3*k^2)];
 
% dvojni odvod S po ksiju 
Skk =@(k,L)... 
[ 12*k - 6,        0,        0, L*(6*k - 4),           0,           0, 6 - 12*k,        0,        0, L*(6*k - 2),           0,           0
        0, 12*k - 6,        0,           0, L*(6*k - 4),           0,        0, 6 - 12*k,        0,           0, L*(6*k - 2),           0
        0,        0, 12*k - 6,           0,           0, L*(6*k - 4),        0,        0, 6 - 12*k,           0,           0, L*(6*k - 2)];
    
    
  
I=(pi*d^4*1e-12)/64;  %1e-12 pride iz pretvorbe mm v m

N=3; % število integracijskih toèk
s=1/(N+1):1/(N+1):1-1/(N+1); % stolpni vektor

f1=@(k,L,e) sqrt(sum((cross(Sk(k,L)*e,Skk(k,L)*e)).^2))/L^3;
g1=@(k,L,e) (sqrt(sum((Sk(k,L)*e).^2))/L)^3;
dkdk=@(k,L,e) (1/(g1(k,L,e)^2))*(g1(k,L,e)*odvod(@(e) f1(k,L,e),e)-f1(k,L,e)*odvod(@(e) g1(k,L,e),e));

 % kapa=f1/f2   
IB=(E*I*L/N)*((f1(s(1),L,e)/g1(s(1),L,e))*dkdk(s(1),L,e)+...
              (f1(s(2),L,e)/g1(s(2),L,e))*dkdk(s(2),L,e)+...
              (f1(s(3),L,e)/g1(s(3),L,e))*dkdk(s(3),L,e));

% rezultat je stolpièni vektor generaliziranih koordinat


%% funkcija jacobijeva matrika uporabljena za izraèun odvodov
 function J = odvod(fun, x)
 %    display((x))
dx = eps^(1/3); % finite difference delta
nx = numel(x); % degrees of freedom
nf = numel(fun(x)); % number of functions
J = zeros(nf,nx); % matrix of zeros 
for n = 1:nx
    % create a vector of deltas, change delta_n by dx
    delta = zeros(nx, 1); delta(n) = delta(n)+dx;
    dF = fun(x+delta)-fun(x-delta); % delta F
    %display(n)
    J(:, n) = dF(:)/dx/2; % derivatives dF/d_n
end

 end
end
 