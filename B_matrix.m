function B_matrix(ime_datoteke1)
%funkcija ki doloèi odvisne U in neodvisne V spremenljivke 
%verzija 03.01.14
%% Branje datoteke s podatki segmentacije
%  [ime_datoteke, pathname] = ...
%       uigetfile({'*.mat','*.*'},'File Selector');  %vneseš datoteko z vhodnimi podatki

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat');
load(ime_datoteke2,'ime_datoteke1','Ce_active','Ce_1_active','konstante','neod_fix');

% ime_datoteke2=strcat('Ce_active_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
% load(ime_datoteke2,'Ce_active','Ce_1_active');  %Branje Jacobian matrike
% display(Ce_active)
% stop
%display(Ce)
%[nc,n]=size(Ce); 
%display(konstante)

[U V Ce]=UV_clenitev(Ce_active,konstante,neod_fix);  %klicanje funkcije
% display(U)
% display(active_U)
% display(V)
% display(active_Ce)
% stop
%U odvisne spremeljivka
%V  neodvisna spremenljivka
%index=[U V] % sestava skupnega indeksa
% display('število odvisnih spremenljivk')
% [ndv,nd]=size(U)
% display('stevilo neodvisnih spremenljivk')
% [niv,ni]=size(V)
% %display(full(Ce))
% U=setdiff(U,konstante); %izloèim konstante iz matrike odvisnih

%% razdelitev jakobian matrike v dve (Ced odvisna in Cei neodvisna)
%Ce_u=Ce_u(:,index(:,:)'); % preurejena matrika iz gausove eliminacije urejena v vrstni red odvisnih in neodvisnih spremenljivk
%Ce_u=Ce(:,index(:,:)'); % preurejena matrika Ce v vrstni red odvisnih in neodvisnih spremenljivk
%display(full(Ce_u))
[nc,n]=size(Ce); 
Ced=Ce(:,1:nc);
Cei=Ce(:,nc+1:n);
%display(size(Ced)); % število odvisnih spremenljivk- naèeloma enako številu omejitev
%display(size(Cei)); % število neodvisnih spremenljivk
%Cdi=-inv(Ced)*Cei
Cdi=-Ced\Cei;
%display(size(Cdi));
I=eye(n-nc:n-nc); %doloèitev enotske matrike
Bdi=[I;Cdi];
% display(U)
% display(V)
% display(size(Bdi))
% display(Bdi)
%display('konec racuna Bdi')
% index=[1:n];  % vpeljem pomožno matriko da spremljam index spremenljivke
[r,c] = find(Bdi(n-nc+1,:));  %za prvo odvisno pred vstopom v zanko
%display(r)
if norm(r)==0&&norm(c)==0   %kjer ni para vpisem 0 da obdržim indeks odvisnih
    c=0;
   % display('prazma')
end

for i=n-nc+2:n
[ra,ca] = find(Bdi(i,:));
   if norm(ra)==0&&norm(ca)==0
    ca=0;
   % display('prazma2')
   end
c=[c;ca];
end
%display(c)
pari=[c,U'];  %prvi stolpec index koordinat odvisne in drugi stolpec index pripadajoèe neodvisne koordinate
%pari=c;  %prvi stolpec index koordinat odvisne in drugi stolpec index pripadajoèe neodvisne koordinate
%% shranjevanje izraèuna v datoteko
%ime_datoteke2=strcat('Bdi_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'ime_datoteke1','Bdi','U','V','konstante','pari','Cdi','Ced','Ce','-append');  %shranjevanje variabel v to datoteko
display('End of Determine dependant/independent coordinates');
  
end
