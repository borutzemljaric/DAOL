function IA=Kl_L13(e,E,A,L)
% e mora biti stolpièni vektor
% funkcija prvi del integral IA- elastiène sile zaradi raztezka

%Anonymous functions
% prvi odvod S po ksiju
Sk=@(k,L)... 
[ 6*k^2 - 6*k,           0,           0, L*(3*k^2 - 4*k + 1),                   0,                   0, 6*k - 6*k^2,           0,           0, -L*(2*k - 3*k^2),                0,                0
           0, 6*k^2 - 6*k,           0,                   0, L*(3*k^2 - 4*k + 1),                   0,           0, 6*k - 6*k^2,           0,                0, -L*(2*k - 3*k^2),                0
           0,           0, 6*k^2 - 6*k,                   0,                   0, L*(3*k^2 - 4*k + 1),           0,           0, 6*k - 6*k^2,                0,                0, -L*(2*k - 3*k^2)];
 
% dvojni odvod S po ksiju 
% Skk =@(k,L)... 
% [ 12*k - 6,        0,        0, L*(6*k - 4),           0,           0, 6 - 12*k,        0,        0, L*(6*k - 2),           0,           0
%         0, 12*k - 6,        0,           0, L*(6*k - 4),           0,        0, 6 - 12*k,        0,           0, L*(6*k - 2),           0
%         0,        0, 12*k - 6,           0,           0, L*(6*k - 4),        0,        0, 6 - 12*k,           0,           0, L*(6*k - 2)];
    
    
    Depsde=@(k,L,e) (e')*(Sk(k,L).')*Sk(k,L)/(L^2);
    epsi=@(k,L,e) (((e')*(Sk(k,L).')*Sk(k,L)*e/(L^2))-1)/2;

    N=5; % število integracijskih toèk
    s=1/(N+1):1/(N+1):1-1/(N+1); % stolpni vektor
%     display(eps(s(5),L,e))
%      display(Depsde(s(1),L,e))
%      display(Depsde(s(3),L,e))
%  
    % da poenostavim program pišem vseh pet integracijskih toèk posebej i
    % šeštejem
    IA=(E*A*L/(2*N))*(epsi(s(1),L,e)*Depsde(s(1),L,e)+epsi(s(2),L,e)*Depsde(s(2),L,e)+...
    epsi(s(3),L,e)*Depsde(s(3),L,e)+epsi(s(4),L,e)*Depsde(s(4),L,e)+epsi(s(5),L,e)*Depsde(s(5),L,e));

IA=IA'; % rezultat je stolpièni vektor generaliziranih koordinat


 