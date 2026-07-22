function Qg=Qg(g,m,L)
% g=9.81;
Qg = -g*m*...
[ 0,   0, L/2,          0,          0, L^2/12,   0,   0, L/2,       0,       0, -L^2/12];
end
 