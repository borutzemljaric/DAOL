function IzracunStaticnihKoordinatANCF_veter(ime_datoteke1)
%clear;
% del ki izraèuna še vetrovni dodatek k dodatnemu bremenu
%pause on

%% Branje datotek s podatki segmentacija,Bdi

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 

load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','db1_c','le','db','yy_js','zz_js',...
    'ne_i','izo','E_c','A_c','tipverige','e_zp','e_zp_s','DK','Dcc');  %shranjevanje variabel v to datoteko

load(ime_datoteke2,'Bdi','U','V','konstante','pari');  %Branje H matrik

load(ime_datoteke2, 'zacpog','zacpog_db','ime_datoteke1','e_zp','hh','ne_c','Qe','Qe_g');  %shranjevanje variabel v to datoteko
%load(ime_datoteke6, 'zacpog','zacpog_db','ime_datoteke1','e_zp','hh','ne_c','Qe','Qe_g','Qe_db');  %shranjevanje variabel v to datoteko

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
neodvisneV(:,1)=zacpog_db(V',1); %zapis v posebno datoteko ker so pri iteracijah konst.
%odvisneU(:,1)=e_zp(U',1); %tu je podatek o vseh neodvisnih skupaj s konstantami
odvisneU(:,1)=[zacpog_db(par_U(:,2),1);zacpog_db(konstante',1)]; %tu je podatek o vseh neodvisnih skupaj s konstantami, vrstni red je še odvisne+ konstante
% obrnem vrstni red da bodo v originalnem vrstnem redu (lahko mešano)
red=[par_U(:,3);par_K(:,3)]; %sestava vektorja vrstnega reda odvisnih v rezultatu 'pari'
odvisneU(red,1)=odvisneU; % zapis v originalni vrstni red
%stop
konstanteU(:,1)=e_zp(konstante',1);
%'pari' prikazuje povezavo med odvisnimi in neodvisnimi
pari=[];
pari.V=par_U(:,1);%vzamem prvo kolono ki nosi informacijo kje v V datoteki so pari z U koordinatami 
pari.U=par_U(:,2);%drugi stolpec nosi informacijo katera je odvisna koordinata
%display(V)

%% racun z dodajanjem vetra
Nkorakov=3;
display('Raèun z vetrom zacet')
    %display('Raèun nièelnega stanja koncan, prièetek racuna dodatnega bremena')
  %   Qe=Qe_g+Qe_db;  %dodatno breme dvigam po korakih
    
 for i=1:Nkorakov  %koraki ki jih doloèim poljubno za izraèun dodatnega bremena 
 %    Qe=Qe_g+Qe_db;  %dodatno breme dvigam po korakih
 
 DK.Ux=(i/Nkorakov)*Upom_x;%veter dvigam po korakih
 DK.Uy=(i/Nkorakov)*Upom_y;
 
 %VSTOP V ALGORITEM STATIÈNEGA IZRAÈUNA
 stevec=0;% zapišem da vstopim v spodnjo zanko
 pogoj=1; 
 
 while pogoj==1 && (stevec<20) %pogoj iz NR za reševanje RTcrt
  %% izraèun odvisne koordinate 
    % inicializacija
  exitflag=0; %redundanèni trenutno ne rabim
  exitflag_Niter=0;
 odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp);
 % stop
  %% raèunamje neodvisnih koordinat -ReTBbi=RTcrt
[neodvisneV,exitflag_Niter]=...
    neod_U(neodvisneV,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,Dcc,Bdi,pari,Qe,ne_i,tipverige,izo,DK);
 % stop

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
 
  %to je z dodatnim bremenom in vetrom
  odvisneU=odvi_U(odvisneU,hh,ne_c,neodvisneV,V,U,tipverige,e_zp); %priredim konène odvisne koordinate
  zacpog_db_W(U',1)=odvisneU;
  zacpog_db_W(V',1)=neodvisneV;
  zacpog_db_W(konstante',1)=konstanteU;   
 
%stop
%  %% priprava ice load v koènem simulacijskem stanju
%  
%  pom=db.span_z; %podatek v kateri razpetine se zaène dodatno breme prepisan v pomozno spremenljivko
%  db.span_z=db.odpad; %podatek do katere razpetine odpada dodatno breme
%  Qe_db=sparse(external_Qe(hh,ne_c,le,g,db.c,db,ne_i,tipverige));  % genarilizirana sila dodatnega bremna
%   db.span_z=pom; %vrnjen podatek nazaj
 
  %% klic funkcije za shranjevanje  
    shranjevanje
 

 %% KONEC CORE FUNKCIJE

 
%% funkcija shranjevanja
     function shranjevanje
   %       display(zacpog)
% display(zacpog-e_zp)
%ime_datoteke6=strcat('e_staticni_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
%save(ime_datoteke2, 'r','hh','sz','izolator','Lv','zacpog','zacpog_o','t','Z','FF','ime_datoteke1','FS');  %shranjevanje variabel v to datoteko

save(ime_datoteke2,'zacpog_db_W','-append');  %shranjevanje variabel v to datoteko
%display(ime_datoteke2)%display(ime_datoteke2)

display('End of static calculation - accreted ice + wind ');

% t=1:12:sv;
%  tocke_x=[(t+1)';sv-4];
%  tocke_y=[(t+2)';sv-3];
%  tocke_z=[(t+3)';sv-2];
% 
%  plot3(e_zp(tocke_x),e_zp(tocke_y),e_zp(tocke_z),'-.k+',zacpog(tocke_x),zacpog(tocke_y),zacpog(tocke_z),'-.b*',...
%      zacpog_db_W(tocke_x),zacpog_db_W(tocke_y),zacpog_db_W(tocke_z),'-.m*',zacpog_db(tocke_x),zacpog_db(tocke_y),zacpog_db(tocke_z),'-.g+');
% legend('e_{zp}','zacpog','zacpog_{db_W}','zacpog_{db}')
% %plot(e_zp(tocke_x),e_zp(tocke_y),'-.bx')
% %ylim([0 30])
     end   
 



end

