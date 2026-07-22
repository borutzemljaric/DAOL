function FS1_statikaANCF
% 1 Reading data 
clear;
disp("Reading data")
[N,ime_datoteke1,vrv_c,izo,db,DK]=Odpri_menu;  %klicanje funkcije vhodnih podatkov

%2 Line segmentation
disp("Overhead line segmentation")
segmentacija_ANCF(N,ime_datoteke1,vrv_c,izo,db,DK)  %izvajanje segmentacije

%3 Calculate Jacobian determinant Ce
disp("Prepare Jacobian")
Ce_3_aktivnekoordinate(ime_datoteke1)  % izvajanje izraèuna Jkobijeve determinante Ce

%4 Calculate dependent/independent coordinates
disp("Determine dependant/independent coordinates")
B_matrix(ime_datoteke1)  % izvajanje izraèuna odvisne/neodvisne koordinate

%5 % Calculate dependent/independent coordinates
disp("Calculating coordinates")
% only accreted ice
IzracunStaticnihKoordinatANCF(ime_datoteke1)  %izraèun statiènih koordinat without 
% to accreted ice the wind load is added
IzracunStaticnihKoordinatANCF_veter(ime_datoteke1)

% 6 Prepare mass matrix and H matrices for dynamic calculation
disp("Prepare mass matrix and H matrices")
H_M_matrike(ime_datoteke1)  %priprava masne matrike in H matrik za dinamièni izraèun

%7 Prepare mass matrix and H matrices for dynamic calculation
disp("Calculate  reactions forces")
reakcijeVerige(ime_datoteke1)

disp("End of static program")  

 

%% branje podatkov o trasi in doloèitev podatkov vodnika

function [N,ime_datoteke1,vrv_c,izo,db,DK]=Odpri_menu

%A klicanje zunanje datoteke z vhodnimi podatki o daljnovodnem polju
% [ime_datoteke1, pathname] = ...
%      uigetfile({'*.txt';'*.m';'*.mat';'*.*'},'Izberi datoteko z vhodnimi podatki');

% CHOSE YOUR FILE
  ime_datoteke1='TestFileSingle.txt'  
  %ime_datoteke1='TestFile.txt' 
  ime_datoteke1='TestFile_V.txt' 
  ime_datoteke1='TestFile_3spans.txt' 
 

fid=fopen(ime_datoteke1,'rt');

% tip, oznaka,   x, y, a, z, visina, l verige, masa, utez, povrsina, odklon, tipverige, vodnik, stevilo, nateg, zas_vrv, nateg, tlak, breme (kg/m),delitev elementov, kot trase       																			
N = textscan(fid, '%s %n %n %n %n %n %n %n ');

