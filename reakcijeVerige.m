function reakcijeVerige(ime_datoteke1)
% clear;
% pause on 
%% Branje datotek s podatki M,H, Bdi,Ce_active,db

% branje izhodnih podatkov iz dinamike
 % [ime_datoteke1, pathname] = ...
  %     uigetfile({'*.mat','*.*'},'File Selector');  %vneseš datoteko z vhodnimi podatki _lahko rezultat M
%odpiraš s datoteko e_statièni_xxxx
%  ime_datoteke1='kolutOdsek33_38'

% ime_datoteke1='kranjska_P.txt'
% ime_datoteke1='kranjska_V.txt'
%ime_datoteke1='morgan10'

ime_datoteke2=strcat('ySTAT_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
load(ime_datoteke2, 'zacpog','zacpog_db','zacpog_db_W','ime_datoteke1','e_zp','hh','ne_c','Qe','Qe_g');


%ime_datoteke2=strcat('segmentacija_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice 
load(ime_datoteke2, 'ime_datoteke1','hh','ne_c','m_c','d_c','le','db','yy_js','zz_js',...
    'ne_i','izo','E_c','A_c','tipverige','e_zp','e_zp_s','DK','Dcc');  %shranjevanje variabel v to datoteko
 
%ime_datoteke2=strcat('Ce_active_',ime_datoteke1,'.mat');
load(ime_datoteke2,'ime_datoteke1','Ce_active','Ce_1_active','konstante','neod_fix');

  %shranjevanje variabel v to datoteko
%ime_datoteke2=strcat('Bdi_',ime_datoteke1,'.mat'); %sestavljanje imena datoteke in koncnice
load(ime_datoteke2,'ime_datoteke1','Bdi','U','V','konstante','pari');   %Branje 



%% klic za izraèun vrednosti zunanjih sil (Ke-Qg)
% Re=Qe_Ke_matrika(zacpog,hh,ne_c,E_c,A_c,le,d_c,Qe,ne_i,tipverige,izo_i,izo_V,kolut); % klic funkcije ki vrne vektor 
% Re=Qe_Ke_matrika_verige(ei,konstanteU,hh,ne_c,V,U,konstante,E_c,A_c,le,d_c,Bdi,pari,Qe,ne_i,tipverige,izo_i,izo_V,izo_P,izo_B)  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)

%   DK.Ux=0; % postavitev n niè ker dodajam veter po korakih
%   DK.Uy=0;
%Qe=Qe_g;

%% racunam sile z dodatnim bremenom
%V priemru da želim brez moraš dati aktivirati vstico 39 in spremeniti zacpog


Re=Qe_Ke_matrika_verige(zacpog_db,hh,ne_c,E_c,A_c,le,Dcc,Qe,ne_i,tipverige,izo,DK);  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)

%display(size(Re))

Qc=Re;  % samo prepišem da ne popravljam programa v nadaljevanju
[Flevo Fdesno]=sileMomenti(Qc); %zunanja funkcija
    
%% izracunam se sile pri zaèetnem pogoju (brez bremena in vetra)
Qe=Qe_g;
DK.Uy=0; %hitrost vetra/ pazi vhodni kot v rad
DK.Ux=0; %hitrost vetra smer y
Re=Qe_Ke_matrika_verige(zacpog,hh,ne_c,E_c,A_c,le,Dcc,Qe,ne_i,tipverige,izo,DK);  %tvorjenje relativnega raztezka za korak t-1 (en korak nazaj)
Qc=Re;  % samo prepišem da ne popravljam programa v nadaljevanju
[Folevo Fodesno]=sileMomenti(Qc); %zunanja funkcija

%% shranjevanje sil reakcij v datoteko

ime_datoteke2=strcat('ySTAT_',ime_datoteke1); %sestavljanje imena datoteke in koncnice
save(ime_datoteke2, 'ime_datoteke1','hh','ne_c','tipverige','zacpog','zacpog_db','zacpog_db_W','Flevo','Fdesno','Folevo','Fodesno','e_zp','le','-append');  %shranjevanje variabel v to datoteko
%display(ime_datoteke2)


display('End of Calculate  reactions forces');


end

