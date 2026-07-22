function Qs=h_Qs(e,E,A,L)
% funkcija ki izraèuna energijo zaradi raztezka
% po gertmaister %Strain energy


% display(size(e))
% izpeljava_risanjeElementa(e,L)


%Gauss_legendre kvadraturna integracija
k=[-0.90618/2+0.5; -0.538469/2+0.5; 0.5; 0.538469/2+0.5; 0.90618/2+0.5]; % odloèim se za 5 kvadraturnih toèk (v stolpcu)
w=[0.236927; 0.478629; 0.568889; 0.478629; 0.236927]; % pripadajoèi kvadraturni koeficienti

% izraèunam matrike b
[b1] =h_b1_matrike(k,L);

skupno=E*A*L/2;   
for i=1:5; %ker imam predefiniranih 5 integracijskih toèk
del_I1(:,i)=(e'*b1(:,:,i)'*(e'*b1(:,:,i)*e-1))*w(i)/2; %vrniti mora matriko s 5 stolpci, 12 vrsticami
end

%
Qsk1=sum(del_I1,2); %izvedem sumacijo po vrsticah, tako da dobim stolpni vektor
Qs=Qsk1*skupno;


end