%[n,s1]=size(N    
fclose(fid);

[pathstr, ime_datoteke1, ext] = fileparts(ime_datoteke1);  % filename without extension
%KONEC A

%**************************************** 
%branje podatkov o vodnikih
%****************************************


%% B. klicanje in branje datoteke z vhodnimi podatki vrvi
%%koda, naziv vrvi, S [mm2], d [mm], m [daN/m], E [N/mm2], alfa, S [daN/mm2]							
%podatki vodnika
% vrv_pc=['243-AL1/39-A20SA'];
% vrv_c=[282.5 21.84 0.933 74250 19.9 20.8 15'];


  vrv_pc=['122-AL1/20-ST1A'];
  vrv_c=[141.4 15.5 0.491 77000 18.9 0.02 3];
  
% vrv_pc=['243-AL1/39-ST1A'];
% vrv_c=[282.5 21.8 0.980 77000 18.9 20.8 15'];
% vrv_pc=['morgan'];
% vrv_c=[227.4 19.6 0.85 91785 18.9 20.8 15'];
% vrv_c=[227.4 19.6 0.95 91785 18.9 20.8 15'];%morgan z opremo
%podatki za vodnik iz Fekr
% vrv_pc=['hydroquebec600'];
% vrv_c=[607 27.8 1.522 68300 18.9 12.7 15'];
%   vrv_pc=['122-AL1/20-ST1A'];
%   vrv_c=[141.4 15.5 0.491 77000 18.9 20.8 15'];
%KONEC B

%% podatki o izolatorskih verigah za razliène tipe
% l_i(m) m_i(kg/m) d_i(mm) dzun_i  E (N/mm2)
%izo.izo_i=[2.1 7 22 100 68300];
%izo.izo_i=[2.1 40 22 100 210000]; % za primer morgan
izo.izo_i=[1.9 0.4 22 100 37000 80]; % za primer morgan

% upoštevaj v vhodnih podatkih dolžino verige( zaenkrat ga program ne
% odšteva avtomatsko (da ne vnašam podatkov dvakrat)


% l_i(m) m_i(kg/m) d_i(mm) dzun_i E theta_v
izo.izo_V=[1.9 0.4 22 100 37000 80];
 
% l_i(m) m_i(kg/m) d_i(mm) lb_i(m) E theta_p 
izo.izo_P=[1.55 1 63 100 37000 12];

% l_i(m) m_i(kg/m) d_i(mm) lb_i(m) theta_Vi theta_pi theta_bi E
izo.izo_B=[1.4 0.4 22 100 37000 57];
%izo_B=[1.4 0.4 63 100 37000 60];

%sprememba dolžine izolatorja da bo steber raven
izo.izo_B(1,1)=izo.izo_P(1,1)*cosd(izo.izo_P(1,6))/cosd(izo.izo_B(1,6)-izo.izo_P(1,6));


% l_sp(m) m_sp(kg/m) dpeq(mm) A(mm2) E (N/mm2)
izo.st_pole=[13 77 250 7360 210000];
%izo_B=[1.4 0.4 63 100 37000 60];

% podatki za A verigo (najprej podatki za izolator, zatem podatki za
% železo)
% l_i(m) m_i(kg/m) d_i(mm) E  l_s(m) m_s(kg/m) d_s(mm) E
izo.izo_A=[1.6 0.4 22 37000 1.3 7.6 35.6 210000];  % velja za jekleni vmesnik
%izo.izo_A=[1.6 0.4 22 37000 1.3 0.98 22 77000];  % velja za žico,brez vmesnika
%izo.izo_A=[1.6 0.4 22 37000 0.9 7.6 35.6 210000];  % velja za jekleni vmesnik
%izo.izo_A=[1.6 0.4 22 37000 0.01 7.6 35.6 235000];
%izo_B=[1.4 0.4 63 100 37000 60];

% podatki za iB izolacijo
% l_i(m) m_i(kg/m) d_i(mm) lb_i(m) E  
izo.izo_IP=[1.9 0.4 22 100 37000 ];
% l_i(m) m_i(kg/m) d_i(mm) lb_i(m)  E kN/mm2
izo.izo_IB=[2.523 0.4 22 100 37000];
%izo_B=[1.4 0.4 63 100 37000 60];


% oznaèevanje v vhodnih podatkih
% 1- navaden I izolator
% 2- V veriga
% 3- PB (post brace)
% 4- PB z upoštevanjem stebra
% 5- A veriga
% 6- pol V veriga - IB

%% podatki o vetru in koeficientih dušenja  

% velja za vse razpetine
U=0 %   wind velocity m/s
% kot med y osjo in vetrom, vedno lezi v xy ravnini
alfa=(pi/2)
%alfa=(0)  % wind attack angle

DK=[];
DK.Uy=U*cos(alfa); %hitrost vetra/ pazi vhodni kot v rad
DK.Ux=-U*sin(alfa); %hitrost vetra smer y
% smer Uz=0 po definiciji

DK.rw =1.224; % gostota zraka
DK.cdt=0.1; DK.cdn=1.2; DK.cdb=1.2; % drag koeficienti
%DK.ckt=.02; DK.ckn=.02; DK.ckb=.02; % damp koeficienti
%% podatki o dusenju
ksi=[0.02]; % zaenkrat je pisana še posebej da ohranim funkcije!
DK.ksi=ksi;

DK.alfadamp= 0.162  % damping coefficient alpha, goes into Qdamp
DK.betadamp= 0.0013 % damping coefficient beta


%% podatki o lokaciji bremena

 %db.c=4.2  % podatek o masi na dolžinsko enoto (pazi kg/m)
 db.c=2.6; % accreated ice mass per unith length, if there is no ice value is 0

 db.d=170; % premer dodatnega bremena v (mm) za izraèun vetrovnega pritiska, increased diameter because of ice load
 %db.c=0  % podatek o masi na dolžinsko enoto (pazi kg/m)
 db.d=vrv_c(1,2); % premer dodatnega bremena v (mm) za izraèun vetrovnega pritiska, bare conductor

 
% fraction of span with load, leave as they are! ( same for every span!)
 db.z=0.01;%podatki lokacije zaèetka dodatnega bremena v deležu(%*100) razpetine
 db.k=1.; %podatki lokacije konca dodatnega bremena deležu(%*100) %meje dodatnega bremena


db.odpad=3; %%podatek do katere razpetine odpada dodatno breme/ zaenkrat možno samo kontinuirano do te razpetine (span left hand side)

db.span_z=1 %span where addition load starts (span left hand side)
db.span_k=3  %span where addition load ends (span right hand side)
%db.span_z=3; %podatek v kateri razpetine se zaène dodatno breme
%db.span_k=3;  %podatek v kateri razpetine se konèa dodatno breme

end% Konec  funkcija Odpri 
 
 
end