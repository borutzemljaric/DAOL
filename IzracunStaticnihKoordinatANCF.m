function IzracunStaticnihKoordinatANCF(ime_datoteke1)
%clear;
pause on

%% Branje datotek s podatki segmentacija,Bdi

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
%load(ime_datoteke2, 'ime_datoteke1','M','M_1','Qg','C','e_zp','db1_c','l_0','ne_c','hh');  %shranjevanje variabel v to datoteko
%display(ime_datoteke1)
load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','le','db','yy_js','zz_js',...
    'ne_i','izo','E_c','A_c','tipverige','e_zp','e_zp_s','DK','Dcc');  %shranjevanje variabel v to datoteko

load(ime_datoteke2,'Bdi','U','V','konstante','pari');  %Branje H matrik

%display(Q_iice)
 g=9.81;  %m/s2


 Upom_x=DK.Ux; %prepis vetra v svojo spremenljivko
 Upom_y=DK.Uy;
  DK.Ux=0; % postavitev n niè ker dodajam veter po korakih
  DK.Uy=0;
 
%% statièni izraèun
% a izraèun odvisnik koordinat s formulo C(e)=0
 %display(size(U))
%  display((U'));  % u je prvotno v vrstici zato transponiram, da gre v stolpec)
%  display((V'));
%display(konstante)

[ n_d ndv]=size(U');
[ n_i niv]=size(V');
[sv,ss]=size(e_zp); %doloèitev števila ANCF kooordinat

[par_K par_U]=ureditevparov(pari);   %ureditev parov -klicanje funkcije

%v pomožno matriko da izloèim vnaprej doloèene neodvisne koordinate%display(e_zp)
%stop
%zacpog(:,1)=e_zp(U',1); %zaèetni pogoji odvisnih spremenljivk
neodvisneV(:,1)=e_zp(V',1); %zapis v posebno datoteko ker so pri iteracijah konst.
%odvisneU(:,1)=e_zp(U',1); %tu je podatek o vseh neodvisnih skupaj s konstantami
odvisneU(:,1)=[e_zp(par_U(:,2),1);e_zp(konstante',1)]; %tu je podatek o vseh neodvisnih skupaj s konstantami, vrstni red je še odvisne+ konstante
% obrnem vrstni red da bodo v originalnem vrstnem redu (lahko mešano)
red=[par_U(:,3);par_K(:,3)]; %sestava vektorja vrstnega reda odvisnih v rezultatu 'pari'
odvisneU(red,1)=odvisneU; % zapis v originalni vrstni red
konstanteU(:,1)=e_zp(konstante',1);
%'pari' prikazuje povezavo med odvisnimi in neodvisnimi
pari=[];
pari.V=par_U(:,1);%vzamem prvo kolono ki nosi informacijo kje v V datoteki so pari z U koordinatami 
pari.U=par_U(:,2);%drugi stolpec nosi informacijo katera je odvisna koordinata
%display(V)
% display(e_zp)
% display('pari')
% display(par_U)
% display(pari)
%  display(pari.V)
%    display(pari.U)
%  display(red)
%  display(odvisneU)
%  display(neodvisneV)
% st

% display(size(odvisneU));
 
%% doloèitev zunanjih sil
% podatki o lokaciji bremena
% db.c=db1_c  % podatek o masi na dolžinsko enoto (pazi kg/m)
% %db.c=1  % za test
% db.z=0;%podatki lokacije zaèetka dodatnega bremena v % razpetine
% db.k=0.5; %podatki lokacije konca dodatnega bremena%meje dodatnega bremena
% 
% db.span_z=1; %podatek v kateri razpetine se zaène dodatno breme
% db.span_k=1;  %podatek v kateri razpetine se konèa dodatno breme

% generalizirane gravitacijske sile samo za vodnik

Qe_g=sparse(gravitation_Qe(hh,ne_c,le,g,m_c,ne_i,tipverige,izo)); % sila gravitacije (vseskozi enaka za vse elemente)
% generalizirane gravitacijske sile za led/ zaèetna iteracija ki je enaka

Qe_db=zeros(size(Qe_g));
 
Nkorakov=1;
display('Start of static calculation')
display('Start of initial case- no load on conductors')

for racun=1:2  %zanka da raèunam najprej èisto brez dodatnega bremena in zatem z dodatnim bremenom
    %display('Raèun nièelnega stanja koncan, prièetek racuna dodatnega bremena')
    if racun==2  %doda še velikost dodatnega bremena
 %       display(zacpog)
%        stop
        display('End of no load calculation, start adding load on conductors')
   Qe_db=sparse(external_Qe(hh,ne_c,le,g,db.c,db,ne_i,tipverige));  % generilizirana sila dodatnega bremna
   %Qe_skupni=Qe_g+Qe_db;
   Nkorakov=3; %koraki ki jih doloèim poljubno za izraèun dodatnega bremena da dosežem konvergenco
    end
%stop
 
% display(size(Qe_g))
% display(size(Qe_db))
 for i=1:Nkorakov  %koraki ki jih doloèim poljubno za izraèun dodatnega bremena 
     Qe=Qe_g+(i/Nkorakov)*Qe_db;  %dodatno breme dvigam po korakih
  DK.Ux=0;%veter dvigam po korakih
 DK.Uy=0;
 %VSTOP V ALGORITEM STATIÈNEGA IZRAÈUNA
 stevec=0;% zapišem da vstopim v spodnjo zanko
 pogoj=1; 
 
 while pogoj==1 && (stevec<20) %pogoj iz NR za reševanje RTcrt
  %% izraèun odvisne koordinate 
    % inicializacija
  exitflag=0; %redundanèni trenutno ne rabim
  exitflag_Niter=0;
 odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp);
  %% raèunamje neodvisnih koordinat -ReTBbi=RTcrt
[neodvisneV,exitflag_Niter]=...
    neod_U(neodvisneV,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,Dcc,Bdi,pari,Qe,ne_i,tipverige,izo,DK);

  %% povratna zanka èe je število iteracij preseženo
  if exitflag==0&&exitflag_Niter==0
      %exitflag=== pomeni da je racun ok in nipotrebno nazaj v zanko
       pogoj=5;  %s tem zapustim zanko while in grem na zapis rešitev
   else %èe pogoj ni izpolnjen grem na zeèetek s ten da fiksiram prej izraèunanne ei
     pogoj=1;
     stevec=stevec+1;  %šteještevlo povratkov
 %    display('povratna zanka deluje')
 %    display(stevec)
    end
 %zapis izraèunanih neodvisnih koordinat na prvotne lokacije
 %display(output.stepsize)
%  neodvisneV=ei1+output.stepsize %zapis v posebno datoteko ker so pri iteracijah konst.
%  odvisneU=ed1;
  end  % konec while celotni
  
 %KONEC ALGORITEM STATIÈNEGA IZRAÈUNA ZA EN KORAK ZUNANJE SILE
% b=b+bk;
% a=a+ak;
 end  %konec šeštevanja zunanje sile
 
 %% priprava shranjevanje vektorja statiènega zaèetnega stanja
 if racun==1  %to je brez dodatnega bremena 
  odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp); %priredim konène odvisne koordinate
  zacpog(U',1)=odvisneU;
  zacpog(V',1)=neodvisneV;
  zacpog(konstante',1)=konstanteU;
 else  %to je z dodatnim bremenom
  odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp); %priredim konène odvisne koordinate
  zacpog_db(U',1)=odvisneU;
  zacpog_db(V',1)=neodvisneV;
  zacpog_db(konstante',1)=konstanteU;   
 end
end  %konec za zanko raèuna z ali brez dodatnega bremena
%stop


 %% KONEC CORE FUNKCIJE

  DK.Ux=Upom_x; %prepis vetra nazaj na izvorno vrednost
 DK.Uy=Upom_y;
 
 %% priprava ice load v koènem simulacijskem stanju
 
 pom=db.span_z; %podatek v kateri razpetine se zaène dodatno breme prepisan v pomozno spremenljivko
 db.span_z=db.odpad; %podatek do katere razpetine odpada dodatno breme
 Qe_db=sparse(external_Qe(hh,ne_c,le,g,db.c,db,ne_i,tipverige));  % genarilizirana sila dodatnega bremna
  db.span_z=pom; %vrnjen podatek nazaj

  %% klic funkcije za shranjevanje  
    shranjevanje
 
%% funkcija shranjevanja
     function shranjevanje

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'zacpog','zacpog_db','ime_datoteke1','e_zp','hh','ne_c','Qe','Qe_g','Qe_db','DK','-append');  %shranjevanje variabel v to datoteko
%display(ime_datoteke2)%display(ime_datoteke2)


display('End of static calculation - accreted ice ');


%t=1:12:sv;
%tocke_x=[(t+1)';sv-4];
%tocke_y=[(t+2)';sv-3];
%plot(zacpog(tocke_x),zacpog(tocke_y),'-.r*',e_zp(tocke_x),e_zp(tocke_y),'-.bx',zacpog_db(tocke_x),zacpog_db(tocke_y),'-.g+');
%plot(e_zp(tocke_x),e_zp(tocke_y),'-.bx')
%ylim([0 30])

     end   
 



end

