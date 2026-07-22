function Skk=h_Sk_matrike(k,L) 
 % izracun matrik(i) B2-jev za izraèun krivljenja, b-ji so tridimenzionalne matrike s po numel(k(i)(i)) globino
 %k je stolpni vektor
 n=numel(k); % preberem k(i)olik(i)o je integracijsk(i)ih toèk(i)
 for i=1:n; % tvorjenje indeksa
% Sk(:,:,i) =...
%  [ 6*k(i)^2 - 6*k(i),           0,           0, L*(3*k(i)^2 - 4*k(i) + 1),                   0,                   0, 6*k(i) - 6*k(i)^2,           0,           0, -L*(2*k(i) - 3*k(i)^2),                0,                0
%            0, 6*k(i)^2 - 6*k(i),           0,                   0, L*(3*k(i)^2 - 4*k(i) + 1),                   0,           0, 6*k(i) - 6*k(i)^2,           0,                0, -L*(2*k(i) - 3*k(i)^2),                0
%            0,           0, 6*k(i)^2 - 6*k(i),                   0,                   0, L*(3*k(i)^2 - 4*k(i) + 1),           0,           0, 6*k(i) - 6*k(i)^2,                0,                0, -L*(2*k(i) - 3*k(i)^2)];
 
 Skk (:,:,i) =... 
[ 12*k(i) - 6,        0,        0, L*(6*k(i) - 4),           0,           0, 6 - 12*k(i),        0,        0, L*(6*k(i) - 2),           0,           0
        0, 12*k(i) - 6,        0,           0, L*(6*k(i) - 4),           0,        0, 6 - 12*k(i),        0,           0, L*(6*k(i) - 2),           0
        0,        0, 12*k(i) - 6,           0,           0, L*(6*k(i) - 4),        0,        0, 6 - 12*k(i),           0,           0, L*(6*k(i) - 2)];

 
 end 
% display(size(b1));
% b2=sparse(b2);



