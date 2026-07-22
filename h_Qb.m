function Qb=h_Qb(e,E,d,L)
% funkcija ki izraèuna energijo zaradi krivljenja
% gertmaister

% e=[0.0004
% 200
% 19.9971
% -0.6694
% 0
% 0.7451
% -0.9368
% 200
% 21.0404
% -0.6694
% 0
% 0.7453]
% L=1.4
% d=20
% E=36000
%Gauss_legendre kvadraturna integracija
k=[-0.774597/2+0.5; 0.5; 0.774597/2+0.5]; % odloèim se za 3 kvadraturne toèk (v stolpcu)
w=[0.555556; 0.888889; 0.555556]; % pripadajoèi kvadraturni koeficienti

%Ix=(pi*d^4*1e-12)/64;  %1e-12 pride iz pretvorbe mm v m
 % ker je E v N/mm2 in ga uporabljam v nadeljevanju, ze tukaj napravim
 % ureditev enot, zato pomnožim z 1e6
Ix=(pi*d^4*1e-6)/64;  %1e-12 pride iz pretvorbe mm v m

%% izraèunam matrike ki jih rabim v nadaljevanju
o=zeros(1,12);
eb=[e' o  o;o e' o;o  o  e'];
Skk=h_Sk_matrike(k,L); % vrne 3d za posamezne integracijske toèke
b1 =h_b1_matrike(k,L); % vrne 3d za posamezne integracijske toèke
B2 =h_b2_matrike(k,L);% vrne 3d za posamezne integracijske toèke
dcde=h_dcde; % vrne 3 d vendar gre za odvode po koordinatah od 1-12, samo enke in nièle predhodno izracunane
% display(size(e))

% priènem izraèun integrala v treh toèkah
for i=1:3; %ker imam predefinirane 3 integracijskih toèk
g=(e'*b1(:,:,i)*e)^(3/2);
dgde=3*(e'*b1(:,:,i)*e)^(1/2)*e'*b1(:,:,i)';
f_del=e'*Skk(:,:,i).'*eb*B2(:,:,i)*eb'*Skk(:,:,i)*e/L^4;
f=(f_del)^(1/2);
dfde_del=h_dfde(e,Skk(:,:,i),eb,B2(:,:,i),dcde); 
dfde=(f_del)^(-1/2)*dfde_del/2/L^4;
  % display(g)
%    display(f)
%    display(f_del)
 %  display((eb))
% st%    
%   
%   pause

if f==0
    dfde=zeros(1,12);  % da odpravim singularnost v numeriki
end
del_I(:,i)=f*(dfde*g-f*dgde)*w(i)*E*L*Ix/2/g^3; %vrniti mora matriko s 3 stolpci, 24 vrsticami

%display((del_I))
end
%   display((del_I))

%  st
Qb=sum(del_I,2); %izvedem sumacijo po vrsticah, tako da dobim stolpni vektor
% display(Qb)
% pause

function dfde_del=h_dfde(e,Skk,eb,B2,dcde)  % posebej racunam odvod
for ii=1:12
    dfde_del(ii)=Skk(:,ii)'*eb*B2*eb'*Skk*e+...
              e'*Skk'*dcde(:,:,ii)'*B2*eb'*Skk*e+...
            e'*Skk'*eb*B2*dcde(:,:,ii)*Skk*e+...
            e'*Skk'*eb*B2*eb'*Skk(:,ii);
end
% display(size(dfde_del))
% st
end
end